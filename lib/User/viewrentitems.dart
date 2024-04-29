import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginrace/User/viewrentalhome.dart';

class UserViewFullRenters extends StatefulWidget {
  @override
  _UserViewFullRentersState createState() => _UserViewFullRentersState();
}

class _UserViewFullRentersState extends State<UserViewFullRenters> {
   late Stream<QuerySnapshot> _dataStream;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _dataStream = getDataStream('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot> getDataStream(String query) {
    if (query.isEmpty) {
      return FirebaseFirestore.instance.collection('rental_add_service').snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('rental_add_service')
          .where('Rental Service', isGreaterThanOrEqualTo: query)
          .where('Rental Service', isLessThan: query + 'z')
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rental service'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[200],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(color: Colors.black),
                        onChanged: (query) {
                          setState(() {
                            _dataStream = getDataStream(query);
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search your need',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _dataStream,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length ?? 0,
                    itemBuilder: (context, index) {
                      final document = snapshot.data!.docs[index];
                      final id = document.id;
                      final data = document.data() as Map<String, dynamic>;
                      final imageUrl = data['image_url'];
                      final rentalId = data['rent_id'];
                      return StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance.collection('rentalregister').doc(rentalId).snapshots(),
                        builder: (context, AsyncSnapshot<DocumentSnapshot> availabilitySnapshot) {
                          if (availabilitySnapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (availabilitySnapshot.hasError) {
                            return Text('Error: ${availabilitySnapshot.error}');
                          } else {
                            final availabilityData = availabilitySnapshot.data!.data() as Map<String, dynamic>?;

                            if (availabilityData != null && availabilityData.containsKey('availability')) {
                              final availability = availabilityData['availability'] as String;
                              final buttonText = availability == 'available' ? 'AVAILABLE' : 'NOT AVAILABLE';
                              final buttonColor = availability == 'available' ? Colors.green : Colors.red;
                              return ListTile(
                                onTap: () {
                                  if (availability == 'available') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserViewRentHome(id: rentalId),
                                      ),
                                    );
                                  }
                                },
                                title: Text(data['Renter Name'] ?? 'Name not available'),
                                subtitle: Text(data['Rental Service'] ?? 'Service not available'),
                                leading: imageUrl != null
                                    ? CircleAvatar(
                                        backgroundImage: NetworkImage(imageUrl),
                                        radius: 30,
                                      )
                                    : CircleAvatar(
                                        child: Icon(Icons.person),
                                        radius: 30,
                                      ),
                                trailing: ElevatedButton(
                                  
                                  onPressed: availability == 'available' ? () {} : null,
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                    backgroundColor: buttonColor,
                                  ),
                                  child: Text(
                                    buttonText,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          }
                        },
                      );
                    },
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