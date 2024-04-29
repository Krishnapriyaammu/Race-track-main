import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginrace/Racetrack/approvereject.dart';
import 'package:loginrace/Racetrack/navigationracetrack.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InstructorHomePage(),
    );
  }
}

class InstructorHomePage extends StatefulWidget {
  const InstructorHomePage({Key? key}) : super(key: key);

  @override
  State<InstructorHomePage> createState() => _InstructorHomePageState();
}

class _InstructorHomePageState extends State<InstructorHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  File? _selectedImage;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coach Management'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.person_add), text: 'Add Coaches'),
            Tab(icon: Icon(Icons.people), text: 'View Users'),
            Tab(icon: Icon(Icons.approval_outlined), text: 'Accepted Users'),
             Tab(icon: Icon(Icons.feedback), text: 'Feedback Users'),

          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Add Coaches
          CoachTab(selectedImage: _selectedImage),

          // Tab 2: View Users
          UserTab(),

          // Tab 3: Feedback & Ratings
          AcceptedUser(),



          FeedbackTab(),
        ],
      ),
    );
  }
}

class CoachTab extends StatelessWidget {
  Future<List<DocumentSnapshot>> getData() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      var a = sp.getString('uid');

      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('race_track_add_coach')
          .where('uid', isEqualTo: a)
          .get();
      print('Fetched ${snapshot.docs.length} documents......');
      return snapshot.docs;
    } catch (e) {
      print('Error fetching data: $e');
      throw e;
    }
  }

  var profileImage;
  XFile? pickedFile;
  File? image;
  final File? selectedImage;
  var name = TextEditingController();
  var about = TextEditingController();
  var exp = TextEditingController();
  String imageUrl = '';

  CoachTab({Key? key, this.selectedImage}) : super(key: key);

 void showDeleteConfirmationDialog(BuildContext context, String coachId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this coach?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Delete coach detail from Firestore
                await FirebaseFirestore.instance.collection("race_track_add_coach").doc(coachId).delete();
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
            future: getData(),
            builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    final document = snapshot.data![index];
                    //  final id = snapshot.data![index].id;
                    //  print(id);
                    final data = document.data() as Map<String, dynamic>;
                    final imageUrl = data['image_url'];
                    return ListTile(
                      title: Text(data['name'] ?? 'Name not available'),
                      subtitle: Column(
                        children: [
                          Text(data['about'] ?? 'Name not available'),
                          Text(
                              data['experience'] ?? 'experience not available'),
                        ],
                      ),
                      leading: imageUrl != null
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(imageUrl),
                              radius: 30,
                            )
                          : CircleAvatar(
                              child: Icon(Icons.person),
                              radius: 30,
                            ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _showEditCoachDialog(context, {
                                'docId': document.id,
                                'name': data['name'],
                                'about': data['about'],
                                'experience': data['experience'],
                                'image_url': imageUrl,
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDeleteConfirmationDialog(
                                  context, document.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
        // Add Coach Button at the bottom
        ElevatedButton(
          onPressed: () {
            // Open a dialog to add a coach
            _showAddCoachDialog(context);
          },
          child: Text('Add Coach'),
        ),
      ],
    );
  }

  // Function to show the add coach dialog
  void _showAddCoachDialog(BuildContext context) {
    String? selectedExperience;
    List<String> experiences = ['0-2 years', '2-5 years', '5+ years'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                title: Text('Add Coach'),
                content: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        ImagePicker picker = ImagePicker();
                        pickedFile =
                            await picker.pickImage(source: ImageSource.gallery);

                        setState(() {
                          if (pickedFile != null) {
                            profileImage = File(pickedFile!.path);
                          }
                        });
                      },
                      child: ClipOval(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: profileImage != null
                              ? FileImage(profileImage)
                              : null,
                          child: profileImage == null
                              ? Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                )
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: name,
                      decoration: InputDecoration(
                        hintText: 'Name',
                      ),
                    ),
                    SizedBox(height: 16),
                    DropdownButton<String>(
                      value: selectedExperience,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedExperience = newValue;
                        });
                      },
                      items: experiences
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      hint: Text('Select Experience'),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: about,
                      decoration: InputDecoration(
                        hintText: 'About the Coach',
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Reference storageReference = FirebaseStorage.instance
                          .ref()
                          .child(
                              'images/${DateTime.now().millisecondsSinceEpoch}.jpg');

                      await storageReference.putFile(profileImage!);

                      String imageUrl = await storageReference.getDownloadURL();
                      await uploadImage();
                      SharedPreferences sp =
                          await SharedPreferences.getInstance();
                      var a = sp.getString('uid');

                      DocumentReference coachRef = await FirebaseFirestore
                          .instance
                          .collection("race_track_add_coach")
                          .add({
                        'name': name.text,
                        'about': about.text,
                        'experience': selectedExperience,
                        'image_url': imageUrl,
                        'uid': a,
                        'coach_id': '',
                      });
                      String coachId = coachRef.id;
                      await coachRef.update({'coach_id': coachId});

                      print('Add Coach');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return InstructorHomePage();
                        }),
                      );

                      // Navigator.of(context).pop();
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future<void> uploadImage() async {
    try {
      if (profileImage != null) {
        Reference storageReference =
            FirebaseStorage.instance.ref().child('image/${pickedFile!.name}');

        await storageReference.putFile(profileImage!);

        // Get the download URL
        imageUrl = await storageReference.getDownloadURL();

        // Now you can use imageUrl as needed (e.g., save it to Firestore)
        print('Image URL: $imageUrl');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  void _showEditCoachDialog(
    BuildContext context, Map<String, dynamic> coachData) {
  String? selectedExperience;
  List<String> experiences = ['0-2 years', '2-5 years', '5+ years'];

  // Set initial values for the fields
  TextEditingController name = TextEditingController(text: coachData['name']);
  TextEditingController about = TextEditingController(text: coachData['about']);
  selectedExperience = coachData['experience'];

  XFile? pickedFile;
  File? profileImage;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: Text('Edit Coach'),
              content: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      ImagePicker picker = ImagePicker();
                      pickedFile = await picker.pickImage(
                        source: ImageSource.gallery,
                      );

                      setState(() {
                        if (pickedFile != null) {
                          profileImage = File(pickedFile!.path);
                        }
                      });
                    },
                    child: ClipOval(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: profileImage != null
                            ? FileImage(profileImage!)
                            : null,
                        child: profileImage == null
                            ? Icon(Icons.camera_alt, size: 30)
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: name,
                    decoration: InputDecoration(
                      hintText: 'Name',
                    ),
                  ),
                  SizedBox(height: 16),
                  DropdownButton<String>(
                    value: selectedExperience,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedExperience = newValue;
                      });
                    },
                    items: experiences
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: Text('Select Experience'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: about,
                    decoration: InputDecoration(
                      hintText: 'About the Coach',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (profileImage != null) {
                      Reference storageReference = FirebaseStorage.instance
                          .ref()
                          .child(
                              'images/${DateTime.now().millisecondsSinceEpoch}.jpg');

                      await storageReference.putFile(profileImage!);

                      String imageUrl = await storageReference.getDownloadURL();
                      coachData['image_url'] = imageUrl;
                    }

                    coachData['name'] = name.text;
                    coachData['about'] = about.text;
                    coachData['experience'] = selectedExperience;

                    // Update coach data in Firestore
                    await FirebaseFirestore.instance
                        .collection("race_track_add_coach")
                        .doc(coachData['docId'])
                        .update(coachData);

                    print('Edit Coach');
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
}


class UserTab extends StatelessWidget {

  Future<List<DocumentSnapshot>> getdetails() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      var uid = sp.getString('uid');
      var userName = sp.getString('name'); // Fetch the username from shared preferences
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('coachbooking')
          .where('rt_id', isEqualTo: uid)
          .get();
      print('Fetched ${snapshot.docs.length} documents');

      // Update documents with the user's name
      snapshot.docs.forEach((doc) {
        if (doc.data() != null && (doc.data() as Map<String, dynamic>)['userid'] == uid) {
          doc.reference.update({'name': userName});
        }
      });

      return snapshot.docs;
    } catch (e) {
      print('Error fetching data: $e');
      throw e; // Rethrow the error to handle it in the FutureBuilder
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getdetails(),
      builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              final document = snapshot.data![index];
              final data = document.data() as Map<String, dynamic>?; 
              if (data != null) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder(
                          future: FirebaseFirestore.instance.collection('user_register').doc(data['userid']).get(),
                          builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                            if (userSnapshot.connectionState == ConnectionState.waiting) {
                              return SizedBox(
                                width: 100.0,
                                height: 20.0,
                                child: Center(child: CircularProgressIndicator()),
                              );
                            } else if (userSnapshot.hasError) {
                              return Text('Error fetching user name');
                            } else {
                              var userData = userSnapshot.data!.data();
                              if (userData != null && userData is Map<String, dynamic>) {
                                return Text(userData['name'] ?? 'User name not available');
                              } else {
                                return Text('User data not available');
                              }
                            }
                          },
                        ),
                        SizedBox(height: 8.0),
                        FutureBuilder(
                          future: FirebaseFirestore.instance.collection('race_track_add_coach').doc(data['coach_id']).get(),
                          builder: (context, AsyncSnapshot<DocumentSnapshot> coachSnapshot) {
                            if (coachSnapshot.connectionState == ConnectionState.waiting) {
                              return SizedBox(
                                width: 100.0,
                                height: 20.0,
                                child: Center(child: CircularProgressIndicator()),
                              );
                            } else if (coachSnapshot.hasError) {
                              return Text('Error fetching coach name');
                            } else {
                              var coachData = coachSnapshot.data!.data();
                              if (coachData != null && coachData is Map<String, dynamic>) {
                                return Text(coachData['name'] ?? 'Coach name not available');
                              } else {
                                return Text('Coach data not available');
                              }
                            }
                          },
                        ),
                        SizedBox(height: 8.0),
                        Text('Level: ${data['level'] ?? 'N/A'}'),
                        Text('Time: ${data['time'] ?? 'N/A'}'),
                        Text('Date: ${data['date'] ?? 'N/A'}'),
                        if (data['status'] == 1) Text('Status: Approved'),
                        SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                try {
                                  // Update status in Firebase
                                  await FirebaseFirestore.instance
                                      .collection('coachbooking')
                                      .doc(document.id)
                                      .update({'status': 1});

                                  // Show confirmation message
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                        content: Text('Status updated to Approved'),
                                        duration: Duration(seconds: 2),
                                      ));
                                } catch (e) {
                                  // Show error message if update fails
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                        content: Text('Failed to update status: $e'),
                                        duration: Duration(seconds: 2),
                                      ));
                                }
                              },
                              icon: Icon(Icons.check),
                              label: Text('Approve'),
                            ),
                            SizedBox(width: 8.0),
                            ElevatedButton.icon(
                              onPressed: data['status'] == 1
                                  ? null
                                  : () async {
                                      // Add code here to handle rejection
                                    },
                              icon: Icon(Icons.close),
                              label: Text('Reject'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: data['status'] == 1 ? Colors.grey : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return SizedBox(); // Return an empty SizedBox if data is null
              }
            },
          );
        }
      },
    );
  }
}

