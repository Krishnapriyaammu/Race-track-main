import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loginrace/Community/booking.dart';
import 'package:loginrace/User/bookingstatus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShiftAvailable extends StatefulWidget {
 final String rt_id;
  final String totalPrice;
  final int totalHours;
  final TimeOfDay startTime;
  final DateTime selectedDate; 


    ShiftAvailable({
    Key? key,
    required this.rt_id,
    required this.totalPrice,
    required this.totalHours,
    required this.startTime,  
    required this. selectedDate,
  }) : super(key: key);

  @override
  State<ShiftAvailable> createState() => _ShiftAvailableState();
}

class _ShiftAvailableState extends State<ShiftAvailable> {
   String selectedSlot = '';
  String selectedPaymentOption = '';
  List<String> paymentOptions = ['Credit Card', 'Google Pay', 'PayPal'];
  int morningCount = 0;
  int eveningCount = 0;
  int nightCount = 0;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchSlotCounts();
  }

  Future<void> fetchSlotCounts() async {
    morningCount = await getSlotCount('Morning');
    eveningCount = await getSlotCount('Evening');
    nightCount = await getSlotCount('Night');
  }

  Future<int> getSlotCount(String slotName) async {
    try {
      final formattedDate =
          '${widget.selectedDate.year}-${widget.selectedDate.month}-${widget.selectedDate.day}';
      final snapshot = await FirebaseFirestore.instance
          .collection('slots')
          .doc(formattedDate)
          .get();
      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null && data.containsKey(slotName.toLowerCase() + 'Count')) {
          return data[slotName.toLowerCase() + 'Count'];
        }
      } else {
        print('Document does not exist for $formattedDate');
      }
    } catch (e) {
      print('Error fetching slot count: $e');
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Slot and Payment Option'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Morning Slot Button
            SlotButton(
              slotName: 'Morning',
              isSelected: selectedSlot == 'Morning',
              onTap: () async {
                setState(() {
                  selectedSlot = 'Morning';
                });
                // Fetch the morning count from Firestore
                morningCount = await getSlotCount('Morning');
              },
              count: morningCount,
            ),
            SizedBox(height: 10),
            // Evening Slot Button
            SlotButton(
              slotName: 'Evening',
              isSelected: selectedSlot == 'Evening',
              onTap: () async {
                setState(() {
                  selectedSlot = 'Evening';
                });
                // Fetch the evening count from Firestore
                eveningCount = await getSlotCount('Evening');
              },
              count: eveningCount,
            ),
            SizedBox(height: 10),
            // Night Slot Button
            SlotButton(
              slotName: 'Night',
              isSelected: selectedSlot == 'Night',
              onTap: () async {
                setState(() {
                  selectedSlot = 'Night';
                });
                // Fetch the night count from Firestore
                nightCount = await getSlotCount('Night');
              },
              count: nightCount,
            ),
            SizedBox(height: 40),
            Text(
              'Selected Slot: $selectedSlot',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            // Display slot counts below the selected slot text
            if (selectedSlot.isNotEmpty) ...[
              Text('Count: ${getCount()}'),
            ],
            SizedBox(height: 40),
            // Select Payment Option Dropdown
            Text(
              'Select Payment Option:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedPaymentOption.isNotEmpty
                  ? selectedPaymentOption
                  : null,
              onChanged: (String? newValue) {
                setState(() {
                  selectedPaymentOption = newValue!;
                });
              },
              items: paymentOptions
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Selected Payment Option: $selectedPaymentOption',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitData,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  int getCount() {
    switch (selectedSlot) {
      case 'Morning':
        return morningCount;
      case 'Evening':
        return eveningCount;
      case 'Night':
        return nightCount;
      default:
        return 0;
    }
  }

  void submitData() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      var userid = sp.getString('uid');

      // Convert TimeOfDay to string
      String startTimeString =
          '${widget.startTime.hour}:${widget.startTime.minute}';
           String selectedDateString =
        '${widget.selectedDate.year}-${widget.selectedDate.month.toString().padLeft(2, '0')}-${widget.selectedDate.day.toString().padLeft(2, '0')}';


         DocumentReference bookingRef = await FirebaseFirestore.instance.collection('user_track_booking').add({
      'rt_id': widget.rt_id,
      'userid': userid,
      'selectedDate': selectedDateString,
      'totalPrice': widget.totalPrice,
      'totalHours': widget.totalHours,
      // Store TimeOfDay as string
      'startTime': startTimeString,
      'selectedSlot': selectedSlot,
      'selectedPaymentOption': selectedPaymentOption,
      // Include the document ID as part of the document data
      'documentId': '', // Placeholder for the document ID
    });

    // Get the document ID from the booking reference
    String documentId = bookingRef.id;

    // Update the document with the actual document ID
    await bookingRef.update({'documentId': documentId});

    // Update slot count after successful booking
    await updateSlotCount(selectedSlot);

    // Show success message
    Fluttertoast.showToast(msg: 'Track booked successfully');
  } catch (e) {
    // Show error message
    Fluttertoast.showToast(msg: 'Failed to submit data: $e');
  }
}
  Future<void> updateSlotCount(String slotName) async {
    try {
      final formattedDate =
          '${widget.selectedDate.year}-${widget.selectedDate.month}-${widget.selectedDate.day}';
      final docRef = firestore.collection('slots').doc(formattedDate);

      // Start a Firestore transaction
      await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          int currentCount = data[slotName.toLowerCase() + 'Count'] ?? 0;
          if (currentCount > 0) {
            // Decrease the slot count by 1
            transaction.update(docRef, {
              slotName.toLowerCase() + 'Count': currentCount - 1,
            });
          } else {
            throw Exception('Slot count cannot be negative');
          }
        } else {
          throw Exception('Document does not exist for $formattedDate');
        }
      });
    } catch (e) {
      print('Error updating slot count: $e');
      throw Exception('Failed to update slot count: $e');
    }
  }
}

class SlotButton extends StatelessWidget {
  final String slotName;
  final bool isSelected;
  final VoidCallback onTap;
  final int count;

  const SlotButton({
    required this.slotName,
    required this.isSelected,
    required this.onTap,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              slotName,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isSelected) Text('Count: $count'),
          ],
        ),
      ),
    );
  }
}