import 'package:flutter/material.dart';

class RentNotification extends StatefulWidget {
  const RentNotification({super.key});

  @override
  State<RentNotification> createState() => _RentNotificationState();
static void addNotification(Map<String, dynamic> notification) {
    _RentNotificationState._addNotification(notification);
  }
}

class _RentNotificationState extends State<RentNotification> {
  static List<Map<String, dynamic>> notifications = [];

  // Add notification to the list
  static void _addNotification(Map<String, dynamic> notification) {
    notifications.add(notification);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: NotificationView(),
    );
  }
}

class NotificationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _RentNotificationState.notifications.length,
      itemBuilder: (context, index) {
        final notification = _RentNotificationState.notifications[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text(
              notification['title'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification['description'],
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  'Received on: ${notification['timestamp'].toLocal()}',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}