class AcceptedUser extends StatelessWidget {
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getApprovedUsers(),
        builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final document = snapshot.data![index];
                final data = document.data() as Map<String, dynamic>?;

                if (data != null && data.containsKey('userid') && data['userid'] != null) {
                  return FutureBuilder(
                    future: Future.wait([
                      FirebaseFirestore.instance.collection('user_register').doc(data['userid']).get(),
                      FirebaseFirestore.instance.collection('race_track_add_coach').doc(data['coach_id']).get(),
                    ]),
                    builder: (context, AsyncSnapshot<List<DocumentSnapshot>> futureSnapshot) {
                      if (futureSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (futureSnapshot.hasError) {
                        return Text('Error fetching data');
                      } else {
                        var userSnapshot = futureSnapshot.data![0];
                        var coachSnapshot = futureSnapshot.data![1];
                        
                        var userData = userSnapshot.data() as Map<String, dynamic>?;
                        var coachData = coachSnapshot.data() as Map<String, dynamic>?;
                        
                        if (userData != null && coachData != null && userData.containsKey('name') && coachData.containsKey('name')) {
                          return Card(
                            elevation: 3,
                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: ListTile(
                              title: Text(
                                userData['name'] ?? 'Name not available',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Text(
                                    'Date: ${data['date'] ?? 'Not available'}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Level: ${data['level'] ?? 'Not available'}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Time: ${data['time'] ?? 'Not available'}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Coach: ${coachData['name'] ?? 'Coach name not available'}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              onTap: () {
                                // Add onTap functionality if needed
                              },
                            ),
                          );
                        } else {
                          return SizedBox(); // Return an empty SizedBox if name is null
                        }
                      }
                    },
                  );
                } else {
                  return SizedBox(); // Return an empty SizedBox if data or userid is null
                }
              },
            );
          }
        },
      ),
    );
  }

  Future<List<DocumentSnapshot>> getApprovedUsers() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      var uid = sp.getString('uid');
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('coachbooking')
          .where('status', isEqualTo: 1)
          .where('rt_id', isEqualTo: uid)
          .get();
      print('Fetched ${snapshot.docs.length} approved users');
      return snapshot.docs;
    } catch (e) {
      print('Error fetching approved users: $e');
      throw e;
    }
  }
}


