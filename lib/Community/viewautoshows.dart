import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginrace/Community/luxurycar.dart';
import 'package:loginrace/Community/motorbike.dart';
import 'package:loginrace/Community/sportscar.dart';
import 'package:loginrace/Community/vintagecar.dart';

class ViewAutoshow extends StatefulWidget {
  String community_id;
   ViewAutoshow({super.key, required  this.community_id, String? selectedCategory, List<File>? uploadedImages});

  @override
  State<ViewAutoshow> createState() => _ViewAutoshowState();
}

class _ViewAutoshowState extends State<ViewAutoshow> {
List<Color> c = [Colors.brown, Colors.red, Colors.purple];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 60),
            child: Text(
              'CATEGORY',
              style: TextStyle(color: Color.fromARGB(221, 87, 4, 80)),
            ),
          ),
        ),
      ),
      body: 
     
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              children: [
                CategoryCard(
                  imagePath: 'images/vintage.jpg',
                  category: 'Vintage Car',
                  community_id: widget.community_id,
                ),
                SizedBox(width: 20),
                CategoryCard(
                  imagePath: 'images/luxuary.jpg',
                  category: 'Luxury Car',
                  community_id: widget.community_id,
                ),
                SizedBox(width: 20),
                CategoryCard(
                  imagePath: 'images/motor.jpg',
                  category: 'Motor Bikes',
                 community_id: widget.community_id,
                ),
                SizedBox(width: 20),
                CategoryCard(
                  imagePath: 'images/sports.jpg',
                  category: 'Sports Car',
                  community_id: widget.community_id,
                ),
              ],
            ),
          )
    );
        
      
    
  }
}

class CategoryCard extends StatelessWidget {
  final String imagePath;
  final String category;
  final String community_id;

  const CategoryCard({
    required this.imagePath,
    required this.category, required this. community_id,
  });

  Widget build(BuildContext context) {
    void navigateToCategoryPage() {
      switch (category) {
        case 'Vintage Car':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VintageCar(community_id:community_id ,)),
          );
          break;
        case 'Luxury Car':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LuxuryCar(community_id: community_id,),),
          );
          break;
        case 'Motor Bikes':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MotorBike(community_id: community_id)),
          );
          break;
        case 'Sports Car':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SportsCar(community_id: community_id)),
          );
          break;
        default:
          // Handle if a new category is added in the future
          break;
      }
    }

    return InkWell(
      onTap: navigateToCategoryPage,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color.fromARGB(255, 94, 87, 1),
            width: 2.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                imagePath,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              category,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 