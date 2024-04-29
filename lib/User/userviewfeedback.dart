import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loginrace/User/userfeedback.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackViewPage extends StatefulWidget {
  final String rt_id;
    FeedbackViewPage({Key? key, required this.rt_id}) : super(key: key);

  @override
  _FeedbackViewPageState createState() => _FeedbackViewPageState();
}



class _FeedbackViewPageState extends State<FeedbackViewPage> {
  String image_url = '';

  Future<List<DocumentSnapshot>> getdata() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('user_send_feedback')
          .get();
      print('Fetched ${snapshot.docs.length} documents');
      return snapshot.docs;
    } catch (e) {
      print('Error fetching data: $e');
      throw e; // Rethrow the error to handle it in the FutureBuilder
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback List'),
      ),
      body: FutureBuilder(
        future: getdata(),
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
                          data['username'] ?? 'username not available',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
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
                          data['feedback'] ?? 'feedback not available',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return UserFeedback(rt_id:widget.rt_id);
            }),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}