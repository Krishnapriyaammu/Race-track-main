import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginrace/Racetrack/racetrackhome1.dart';
import 'package:loginrace/Racetrack/vieweventbookingdetails.dart';
import 'package:loginrace/Racetrack/viewregistrationevent.dart';
import 'package:shared_preferences/shared_preferences.dart';
class EventDetails extends StatefulWidget {
   final String rt_id;
   


  EventDetails({required this.rt_id});

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
   late Future<DocumentSnapshot<Map<String, dynamic>>> _eventDetailsFuture;
  String _selectedCategory = 'General'; // Default category
  String _vipPrice = ''; // VIP ticket price

  @override
  void initState() {
    super.initState();
    _eventDetailsFuture = getEventDetails();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getEventDetails() async {
    try {
      return await FirebaseFirestore.instance
          .collection('racetrack_upload_event')
          .doc(widget.rt_id)
          .get();
    } catch (e) {
      print('Error fetching event details: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: FutureBuilder(
        future: _eventDetailsFuture,
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data found'));
          } else {
            final eventData = snapshot.data!.data()!;
            final generalPrice =
                eventData['general_price'] ?? 'Price not available';
            final childPrice =
                eventData['child_price'] ?? 'Price not available';
            _vipPrice = eventData['vip_price'] ?? 'Price not available'; // Fetch VIP ticket price

            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/racing.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 40),
                        Text(
                          eventData['event_name'] ?? 'Event Name Not Available',
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Card(
  color: Colors.white.withOpacity(0.8),
  elevation: 4,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Place',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 10),
        Text(
          '${eventData['place'] ?? 'Place Not Available'}',
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
      ],
    ),
  ),
),
SizedBox(height: 10,),
                        Card(
                          color: Colors.white.withOpacity(0.8),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Event Date',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '${eventData['event_date'] ?? 'Date Not Available'}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Card(
                          color: Colors.white.withOpacity(0.8),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Tickets',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '${eventData['total_tickets'] ?? 'Tickets Not Available'}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: Colors.black87,
                                  ),
                                ),
                                  Text(
                                  'Total Vehicles Participating',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                    SizedBox(height: 10),

                                Text(
                                  '${eventData['total_vehicles'] ?? 'vehicles Not Available'}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Card(
                          color: Colors.white.withOpacity(0.8),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Select Ticket Category',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 10),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedCategory,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedCategory = newValue!;
                                      });
                                    },
                                    items: ['General', 'Child']
                                        .map<DropdownMenuItem<String>>(
                                          (category) => DropdownMenuItem<String>(
                                            value: category,
                                            child: Text(
                                              category,
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Card(
                          color: Colors.white.withOpacity(0.8),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              _selectedCategory == 'General'
                                  ? 'General Price: $generalPrice'
                                  : 'Child Price: $childPrice',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Card(
                          color: Colors.white.withOpacity(0.8),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              ' Pay extra  $_vipPrice for VIP seats',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return EventBookingDetails(rt_id:widget.rt_id);
                            }));
                          },
                          child: Text(
                          'View Booking',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 16.0,
                right: 16.0,
                child: FloatingActionButton(
                  onPressed: () {

 Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ViewRegistration(rt_id:widget.rt_id);
                            }));
                  },
                  child: Icon(Icons.receipt_long_outlined),
                  backgroundColor: Colors.blueAccent,
                ),
              ),
            ],
          );
        }
      },
    ),
  );
}
}