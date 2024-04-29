import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginrace/User/ticketbookingstatus.dart';
import 'package:loginrace/User/ticketcart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventTicketDetails extends StatefulWidget {
  String rt_id;
  final int totalTickets;
   EventTicketDetails(  { Key? key,   required this.rt_id, required this. totalTickets, }): super(key: key);

  @override
  State<EventTicketDetails> createState() => _EventTicketDetailsState();
}

class _EventTicketDetailsState extends State<EventTicketDetails> {
   String _name = '';
  bool _isVIP = false;
  int _generalTickets = 0; // Number of general tickets
  int _childTickets = 0; // Number of child tickets

  // Define ticket prices
  double _generalPrice = 100.0;
  double _childPrice = 50.0;
  double _vipPrice = 200.0;

 Future<void> _storeTicketDetails() async {
  try {
    // Get current user ID from SharedPreferences
    SharedPreferences sp = await SharedPreferences.getInstance();
    var userid = sp.getString('uid');

    // Calculate total number of tickets booked
    int totalBookedTickets = _generalTickets + _childTickets;

    // Get current total tickets count from Firestore
    DocumentSnapshot<Map<String, dynamic>> eventSnapshot =
        await FirebaseFirestore.instance
            .collection('racetrack_upload_event')
            .doc(widget.rt_id)
            .get();

    int currentTotalTickets = eventSnapshot['total_tickets'];

    // Ensure that booking doesn't exceed available tickets
    if (totalBookedTickets <= currentTotalTickets) {
      // Update total tickets count in Firestore
      await FirebaseFirestore.instance
          .collection('racetrack_upload_event')
          .doc(widget.rt_id)
          .update({
        'total_tickets': currentTotalTickets - totalBookedTickets,
      });

      // Add ticket details to Firestore
     var ticketRef = await FirebaseFirestore.instance.collection('Eventtickets').add({
        'name': _name,
        'price': _calculatePrice(),
        'totalTickets': totalBookedTickets,
        'timestamp': Timestamp.now(),
        'userid': userid,
        'event_id': widget.rt_id,
        'generalTickets': _generalTickets,
        'childTickets': _childTickets,
      });

      // Get the document ID and store it in the document
      String ticketId = ticketRef.id;
      await ticketRef.update({'ticketId': ticketId});
      // Show success message
     Fluttertoast.showToast(
          msg: "Ticket booking successful!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        // Navigate to ShoppingCart page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ViewStatusPage(),
        ));
      } else {
        // Show error message if booking exceeds available tickets
        Fluttertoast.showToast(
          msg: "Booking exceeds available tickets!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      // Show error message if an error occurs
      Fluttertoast.showToast(
        msg: "Error storing ticket details: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ticket Booking',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Color.fromARGB(255, 96, 150, 212),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name:',
                style: GoogleFonts.poppins(fontSize: 20),
              ),
              SizedBox(height: 10),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your name',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Number of General Tickets:',
                          style: GoogleFonts.poppins(fontSize: 20),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              _generalTickets = int.tryParse(value) ?? 0;
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter number of general tickets',
                            prefixIcon: Icon(Icons.confirmation_number),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Number of Child Tickets:',
                          style: GoogleFonts.poppins(fontSize: 20),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              _childTickets = int.tryParse(value) ?? 0;
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter number of child tickets',
                            prefixIcon: Icon(Icons.confirmation_number),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'VIP Pass:',
                    style: GoogleFonts.poppins(fontSize: 20),
                  ),
                  SizedBox(width: 10),
                  Checkbox(
                    value: _isVIP,
                    onChanged: (value) {
                      setState(() {
                        _isVIP = value ?? false;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _storeTicketDetails();
                  },
                  child: Text(
                    'Book Tickets',
                    style: GoogleFonts.poppins(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Total Tickets: ${_generalTickets + _childTickets}',
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  'Total Amount: \$${_calculatePrice().toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to calculate ticket price based on number of tickets and VIP status
  double _calculatePrice() {
    double totalPrice = (_generalPrice * _generalTickets) + (_childPrice * _childTickets);
    if (_isVIP) {
      totalPrice += _vipPrice;
    }
    return totalPrice;
  }
}