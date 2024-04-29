import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginrace/Community/booking.dart';
import 'package:loginrace/User/autoshowsearch.dart';
import 'package:loginrace/User/chat.dart';
import 'package:loginrace/User/joincomm.dart';

class CommunityDetails extends StatefulWidget {
  String communityImage;
  String communityName;
  String communityId;
  String email;
   CommunityDetails({super.key, required this. communityName, required this. communityImage, required this. communityId, required this. email, });

  @override
  State<CommunityDetails> createState() => _CommunityDetailsState();
}

class _CommunityDetailsState extends State<CommunityDetails> {
late List<String> _addedImages = [];

  @override
  void initState() {
    super.initState();
    fetchAddedImages();
  }

  Future<void> fetchAddedImages() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('community_upload_image')
          .where('community_id', isEqualTo: widget.communityId)
          .get();

      setState(() {
        _addedImages = snapshot.docs.map((doc) => doc['imageUrl'] as String).toList();
      });
    } catch (error) {
      print('Error fetching added images: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Details'),
      ),
     body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              backgroundImage: NetworkImage(widget.communityImage),
              radius: 70,
              backgroundColor: Colors.grey,
            ),
            SizedBox(height: 10),
            Text(
              widget.communityName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AutoshowSearch(communityId: widget.communityId)),
                    );
                  },
                  child: Text('AUTOSHOWS'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 229, 225, 235),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.6),
                    ),
                  ),
                ),
              ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(communityId: widget.communityId),
      ),
    );
  },
  child: Text('JOIN US'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 229, 225, 235),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.6),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: _addedImages.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    _addedImages[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}