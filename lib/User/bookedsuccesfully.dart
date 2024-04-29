import 'package:flutter/material.dart';
import 'package:loginrace/User/viewtrackdetails.dart';

class Booksuccesfully extends StatefulWidget {
  const Booksuccesfully({super.key});

  @override
  State<Booksuccesfully> createState() => _BooksuccesfullyState();
}

class _BooksuccesfullyState extends State<Booksuccesfully> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

 appBar: AppBar(
        backgroundColor: Colors.blue, 
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 100.0,
              ),
              SizedBox(height: 20.0),
              Text(
                'Booking Successful!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Your coach has been booked successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                 
                  //  Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //           return ViewTrackDetails(rt_id: '',);
                  // },));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                child: Text(
                  'OK',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}






 