class FeedbackTab extends StatelessWidget {
  Future<List<DocumentSnapshot>> getFeedbacks() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      var uid = sp.getString('uid');

      print('UID from SharedPreferences: $uid');

      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('feedback')
          .where('rt_id', isEqualTo: uid)
          .get();

      print('Fetched ${snapshot.docs.length} feedbacks');

      // Print feedback document IDs and data
      for (var doc in snapshot.docs) {
        print('Feedback document ID: ${doc.id}, Data: ${doc.data()}');
      }

      return snapshot.docs;
    } catch (e) {
      print('Error fetching feedbacks: $e');
      throw e;
    }
  }

  @override
 Widget build(BuildContext context) {
  return FutureBuilder(
    future: getFeedbacks(),
    builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        print('Error in FutureBuilder: ${snapshot.error}');
        return Center(child: Text('Error: ${snapshot.error}'));
      } else {
        // Check if feedback data is available
        if (snapshot.data == null || snapshot.data!.isEmpty) {
          print('No feedback documents found');
          return Center(child: Text('No feedbacks found'));
        }

        // Display feedbacks in a ListView
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final document = snapshot.data![index];
            final data = document.data() as Map<String, dynamic>;

            // Extract userId and coachId
            final userId = data['userId'];
            final coachId = data['coachId'];

            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                leading: FutureBuilder(
                  future: userId != null
                      ? FirebaseFirestore.instance
                          .collection('user_register')
                          .doc(userId)
                          .get()
                      : null,
                  builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (userSnapshot.hasError) {
                      return Icon(Icons.account_circle);
                    } else if (!userSnapshot.hasData || userSnapshot.data!.data() == null) {
                      return Icon(Icons.account_circle);
                    } else {
                      var userData = userSnapshot.data!.data() as Map<String, dynamic>?;
                      var profileImageUrl = userData?['image_url'];

                      if (profileImageUrl != null && profileImageUrl.isNotEmpty) {
                        return CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(profileImageUrl),
                        );
                      } else {
                        return Icon(Icons.account_circle);
                      }
                    }
                  },
                ),
                title: Text(
                  data['feedback'] ?? 'Feedback not available',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    // FutureBuilder for fetching user data
                    FutureBuilder(
                      future: userId != null
                          ? FirebaseFirestore.instance
                              .collection('user_register')
                              .doc(userId)
                              .get()
                          : null,
                      builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                        if (userSnapshot.connectionState == ConnectionState.waiting) {
                          return SizedBox(
                            width: 100.0,
                            height: 20.0,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else if (userSnapshot.hasError) {
                          return Text('Error fetching user name');
                        } else if (!userSnapshot.hasData || userSnapshot.data!.data() == null) {
                          return Text('User name not available');
                        } else {
                          var userData = userSnapshot.data!.data() as Map<String, dynamic>?;
                          return Text(
                            'User: ${userData?['name'] ?? 'Name not available'}',
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 4),
                    // FutureBuilder for fetching coach data
                    FutureBuilder(
                      future: coachId != null
                          ? FirebaseFirestore.instance
                              .collection('race_track_add_coach')
                              .doc(coachId)
                              .get()
                          : null,
                      builder: (context, AsyncSnapshot<DocumentSnapshot> coachSnapshot) {
                        if (coachSnapshot.connectionState == ConnectionState.waiting) {
                          return SizedBox(
                            width: 100.0,
                            height: 20.0,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else if (coachSnapshot.hasError) {
                          return Text('Error fetching coach name');
                        } else if (!coachSnapshot.hasData || coachSnapshot.data!.data() == null) {
                          return Text('Coach name not available');
                        } else {
                          var coachData = coachSnapshot.data!.data() as Map<String, dynamic>?;
                          return Text(
                            'Coach: ${coachData?['name'] ?? 'Coach name not available'}',
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    },
  );
}
}