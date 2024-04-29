import 'package:flutter/material.dart';
import 'package:loginrace/Rental/addrentalitems.dart';
import 'package:loginrace/Rental/rentelhome.dart';
import 'package:loginrace/Rental/viewrentproducts.dart';

class RentNavigationbar extends StatefulWidget {
  const RentNavigationbar({super.key});

  @override
  State<RentNavigationbar> createState() => _RentNavigationbarState();
}

class _RentNavigationbarState extends State<RentNavigationbar> {
   int selectedindex=1;
    static  List<dynamic>option=[
   RentalHome(),
   ProductViewPage(),
   RentalServicePage(),
   
  

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
  BottomNavigationBarItem(icon: Icon(Icons.home,),label: 'home'),
  BottomNavigationBarItem(icon: Icon(Icons.repeat_one,),label: 'products'),
  BottomNavigationBarItem(icon: Icon(Icons.logout,),label: 'Service')
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


    