import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginrace/User/shiftsavailable.dart';
import 'package:table_calendar/table_calendar.dart';

class SlotAvailability extends StatefulWidget {
  String rt_id;
  String level1;
   SlotAvailability({super.key, required this. rt_id, required this. level1});

  @override
  State<SlotAvailability> createState() => _SlotAvailabilityState();
}

class _SlotAvailabilityState extends State<SlotAvailability> {
  double _sliderValue = 1; // Initial value for the slider
  TimeOfDay _startTime = TimeOfDay.now();
    late DateTime _selectedDate; // Selected date
  double _amount = 0; // Amount fetched from Firestore // Initial start time
  double _totalPrice = 0; // Total price

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().add(Duration(days: 1)); // Initialize with tomorrow's date
    _fetchAmountFromFirestore();
  }
Future<void> _fetchAmountFromFirestore() async {
  try {
    final formattedDate = '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}';
    final docRef = FirebaseFirestore.instance.collection('slots').doc(formattedDate);

    final snapshot = await docRef.get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      setState(() {
        _amount = (data['amount'] ?? 0).toDouble();
                  _totalPrice = _amount; // Initialize total price with the fetched amount
 // Explicitly cast to double
      });
    } else {
      setState(() {
        _amount = 0;
       _totalPrice = 0;

      });
    }
  } catch (e, stackTrace) {
    print('Error fetching amount from Firestore: $e');
    print('Stack trace: $stackTrace');
    // You can also show a dialog or a snackbar to inform the user about the error
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred while fetching data from Firestore. Please try again later.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
  @override
  Widget build(BuildContext context) {
    // Calculate the end time based on the start time and the selected number of hours
    TimeOfDay _endTime = _calculateEndTime(_startTime, _sliderValue.toInt());

    return Scaffold(
      appBar: AppBar(title: Text('Book Detail')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CalendarDatePicker(
              initialDate: DateTime.now().add(Duration(days: 1)), // Set initial date to tomorrow
              firstDate: DateTime.now().add(Duration(days: 1)), // Allow selection from tomorrow
              lastDate: DateTime.now().add(Duration(days: 1)), // Allow selection up to tomorrow
              onDateChanged: (date) {
                 setState(() {
                  _selectedDate = date;
                  _fetchAmountFromFirestore(); // Fetch amount whenever the date changes
                });
              },
            ),
            ListTile(
              title: Text('Select Start Time'),
              subtitle: Text(_formatTime(_startTime)),
              onTap: () {
                _pickStartTime(context);
              },
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.yellow,
                thumbColor: Colors.yellow,
                overlayColor: Colors.yellow.withOpacity(0.7),
              ),
              child: Slider(
                value: _sliderValue,
                min: 1,
                max: 12,
                onChanged: (value) {
                  setState(() {
                    _sliderValue = value; 
                                        _updateTotalPrice(); // Update total price when slider value changes
// Update the slider value
                  });
                },
              ),
            ),
            Row(
              children: [
                Text('Start Hour: ${_formatTime(_startTime)}'),
                Spacer(),
                Text('End Hour: ${_formatTime(_endTime)}'),
              ],
            ),
            Divider(color: Colors.grey),
            Row(
              children: [
                Text('Price', style: TextStyle(fontWeight: FontWeight.bold)),
                Spacer(),
                Text('$_amount/1 hour', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Divider(color: Colors.grey),
            Row(
              children: [
                Text('Total Price', style: TextStyle(fontWeight: FontWeight.bold)),
                Spacer(),
                Text('\$${_totalPrice.toStringAsFixed(2)}/${_sliderValue.toInt()} hours',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 20), // Add some space between the rows and the button
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                          return ShiftAvailable(
                                            rt_id:widget.rt_id,
                                           totalPrice: _totalPrice.toStringAsFixed(2), // Convert double to string with two decimal places

                      totalHours: _sliderValue.toInt(),
                          selectedDate: DateTime.now().add(Duration(days: 1)), // Pass selected date

                    
                      startTime: _startTime,
                                            
                                          );
                                        }));                },
                child: Text('NEXT'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to calculate the end time based on the start time and the number of hours
  TimeOfDay _calculateEndTime(TimeOfDay startTime, int hours) {
    int totalMinutes = startTime.hour * 60 + startTime.minute + (hours * 60);
    int endHour = totalMinutes ~/ 60;
    int endMinute = totalMinutes % 60;
    return TimeOfDay(hour: endHour, minute: endMinute);
  }

  // Method to format a TimeOfDay object as a string
  String _formatTime(TimeOfDay time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  // Method to pick the start time using a TimePicker
  Future<void> _pickStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (pickedTime != null && pickedTime != _startTime) {
      setState(() {
        _startTime = pickedTime; // Update the selected start time
      });
    }
  }
 void _updateTotalPrice() {
  int currentHours = _sliderValue.toInt();
  double pricePerHour = _amount;
  
  if (currentHours > _totalPrice) {
    setState(() {
      _totalPrice = pricePerHour * currentHours;
    });
  } else if (currentHours < _totalPrice) {
    setState(() {
      _totalPrice = pricePerHour * currentHours;
    });
  }
}
}