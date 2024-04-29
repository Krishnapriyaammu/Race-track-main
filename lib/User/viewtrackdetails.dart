import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loginrace/User/slotavailability.dart';
import 'package:loginrace/User/userviewfeedback.dart';
import 'package:loginrace/User/viewallinstructors.dart';
import 'package:loginrace/User/viewgallery.dart';
import 'package:loginrace/User/viewindividualinstructor.dart';
import 'package:loginrace/User/viewtrack.dart';

class ViewTrackDetails extends StatefulWidget {
  
  var upcomingevents;
  var level1;
  var level2;
  String rt_id;
  
   ViewTrackDetails({Key? key, required this.rt_id, required this.level1, required this. level2, required this. upcomingevents, }) : super(key: key);

  @override
  State<ViewTrackDetails> createState() => _ViewTrackDetailsState();
}

class _ViewTrackDetailsState extends State<ViewTrackDetails> {
   late ScrollController _controller;
  double _scrollPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _startScrolling();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startScrolling() {
    Timer.periodic(Duration(milliseconds: 30), (timer) {
      if (_controller.hasClients) {
        setState(() {
          _scrollPosition += 1.0;
          if (_scrollPosition >= _controller.position.maxScrollExtent) {
            _scrollPosition = 0.0;
          }
          _controller.jumpTo(_scrollPosition);
        });
      }
    });
  }

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // title: Text('Adventure Race Track'),
      //   backgroundColor: Colors.black87,
      // ),
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bikee.jpeg"), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 200,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _controller,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Upcoming Events: Kari motors racing event',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: 16),
                  Text(
                    widget.upcomingevents ?? 'Events not available',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Text(
            //   'LEVEL 1 Amount: ${widget.level1}',
            //   style: TextStyle(
            //     fontSize: 18,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white,
            //   ),
            // ),
            SizedBox(height: 20),
            _buildActionButton(
              'BOOOK NOW',
              Icons.arrow_forward,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return SlotAvailability(
                      rt_id: widget.rt_id,
                      level1: widget.level1,
                    );
                  }),
                );
              },
              Colors.green,
              isExpanded: false,
            ),
            SizedBox(height: 20),
            _buildActionButton(
              'View All Instructors',
              Icons.arrow_forward,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return UserViewAllCoach(rt_id: widget.rt_id);
                  }),
                );
              },
              Colors.blue,
            ),
            SizedBox(height: 10),
            _buildActionButton(
              'View Track',
              Icons.arrow_forward,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ViewTrack(rt_id: widget.rt_id);
                  }),
                );
              },
              Colors.blue,
            ),
            SizedBox(height: 10),
            _buildActionButton(
              'View Gallery',
              Icons.arrow_forward,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ViewGallery(rt_id: widget.rt_id);
                  }),
                );
              },
              Colors.blue,
            ),
            SizedBox(height: 20),
            SizedBox(height: 10),
           Align(
  alignment: Alignment.centerRight,
  child: TextButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return FeedbackViewPage(rt_id: widget.rt_id);
        }),
      );
    },
    child: Text(
      'View Feedbacks',
      style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String title,
    IconData icon,
    void Function()? onTap,
    Color color, {
    bool isExpanded = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}