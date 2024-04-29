import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginrace/Racetrack/addeventss.dart';
import 'package:loginrace/Racetrack/chart.dart';
import 'package:loginrace/Racetrack/eventdetailss.dart';
import 'package:loginrace/Racetrack/viewprofileracetrack.dart';
import 'package:loginrace/User/evntticketbooking.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RaceTrackViewEvents extends StatefulWidget {
  const RaceTrackViewEvents({super.key});

  @override
  State<RaceTrackViewEvents> createState() => _RaceTrackViewEventsState();
}

class _RaceTrackViewEventsState extends State<RaceTrackViewEvents> {
   TextEditingController _searchController = TextEditingController();
     String imageUrl='';




   Future<List<DocumentSnapshot>> getData() async {
  try {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var a = sp.getString('uid');

    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('racetrack_upload_event')
        .where('rt_id', isEqualTo: a)
        .get();

    print('Fetched ${snapshot.docs.length} documents');


    return snapshot.docs;
  } catch (e) {
    print('Error fetching data: $e');
    throw e;
  }
}

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () async {
            SharedPreferences sp = await SharedPreferences.getInstance();
            String userId = sp.getString('uid') ?? '';
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return RaceTrackViewProfile(userId: userId);
            }));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.person_pin,
              size: 32,
              color: Colors.black,
            ),
          ),
        ),
        title: Text(
          'Events',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
       
        ],
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2, // Number of columns
    crossAxisSpacing: 10.0,
    mainAxisSpacing: 10.0,
  ),
  itemCount: snapshot.data?.length ?? 0,
  itemBuilder: (context, index) {
    final document = snapshot.data![index];

      // var id = document['rt_id'];
      // print(id);
    final data = document.data() as Map<String, dynamic>;
    final imageUrl = data['image_url'];
    int totalTickets = data['total_tickets'] != null ? data['total_tickets'] as int : 0;
    final childPrice = data['child_price'] != null ? data['child_price'] as int : 0;
    final generalPrice = data['general_price'] != null ? data['general_price'] as int : 0;






    print('ImageUrl: $imageUrl'); // Debug print

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EventDetails(rt_id:snapshot.data![index].id,),),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl ?? ''), // Ensure imageUrl is not null
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['event_name'] ?? 'Name not available',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    data['place'] ?? 'place not available',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),

             Text(
  'Total Tickets: $totalTickets',
  style: GoogleFonts.poppins(
    fontSize: 14,
    color: Colors.grey,
  ),
),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        data['event_date'] ?? 'Date not available',
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
        floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventAdd()),
              );
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.white,
          ),
          SizedBox(height: 16),
  //         FloatingActionButton(
  //           onPressed: () {
  // Navigator.push(
  //               context,
  //               MaterialPageRoute(builder: (context) => PieDiagram()),
  //             );            },
  //           child: Icon(Icons.grading_sharp),
  //           backgroundColor: Colors.white,
  //         ),
        ],
      ),
    );
  }
}