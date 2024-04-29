import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginrace/User/eventregistration.dart';
import 'package:loginrace/User/ticketcart.dart';
import 'package:loginrace/User/ticketdetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
class EventTicketBooking extends StatefulWidget {
   final String rt_id;
   


  EventTicketBooking({required this.rt_id});

  @override
  _EventTicketBookingState createState() => _EventTicketBookingState();
}

class _EventTicketBookingState extends State<EventTicketBooking>
 with SingleTickerProviderStateMixin { // Add SingleTickerProviderStateMixin here
  late Future<DocumentSnapshot<Map<String, dynamic>>> _eventDetailsFuture;
  String _selectedCategory = 'General';
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _eventDetailsFuture = getEventDetails();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            final generalPrice = (eventData['general_price'] ?? 0) as int;
            final childPrice = (eventData['child_price'] ?? 0) as int;
            final totalTickets = (eventData['total_tickets'] ?? 0) as int;
            final totalvehicles =(eventData['total_vehicles']?? 0) as int;

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
                        SizedBox(height: 100),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventRegistrationPage(rt_id:widget.rt_id), // Your registration page
                              ),
                            );
                          },
                          child: SizedBox(
                            width: double.infinity,
                            child: DefaultTextStyle(
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              child:
                               AnimatedTextKit(
                                animatedTexts: [
                                  TypewriterAnimatedText(' Register now!!!!'),
                                ],
                                onTap: () {
                                 
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EventRegistrationPage(rt_id:widget.rt_id), // Your registration page
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            eventData['event_name'] ?? 'Event Name Not Available',
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Event Date',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF212121),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '${eventData['event_date'] ?? 'Date Not Available'}',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Color(0xFF212121),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Tickets',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF212121),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '$totalTickets',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Color(0xFF212121),
                                ),
                              ),
                              Text(
                                'Total Vehicles participating',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF212121),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '$totalvehicles',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Color(0xFF212121),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        DropdownButtonHideUnderline(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                            ),
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
                                          fontSize: 20,
                                          color: Color(0xFF212121),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _selectedCategory == 'General'
                                ? 'General Price: $generalPrice'
                                : 'Child Price: $childPrice',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: Color(0xFF212121),
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return EventTicketDetails(
                                  rt_id: widget.rt_id,
                                  totalTickets: totalTickets, // Pass total tickets to the next page
                                );
                              }),
                            );
                          },
                          child: Text(
                            'Next',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
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