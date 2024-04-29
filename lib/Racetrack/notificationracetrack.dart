import 'package:flutter/material.dart';
class NotificationItem {
  final String title;
  final String description;

  NotificationItem({
    required this.title,
    required this.description,
  });
}

class NotificationPage extends StatelessWidget {
  final List<NotificationItem> notificationList = [
    NotificationItem(
      title: 'Payment Received',
      description: 'Payment of \$50 for Race Test booked on 8th March 2024.',
    ),
    NotificationItem(
      title: 'Booking Confirmed',
      description: 'Your booking for Race Test on 8th March 2024 has been confirmed.',
    ),
    // Add more notification items as needed
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notificationList.length,
        itemBuilder: (context, index) {
          final notification = notificationList[index];
          return ListTile(
            title: Text(
              notification.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(notification.description),
            onTap: () {
              // Handle tap on notification if needed
            },
          );
        },
      ),





    );
  }
}