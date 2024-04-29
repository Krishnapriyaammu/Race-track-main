import 'package:flutter/material.dart';
import 'package:loginrace/Racetrack/editprofile.dart';

class  RatingScreen extends StatefulWidget {
  const  RatingScreen({super.key});

  @override
  State< RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State< RatingScreen> {
  int _rating = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

appBar: AppBar(
        title: Text('Feedback'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Rate',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                  child: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    size: 40.0,
                    color: Colors.amber,
                  ),
                );
              }),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //           return EditProfile();
                  // },));
                print('Selected Rating: $_rating');
              },
              child: Text('Submit Rating'),
            ),
          ],
        ),
      ),


    );
  }
}