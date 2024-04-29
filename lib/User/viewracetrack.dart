import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loginrace/Racetrack/trackdetails.dart';
import 'package:loginrace/User/navigationuser.dart';
import 'package:loginrace/User/viewtrackdetails.dart';

class ViewRacetrack extends StatefulWidget {
  const ViewRacetrack({super.key});

  @override
  State<ViewRacetrack> createState() => _ViewRacetrackState();
}

class _ViewRacetrackState extends State<ViewRacetrack> {
 late TextEditingController _searchController;
  String _searchPlace = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  Future<List<DocumentSnapshot>> getdata() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('racetrack_upload_track').get();
      if (_searchPlace.isNotEmpty) {
        snapshot = await FirebaseFirestore.instance
            .collection('racetrack_upload_track')
            .where('place', isEqualTo: _searchPlace)
            .get();
      }
      print('Fetched ${snapshot.docs.length} documents');
      return snapshot.docs;
    } catch (e) {
      print('Error fetching data: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore Racetracks'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 238, 180, 180).withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search for racetracks',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchPlace = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _searchPlace = _searchController.text;
                      });
                    },
                    child: Text('Search'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getdata(),
              builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: ((context, index) {
                      final document = snapshot.data![index];
                      final data = document.data() as Map<String, dynamic>;
                      final imageUrl = data['image_url'];

                      var id = document['uid'];
                      var level1 = data['level1'];
                      var level2 = data['level2'];
                      var upcomingevents = data['upcomingevents'];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 5,
                          child: Row(
                            children: [
                              // Left Container
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return ViewTrackDetails(
                                          rt_id: id,
                                          level1: level1,
                                          level2: level2,
                                          upcomingevents: upcomingevents,
                                        );
                                      }),
                                    );
                                  },
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
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            RatingBar.builder(
                                              itemSize: 20,
                                              initialRating: 3,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                size: 20,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {
                                                print(rating);
                                              },
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              '3.0',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
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
                              ),

                              // Right Container
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
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}