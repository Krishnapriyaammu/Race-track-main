import 'package:flutter/material.dart';
import 'package:loginrace/Common/Login.dart';
import 'package:loginrace/User/userfirstpage.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'images/pic.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 140.0), // Adjust the height as needed
                      Text(
                        'WHO YOU ARE',
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 20.0),
                      _buildButton(context, 'User', Icons.person, UserType(type:'user')),
                      _buildButton(
                          context, 'Race track', Icons.directions_run,Login(type:'race track')),
                      _buildButton(
                          context, 'Rental Service', Icons.shopping_cart, Login(type: 'rental')),
                      _buildButton(
                          context, 'Community', Icons.people, Login(type: 'community')),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Login(type: 'admin');
                }));
              },
              child: Text(
                'Admin',
                style: TextStyle(fontSize: 18.0, color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label, IconData icon, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return page;
          }));
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(16.0), backgroundColor: Colors.blue, // Change the button color as needed
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30.0, color: Colors.white),
            SizedBox(width: 10.0),
            Text(
              label,
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}