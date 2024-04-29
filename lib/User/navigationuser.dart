import 'package:flutter/material.dart';
import 'package:loginrace/User/userhome.dart';
import 'package:loginrace/User/userfirstpage.dart';
import 'package:loginrace/User/viewcommunity.dart';
import 'package:loginrace/User/viewevents.dart';
import 'package:loginrace/User/viewracetrack.dart';
import 'package:loginrace/User/viewrentitems.dart';
import 'package:loginrace/User/viewtrackdetails.dart';

class NavigationUser extends StatefulWidget {
  
  const NavigationUser({super.key,});

  @override
  State<NavigationUser> createState() => _NavigationUserState();
}

class _NavigationUserState extends State<NavigationUser> {
    int selectedindex=1;
static  List<dynamic>option=[
  ViewEvents(),
  ViewRacetrack(),
  UserViewFullRenters(),
  ViewCommunity(),

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
  BottomNavigationBarItem(icon: Icon(Icons.remove_shopping_cart_outlined,),label: 'Rental'),

    BottomNavigationBarItem(icon: Icon(Icons.commute,),label: 'Community'),


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
 








