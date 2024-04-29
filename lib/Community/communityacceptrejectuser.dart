import 'package:flutter/material.dart';

class CommunityAcceptUser extends StatefulWidget {
  const CommunityAcceptUser({super.key});

  @override
  State<CommunityAcceptUser> createState() => _CommunityAcceptUserState();
}

class _CommunityAcceptUserState extends State<CommunityAcceptUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accept User'),
        backgroundColor: Color.fromARGB(255, 235, 142, 148),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  height: 300,
                  width: 400,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'AWH ENGINEERING COLLEGE',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'COLLEGE GROUND',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'TOTAL HOURS - 4HRS',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'DATE - 3-09-2024',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Total vehicles - 20',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Handle Accept logic
                            },
                            child: Text('Accept'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.green,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Handle Reject logic
                            },
                            child: Text('Reject'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
