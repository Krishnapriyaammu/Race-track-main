import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginrace/Racetrack/viewtrackdetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackDetailsGallery extends StatefulWidget {
  const TrackDetailsGallery({super.key});

  @override
  State<TrackDetailsGallery> createState() => _TrackDetailsGalleryState();
}

class _TrackDetailsGalleryState extends State<TrackDetailsGallery> with SingleTickerProviderStateMixin {
Future<List<DocumentSnapshot>> getData() async {
    try {
       SharedPreferences sp = await SharedPreferences.getInstance();
                     var a = sp.getString('uid');
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('race_track_add_gallery').where('uid',isEqualTo: a)
          .get();
      print('Fetched ${snapshot.docs.length} documents');
      return snapshot.docs;
    } catch (e) {
      print('Error fetching data: $e');
      throw e; // Rethrow the error to handle it in the FutureBuilder
    }
  }

   late TabController _tabController;
  var pickedFile;

  var track = TextEditingController();
  var surface = TextEditingController();
  var length = TextEditingController();
  var turns = TextEditingController();
  var record = TextEditingController();
  File? _selectedImage;
  String imageUrl = '';
  List<File> trackImages = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Details'),
        actions: [
          if (_tabController.index == 0)
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

                setState(() {
                  if (pickedFile != null) {
                    _selectedImage = File(pickedFile.path);
                  }
                });
              },
            ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 16),
                if (_selectedImage != null)
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: FileImage(_selectedImage!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                SizedBox(height: 16),
                TextFormField(
                  controller: track,
                  decoration: InputDecoration(
                    labelText: 'Track Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.directions_run),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: surface,
                  decoration: InputDecoration(
                    labelText: 'Surface Length',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.format_line_spacing),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: length,
                  decoration: InputDecoration(
                    labelText: 'Length',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.straighten),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: turns,
                  decoration: InputDecoration(
                    labelText: 'Number of Turns',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.rotate_left),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: record,
                  decoration: InputDecoration(
                    labelText: 'Lap Record',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.timer),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    SharedPreferences sp = await SharedPreferences.getInstance();
                    var uid = sp.getString('uid');

                    Reference storageReference = FirebaseStorage.instance.ref().child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

                    await storageReference.putFile(_selectedImage!);

                    String imageUrl = await storageReference.getDownloadURL();
                    await uploadImage();

                    DocumentReference trackRef = await FirebaseFirestore.instance.collection("race_track_add_track").add({
                      'track': track.text,
                      'surface': surface.text,
                      'length': length.text,
                      'turns': turns.text,
                      'record': record.text,
                      'image_url': imageUrl,
                      'uid': uid,
                      'track_id': '',
                    });
                    String trackId = trackRef.id;
                    await trackRef.update({'track_id': trackId});
                  },
                  child: Text('Upload'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    backgroundColor: Colors.blue,
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () async {
                      String uid = await getUidFromRaceTrackAddTrack();

                      if (uid.isNotEmpty) {
                        var trackId = await fetchTrackId(uid);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RaceTrackViewTrackdetails(uid: uid, trackId: trackId),
                          ),
                        );
                      } else {
                        // Handle the case when uid is empty
                      }
                    },
                    child: Text('View'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      backgroundColor: Colors.green,
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("race_track_add_gallery").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                return FutureBuilder(
                  future: getData(),
                  builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0,
                        ),
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          final document = snapshot.data![index];
                          final data = document.data() as Map<String, dynamic>;
                          final imageUrl = data['image_url'];

                          return imageUrl != null ? Image.network(imageUrl, fit: BoxFit.cover) : Container();
                        },
                      );
                    }
                  },
                );
              } else {
                return Center(
                  child: Text('No images found'),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 1
          ? FloatingActionButton(
              onPressed: () {
                _showAddImageDialog(context);
              },
              child: Icon(Icons.camera_alt),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabController.index,
        onTap: (index) {
          setState(() {
            _tabController.index = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run),
            label: 'Track',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            label: 'Gallery',
          ),
        ],
      ),
    );
  }

  void _showAddImageDialog(BuildContext context) {
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
                        pickedFile = await picker.pickImage(source: ImageSource.gallery);

                        setState(() {
                          if (pickedFile != null) {
                            _selectedImage = File(pickedFile!.path);
                          }
                        });
                      },
                      child: Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                          image: _selectedImage != null
                              ? DecorationImage(
                                  image: FileImage(_selectedImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _selectedImage == null
                            ? Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: Colors.grey[600],
                              )
                            : null,
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {},
                      child: Text('Select Image'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        backgroundColor: Colors.blue,
                        textStyle: TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      SharedPreferences sp = await SharedPreferences.getInstance();
                      var uid = sp.getString('uid');
                      Reference storageReference = FirebaseStorage.instance.ref().child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

                      await storageReference.putFile(_selectedImage!);

                      String imageUrl = await storageReference.getDownloadURL();
                      await uploadImage();

                      await FirebaseFirestore.instance.collection("race_track_add_gallery").add({
                        'image_url': imageUrl,
                        'uid': uid,
                      });

                      Navigator.of(context).pop();
                    },
                    child: Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      backgroundColor: Colors.green,
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
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
      if (_selectedImage != null) {
        Reference storageReference = FirebaseStorage.instance.ref().child('image/${pickedFile!.name}');

        await storageReference.putFile(_selectedImage!);

        imageUrl = await storageReference.getDownloadURL();

        print('Image URL: $imageUrl');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
}

Future<String> getUidFromRaceTrackAddTrack() async {
  try {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('uid') ?? '';
  } catch (e) {
    print('Error getting uid: $e');
    return '';
  }
}

Future<String> fetchTrackId(String uid) async {
  try {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('race_track_add_track').where('uid', isEqualTo: uid).get();
    if (snapshot.docs.isNotEmpty) {
      String trackId = snapshot.docs.first.id;
      return trackId;
    } else {
      print('No document found for the UID: $uid');
      return '';
    }
  } catch (e) {
    print('Error fetching trackId: $e');
    return '';
  }
}