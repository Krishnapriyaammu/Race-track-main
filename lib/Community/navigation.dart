
import 'package:flutter/material.dart';
import 'package:loginrace/Community/communityhome.dart';
import 'package:loginrace/Community/communityviewrequest.dart';
import 'package:loginrace/Community/home3.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int selectedindex = 1;
  late String communityId = ''; // Declare communityId variable

  @override
  void initState() {
    super.initState();
    retrieveCommunityId(); // Call method to retrieve community ID from shared preferences
  }

  Future<void> retrieveCommunityId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('uid');
    if (id != null) {
      setState(() {
        communityId = id;
      });
    }
  }

  final List<Widget> _widgetoption = [
    ProfileViewPage(),
    CommunityViewRequest(communityId: ''), // Placeholder value for now
    HomePayement(communityId: ''), // Remove communityId parameter
  ];

  void _ontopItem(int index) {
    setState(() {
      selectedindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetoption.elementAt(selectedindex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.repartition, color: Colors.black),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.black),
            label: 'Payment',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedindex,
        selectedItemColor: Colors.red,
        iconSize: 40,
        onTap: _ontopItem,
      ),
    );
  }
}