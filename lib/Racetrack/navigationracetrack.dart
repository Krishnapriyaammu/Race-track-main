import 'package:flutter/material.dart';
import 'package:loginrace/Racetrack/racetrackhome1.dart';
import 'package:loginrace/Racetrack/racetrackhome3.dart';
import 'package:loginrace/Racetrack/notificationracetrack.dart';
import 'package:loginrace/Racetrack/racetrackhome2.dart';
import 'package:loginrace/Racetrack/racetrackhome4.dart';

class RaceTrackNavigation extends StatefulWidget {
  const RaceTrackNavigation({super.key});

  @override
  State<RaceTrackNavigation> createState() => _RaceTrackNavigationState();
}

class _RaceTrackNavigationState extends State<RaceTrackNavigation> {
   int selectedindex=1;
static  List<dynamic>option=[
 RaceTrackViewEvents(),
 RaceTrackViewRace(),
 InstructorHomePage(),
 TrackDetailsGallery(),
 
 
   
];
  void ontop(int index){
    setState(() {
      selectedindex=index;
    });
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
 body: Center(child:option.
      elementAt(selectedindex),),
bottomNavigationBar: BottomNavigationBar(items: [
  BottomNavigationBarItem(icon: Icon(Icons.home_sharp,),label: 'home'),
  BottomNavigationBarItem(icon: Icon(Icons.add_road_rounded,),label: 'race track'),
  BottomNavigationBarItem(icon: Icon(Icons.rate_review_outlined,),label: 'Feedback'),
    BottomNavigationBarItem(icon: Icon(Icons.circle_notifications,),label: 'Notification'),

],
type: BottomNavigationBarType.shifting,
currentIndex: selectedindex,
selectedItemColor: Color.fromARGB(255, 194, 47, 174),
unselectedItemColor: const Color.fromARGB(255, 13, 13, 14),
iconSize: 20,
onTap: ontop,
elevation: 5
),



    );
  }
}