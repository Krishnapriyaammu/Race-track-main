import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginrace/Racetrack/addslots.dart';
import 'package:loginrace/Racetrack/challengecahieve.dart';
import 'package:loginrace/Racetrack/navigationracetrack.dart';
import 'package:loginrace/Racetrack/slotdetails.dart';
import 'package:loginrace/Racetrack/track.dart';
import 'package:loginrace/Racetrack/trackamount.dart';
import 'package:loginrace/Racetrack/trackdetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RaceTrackViewRace extends StatefulWidget {
  RaceTrackViewRace({super.key});

  @override
  State<RaceTrackViewRace> createState() => _RaceTrackViewRaceState();
}

class _RaceTrackViewRaceState extends State<RaceTrackViewRace> {
 TextEditingController Racetrackname = TextEditingController();
  TextEditingController Rating = TextEditingController();
  TextEditingController tracktype = TextEditingController();
  TextEditingController Place = TextEditingController();
  TextEditingController upcoming_events = TextEditingController();
  TextEditingController level1 = TextEditingController();
  TextEditingController level2 = TextEditingController();
  String imageUrl = '';
  File? profileImage;
  XFile? pickedFile;

  Future<void> updateStatus(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('user_track_booking')
          .doc(documentId)
          .update({'status': '2'});
      print('Status updated successfully');
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  Future<List<DocumentSnapshot>> getData() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      var a = sp.getString('uid');
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('racetrack_upload_track')
          .where('uid', isEqualTo: a)
          .get();
      print('Fetched ${snapshot.docs.length} documents');
      return snapshot.docs;
    } catch (e) {
      print('Error fetching data: $e');
      throw e;
    }
  }

  Future<List<DocumentSnapshot>> getBookedUsers() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      var uid = sp.getString('uid');
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('user_track_booking')
          .where('rt_id', isEqualTo: uid)
          .get();
      print('Fetched ${snapshot.docs.length} booked users');
      return snapshot.docs;
    } catch (e) {
      print('Error fetching booked users: $e');
      throw e;
    }
  }

  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('user_register')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        return {}; // Return empty map if user not found
      }
    } catch (e) {
      print('Error fetching user details: $e');
      throw e;
    }
  }

  Future<List<DocumentSnapshot>> getFeedbacks() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      var uid = sp.getString('uid');
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('user_send_feedback')
          .where('rt_id', isEqualTo: uid)
          .get();
      print('Fetched ${snapshot.docs.length} feedbacks');
      print('Feedback documents: ${snapshot.docs}');
      return snapshot.docs;
    } catch (e) {
      print('Error fetching feedbacks: $e');
      throw e;
    }
  }
     void _showAddTrackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return SingleChildScrollView(
              child: AlertDialog(
                title: Text('Add Track'),
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
                              ? FileImage(profileImage!)
                              : null,
                          child: profileImage == null
                              ? Icon(Icons.camera_alt, size: 30)
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text('Name'),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: Racetrackname,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'enter Name';
                        }
                      },
                      decoration: InputDecoration(
                        fillColor: Color.fromARGB(255, 192, 221, 224),
                        filled: true,
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text('Track type'),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: tracktype,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'enter type';
                        }
                      },
                      decoration: InputDecoration(
                        fillColor: Color.fromARGB(255, 192, 221, 224),
                        filled: true,
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text('place'),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: Place,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'enter place';
                        }
                      },
                      decoration: InputDecoration(
                        fillColor: Color.fromARGB(255, 192, 221, 224),
                        filled: true,
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                   
                    SizedBox(height: 20),
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
                      SharedPreferences sp =
                          await SharedPreferences.getInstance();
                      var a = sp.getString('uid');
                      await uploadImage();

                      await FirebaseFirestore.instance
                          .collection("racetrack_upload_track")
                          .add({
                        'track name': Racetrackname.text,
                        'rating': Rating.text,
                        'tracktype': tracktype.text,
                        'place': Place.text,
                        'upcomingevents': upcoming_events.text,
                        
                        'image_url': imageUrl,
                        'uid': a,
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return RaceTrackNavigation();
                        }),
                      );
                    },
                    child: Text('Upload'),
                  ),
                ],
              ),
            );
          },
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
        imageUrl = await storageReference.getDownloadURL();
        print('Image URL: $imageUrl');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
  


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Explore Racetracks'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Add Track'),
              Tab(text: 'View Booked Users'),
              Tab(text: 'Feedbacks'), // New tab for feedbacks
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Add Track Tab
        Column(
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
                return Stack(
                  children: [
                    InkWell(
                     onTap: () {
                         Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Challenge()),
                );
                     },


                      child: ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: ((context, index) {
                          final document = snapshot.data![index];
                          final data = document.data() as Map<String, dynamic>;
                          final imageUrl = data['image_url'];
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Card(
                              elevation: 5,
                              child: Row(
                                children: [
                                  // Left Container
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data['track name'] ?? 'Name not available',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          // Row(
                                          //   children: [
                                          //     RatingBar.builder(
                                          //       itemSize: 20,
                                          //       initialRating: 3,
                                          //       minRating: 1,
                                          //       direction: Axis.horizontal,
                                          //       allowHalfRating: true,
                                          //       itemCount: 5,
                                          //       itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                          //       itemBuilder: (context, _) => Icon(
                                          //         Icons.star,
                                          //         size: 20,
                                          //         color: Colors.amber,
                                          //       ),
                                          //       onRatingUpdate: (rating) {
                                          //         print(rating);
                                          //       },
                                          //     ),
                                          //     SizedBox(width: 10),
                                          //     Text(
                                          //       '3.0',
                                          //       style: TextStyle(
                                          //         fontSize: 16,
                                          //         fontWeight: FontWeight.bold,
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                          SizedBox(height: 10),
                                          Text(
                                            data['tracktype'] ?? 'Name not available',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            data['place'] ?? 'Name not available',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: AssetImage('images/racing.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: imageUrl != null
                                        ? Image.network(imageUrl, fit: BoxFit.cover)
                                        : Icon(Icons.image),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: FloatingActionButton(
                        onPressed: () {
                _showAddTrackDialog(context);
                        },
                        child: Icon(Icons.add),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ],
      
    ),
            

            // View Booked Users Tab
            FutureBuilder(
              future: getBookedUsers(),
              builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<DocumentSnapshot> bookedUsers = snapshot.data ?? [];
                  return Stack(
                    children: [
                      ListView.builder(
                        itemCount: bookedUsers.length,
                        itemBuilder: (context, index) {
                          final userData = bookedUsers[index].data() as Map<String, dynamic>;
                          String status = userData['status'] ?? '0';
                          bool isLevel1Completed = status == '1';
                          final String documentId = bookedUsers[index].id;

                          return FutureBuilder(
                            future: getUserDetails(userData['userid']),
                            builder: (context, AsyncSnapshot<Map<String, dynamic>> userSnapshot) {
                              if (userSnapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (userSnapshot.hasError) {
                                return Text('Error: ${userSnapshot.error}');
                              } else {
                                final user = userSnapshot.data ?? {};
                                final String username = user['name'] ?? 'Username not available';
                                final String mobile = user['mobile no'] ?? 'Mobile not available';

                                return Card(
                                  elevation: 3,
                                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: ListTile(
                                    title: Text(username),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Mobile: $mobile'),
                                        Text(userData['selectedSlot'] ?? 'Name not available'),
                                        Text(userData['startTime'] ?? 'Email not available'),
                                        Text(userData['totalHours'].toString() ?? 'Hours not available'),
                                        Text(userData['totalPrice'] ?? 'Email not available'),
                                       Text(
  (userData['selectedDate'] != null)
      ? DateTime.parse(userData['selectedDate']).toString().split(' ')[0]
      : 'Date not available',
),   
                          ],
                        ),
                      ),
                    );
                  }
                },
              );
            },
          ),
          Positioned(
            bottom: 80, // Adjust position as needed
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return AddSlots(
                
                    );
                  }),
                );              },
              child: Icon(Icons.add),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return SlotDetails(
                       
                     
                    );
                  }),
                );
              },
              child: Text('View Slots'),
            ),
          ),
        ],
      );
    }
  },
),
            // Feedbacks Tab
            FutureBuilder(
              future: getFeedbacks(),
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
                      final data = document.data() as Map<String, dynamic>;
                      final imageUrl = data['image_url'];

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              imageUrl != null
                                  ? CircleAvatar(
                                      radius: 50,
                                      backgroundImage: NetworkImage(imageUrl),
                                    )
                                  : Icon(Icons.image),
                              SizedBox(height: 8),
                              Text(
                                data['username'] ?? 'Username not available',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              RatingBarIndicator(
                                rating: data['rating'] ?? 0.0,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 20.0,
                                direction: Axis.horizontal,
                              ),
                              SizedBox(height: 8),
                              Text(
                                data['feedback'] ?? 'Feedback not available',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        )
      )
    );
  }
}
