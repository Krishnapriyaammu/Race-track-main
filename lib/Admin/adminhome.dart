import 'package:flutter/material.dart';
import 'package:loginrace/Admin/adminviewcommunity.dart';
import 'package:loginrace/Admin/adminviewracetrack.dart';
import 'package:loginrace/Admin/adminviewrental.dart';
import 'package:loginrace/Admin/viewuser.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

 appBar: AppBar(
        title: Text('Admin Home'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Admin Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: InkWell(onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return AdminViewUser();
                  },));
              },
                child: Icon(Icons.person)),
              title: Text('Users'),
              onTap: () {
                // Navigate to Users page
                print('Users pressed');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: InkWell(onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return AdminViewCommunity();
                  },));
              },
                child: Icon(Icons.people)),
              title: Text('Community'),
              onTap: () {
                // Navigate to Community page
                print('Community pressed');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: InkWell(onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return AdminViewRacetrack();
                  },));
              },
                child: Icon(Icons.directions_car)),
              title: Text('Race Track'),
              onTap: () {
                // Navigate to Race Track page
                print('Race Track pressed');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: InkWell(onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return AdminViewRental();
                  },));
              },
                child: Icon(Icons.shopping_cart)),
              title: Text('Rental'),
              onTap: () {
               
                print('Rental pressed');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'images/background.jpeg', 
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
      




        ]),
    );
  }
}