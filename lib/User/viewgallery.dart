import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewGallery extends StatefulWidget {
  String rt_id;
   ViewGallery({super.key,required this.rt_id});

  @override
  State<ViewGallery> createState() => _ViewGalleryState();
}

class _ViewGalleryState extends State<ViewGallery> {

     Future<List<DocumentSnapshot>> getdata() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('race_track_add_gallery').where('uid',isEqualTo: widget.rt_id)
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
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'RACR GALLERY',
                style: GoogleFonts.getFont(
                  'Josefin Sans',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder(
                future: getdata(),
                builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200, // Maximum width for each item
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                      ),
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final document = snapshot.data![index];
                        final data = document.data() as Map<String, dynamic>;
                        final imageUrl = data['image_url'];

                        return GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => EventDetaild()),
                            // );
                          },
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}