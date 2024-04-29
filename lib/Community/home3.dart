import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class HomePayement extends StatefulWidget {
  String communityId;
   HomePayement({super.key, required this. communityId});

  @override
  State<HomePayement> createState() => _HomePayementState();
}

class _HomePayementState extends State<HomePayement> {
  late Future<List<DocumentSnapshot>> _futureBookings;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _futureBookings = _getAllBookings();
  }

  Future<List<DocumentSnapshot>> _getAllBookings() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('auto_show_booking')
        .where('community_id', isEqualTo: widget.communityId)
        .where('status', isEqualTo: 1)
        .get();

    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> _getBookingsByDate(DateTime date) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('auto_show_booking')
        .where('community_id', isEqualTo: widget.communityId)
        .where('status', isEqualTo: 1)
        .where('date', isEqualTo: date)
        .get();

    return querySnapshot.docs;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _futureBookings = _getBookingsByDate(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Successful Payments'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Filter by Date:'),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => _selectDate(context),
                  icon: Icon(Icons.calendar_today),
                  label: Text(
                    _selectedDate == null
                        ? 'Select Date'
                        : '${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}',
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<DocumentSnapshot>>(
              future: _futureBookings,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final bookings = snapshot.data!;
                  if (bookings.isEmpty) {
                    return Center(
                      child: Text(
                        'No bookings found for the selected date.',
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        var bookingData =
                            bookings[index].data() as Map<String, dynamic>;
                        DateTime date =
                            (bookingData['date'] as Timestamp).toDate();
                        String formattedDate =
                            '${date.day}-${date.month}-${date.year}';
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: ListTile(
                            title: Text(
                              'Category: ${bookingData['category']}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8),
                                Text('Date: $formattedDate'),
                                SizedBox(height: 8),
                                Text('Name: ${bookingData['name']}'),
                                SizedBox(height: 4),
                                Text('Place: ${bookingData['place']}'),
                                SizedBox(height: 8),
                              ],
                            ),
                            onTap: () {
                              // Add onTap functionality if needed
                            },
                          ),
                        );
                      },
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}