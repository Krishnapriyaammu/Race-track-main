import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class ViewStatusPage extends StatefulWidget {
 

  const ViewStatusPage(
      {Key? key,}) : super(key: key);

  @override
  State<ViewStatusPage> createState() => _ViewStatusPageState();
}

class _ViewStatusPageState extends State<ViewStatusPage> {
  late Future<List<DocumentSnapshot>> _ticketDetails;

  @override
  void initState() {
    super.initState();
    _ticketDetails = fetchTicketDetails();
  }

  Future<List<DocumentSnapshot>> fetchTicketDetails() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Eventtickets')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    return snapshot.docs;
  }

  Future<void> _downloadTicket() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Ticket Details:',
                style: pw.TextStyle(fontSize: 20),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Ticket Name:',
                style: pw.TextStyle(fontSize: 18),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Total Tickets: ',
                style: pw.TextStyle(fontSize: 18),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Total Price: ',
                style: pw.TextStyle(fontSize: 18),
              ),
            ],
          );
        },
      ),
    );

    final String dir = (await getExternalStorageDirectory())!.path;
    final String path = '$dir/ticket.pdf';
    final File file = File(path);
    await file.writeAsBytes(await pdf.save());
    print('PDF saved at $path');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ticket Details',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Color.fromARGB(255, 96, 150, 212),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ticket Details',
              style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            FutureBuilder<List<DocumentSnapshot>>(
              future: _ticketDetails,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No ticket details found');
                } else {
final Map<String, dynamic> ticketData = snapshot.data!.first.data() as Map<String, dynamic>;
final int generalPrice = ticketData['general_price'] != null ? int.parse(ticketData['general_price']) : 0;
final int childPrice = ticketData['child_price'] != null ? int.parse(ticketData['child_price']) : 0;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ' Name: ${ticketData['name']}',
                        style: GoogleFonts.poppins(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Total Tickets: ${ticketData['totalTickets']}',
                        style: GoogleFonts.poppins(fontSize: 18),
                      ),
                      SizedBox(height: 10),
    //                     Text(
    //   'Total General tickets: $generalPrice',
    //   style: GoogleFonts.poppins(fontSize: 18),
    // ),
    //                    SizedBox(height: 10),
    //                     Text(
    //   'Total Child tickets: $childPrice',
    //   style: GoogleFonts.poppins(fontSize: 18),
    // ),
                       SizedBox(height: 10),

                      Text(
                        'Total Price: ${ticketData['price']}',
                        style: GoogleFonts.poppins(fontSize: 18),
                      ),
                    ],
                  );
                }
              },
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _downloadTicket,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Text(
                  'Download Ticket',
                  style: GoogleFonts.poppins(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}