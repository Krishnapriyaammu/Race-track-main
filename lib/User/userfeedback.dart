import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loginrace/User/userviewfeedback.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserFeedback extends StatefulWidget {
  final String rt_id;
   UserFeedback({Key? key, required this. rt_id}) : super(key: key);

  @override
  State<UserFeedback> createState() => _UserFeedbackState();
}

class _UserFeedbackState extends State<UserFeedback> {
  var feedback = TextEditingController();
    final _formKey = GlobalKey<FormState>();

  double _userRating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews'),
      ),
     body: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rate your experience:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              RatingBar.builder(
                initialRating: _userRating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _userRating = rating;
                  });
                },
              ),
              SizedBox(height: 24),
              Text(
                'Additional Comments:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: feedback,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your comments';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your comments here...',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    SharedPreferences sp = await SharedPreferences.getInstance();
                      var name = sp.getString('name');
                      var img = sp.getString('image_url');
                       var uid = sp.getString('uid');

                    await FirebaseFirestore.instance
                        .collection('user_send_feedback')
                        .add({
                      'feedback': feedback.text,
                      'rating': _userRating,
                      'username':name,
                      'image_url':img,
                      'uid':uid,
                      'rt_id':widget.rt_id,
                    });

                    if (_formKey.currentState!.validate()) {
                      print(feedback.text);
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return FeedbackViewPage(rt_id: widget.rt_id,);
                      }));
                      print('Rating: $_userRating');
                                              Navigator.pop(context); // Navigate back to the previous page

                    }
                  },
                  child: Text('Submit Feedback'),
                ),
              ),
              SizedBox(height: 150), // Add SizedBox to create space at the bottom
            ],
          ),
        ),
      ),
    );
  }
}