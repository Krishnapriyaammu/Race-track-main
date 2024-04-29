import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginrace/User/viewrentsingleimagediscrip.dart';
import 'package:responsive_grid/responsive_grid.dart';



class UserViewRentHome extends StatefulWidget {
  String id;
  UserViewRentHome({Key? key, required this.id}) : super(key: key);

  @override
  State<UserViewRentHome> createState() => _UserViewRentHomeState();
}

class _UserViewRentHomeState extends State<UserViewRentHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Rental Home'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Bikes'),
            Tab(text: 'Cars'),
            Tab(text: 'Riding Gears'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBikeContent('images/bikee.jpeg'),
          _buildCarContent('images/racing.jpg'),
          _buildGroceryContent('images/bikee.jpeg'),
        ],
      ),
    );
  }
   Future<List<DocumentSnapshot>> getData() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('rental_upload_image')
          .where('rent_id',isEqualTo: widget.id)
          .where('category',isEqualTo: 'Bikes')
          .get();
         print('Fetched ${snapshot.docs.length} documents');
      // Print document IDs
      for (var doc in snapshot.docs) {
        print('Document ID: ${doc.id}');
      }
      return snapshot.docs;
    } catch (e) {
      print('Error fetching data: $e');
      throw e; // Rethrow the error to handle it in the FutureBuilder
    }
  }

  Widget _buildBikeContent(String imagePath) {
    return Expanded(
      child: SizedBox(
        height: 60,
        child: FutureBuilder(
          future: getData(),
          builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return  GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount:  snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                 final document = snapshot.data![index];
                 print('Snapshot Length: ${snapshot.data?.length ?? 0}');

                  final data = document.data() as Map<String, dynamic>;
                  final imageUrl = data['image_url'];
                  // final desc = data['description'];
                  // final rent_id=data['rent_id'];
               return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return UserViewSingleItem(rent_id:document.id,
                                 imageUrl: imageUrl,
                           price: data['price'] ,
    );
  }));
                  },
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      // borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ClipRRect(
                      child: imageUrl != null
                          ? Image.network(imageUrl, fit: BoxFit.cover)
                          : Icon(Icons.image),
                    ),
                  ),
                );
              },
            );
          }
          }
        ),
      ),
    );
  }
Future<List<DocumentSnapshot>> getdata() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('rental_upload_image')
          .where('rent_id',isEqualTo: widget.id)
          .where('category',isEqualTo: 'Cars')
          .get();
      print('Fetched ${snapshot.docs.length} documents');
      return snapshot.docs;
    } catch (e) {
      print('Error fetching data: $e');
      throw e; // Rethrow the error to handle it in the FutureBuilder
    }
  }
 




 Widget _buildCarContent(String imagePath) {
    return Expanded(
      child: SizedBox(
        height: 60,
        child: FutureBuilder(
          future: getdata(),
          builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return  GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount:  snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                 final document = snapshot.data![index];
                final data = document.data() as Map<String, dynamic>;
                final imageUrl = data['image_url'];
                final rent_id =data['rent_id'];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return UserViewSingleItem(rent_id:document.id,
                                 imageUrl: imageUrl,
                           price: data['price'] ,
    );
  }));
                  },
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      // borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ClipRRect(
                      child: imageUrl != null
                          ? Image.network(imageUrl, fit: BoxFit.cover)
                          : Icon(Icons.image),
                    ),
                  ),
                );
              },
            );
          }
          }
        ),
      ),
    );
  }



   Future<List<DocumentSnapshot>> getdatas() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('rental_upload_image')
          .where('rent_id',isEqualTo: widget.id)
          .where('category',isEqualTo: 'Riding Gears')
          .get();
      print('Fetched ${snapshot.docs.length} documents');
      return snapshot.docs;
    } catch (e) {
      print('Error fetching data: $e');
      throw e; // Rethrow the error to handle it in the FutureBuilder
    }
  }

   Widget _buildGroceryContent(String imagePath) {
    return Expanded(
      child: SizedBox(
        height: 60,
        child: FutureBuilder(
          future: getdatas(),
          builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return  GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount:  snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                 final document = snapshot.data![index];
                final data = document.data() as Map<String, dynamic>;
                final imageUrl = data['image_url'];
                 final rent_id =data['rent_id'];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return UserViewSingleItem(rent_id:document.id,
                                 imageUrl: imageUrl,
                           price: data['price'],
    );
  }));
                  },
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      // borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ClipRRect(
                      child: imageUrl != null
                          ? Image.network(imageUrl, fit: BoxFit.cover)
                          : Icon(Icons.image),
                    ),
                  ),
                );
              },
            );
          }
          }
        ),
      ),
    );
  }

    }







