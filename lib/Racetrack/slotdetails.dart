import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SlotDetails extends StatefulWidget {
  const SlotDetails({super.key});

  @override
  State<SlotDetails> createState() => _SlotDetailsState();
}

class _SlotDetailsState extends State<SlotDetails> {
   String? _selectedDate;
  String? _selectedSlot;
  List<Map<String, dynamic>> _filteredBookings = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Slot Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select a Date:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                _pickDate();
              },
              child: Text(_selectedDate ?? 'Pick a date'),
            ),
            SizedBox(height: 16),
            Text(
              'Select a Slot:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: _selectedSlot,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSlot = newValue;
                });
              },
              items: [
                DropdownMenuItem(child: Text('Morning'), value: 'Morning'),
                DropdownMenuItem(child: Text('Evening'), value: 'Evening'),
                DropdownMenuItem(child: Text('Night'), value: 'Night'),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _searchBookings();
              },
              child: Text('Search'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _filteredBookings.isEmpty
                  ? Center(child: Text('No bookings found'))
                  : ListView.builder(
                      itemCount: _filteredBookings.length,
                      itemBuilder: (context, index) {
                        final booking = _filteredBookings[index];
                        final userName = booking['userName'];
                        final selectedSlot = booking['selectedSlot'];
                        final selectedDate = booking['selectedDate'];
                        final totalPrice = booking['totalPrice'];
                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                              'User Name: $userName',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 4),
                                Text('Slot: $selectedSlot'),
                                SizedBox(height: 4),
                                Text('Date: $selectedDate'),
                                SizedBox(height: 4),
                                Text('Total Price: $totalPrice'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 7)),
    );
    if (selectedDate != null) {
      final formattedDate =
          '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
      setState(() {
        _selectedDate = formattedDate;
      });
    }
  }

  void _searchBookings() async {
    if (_selectedDate == null || _selectedSlot == null) {
      print('Please select both date and slot');
      return;
    }

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('user_track_booking')
              .where('selectedDate', isEqualTo: _selectedDate)
              .where('selectedSlot', isEqualTo: _selectedSlot)
              .get();

      List<Map<String, dynamic>> filteredBookings = [];
      for (var doc in querySnapshot.docs) {
        final userId = doc.data()['userid'];
        final selectedSlot = doc.data()['selectedSlot'];
        if (userId != null && selectedSlot != null) {
          DocumentSnapshot<Map<String, dynamic>> userSnapshot =
              await FirebaseFirestore.instance.collection('user_register').doc(userId).get();
          if (userSnapshot.exists) {
            final userName = userSnapshot.data()?['name'] ?? '';
            final selectedDate = doc.data()['selectedDate'];
            final totalPrice = doc.data()['totalPrice'];
            filteredBookings.add({
              'userName': userName,
              'selectedSlot': selectedSlot,
              'selectedDate': selectedDate,
              'totalPrice': totalPrice,
            });
          }
        }
      }

      setState(() {
        _filteredBookings = filteredBookings;
      });
    } catch (error) {
      print('Error searching bookings: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred while searching bookings'),
      ));
    }
  }
}