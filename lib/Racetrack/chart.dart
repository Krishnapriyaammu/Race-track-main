// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class PieDiagram extends StatefulWidget {
//   const PieDiagram({super.key});

//   @override
//   State<PieDiagram> createState() => _PieDiagramState();
// }

// class _PieDiagramState extends State<PieDiagram> {
//    int _totalCoaches = 2;

//   @override
//   void initState() {
//     super.initState();
//     _fetchTotalCoaches();
//   }

//   Future<void> _fetchTotalCoaches() async {
//     try {
//       final QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('race_track_add_coach')
//           .get();
//       setState(() {
//         _totalCoaches = snapshot.size;
//       });
//     } catch (e) {
//       print('Error fetching total coaches: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Racing Track Details'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'Racing Track Statistics',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: PieChart(
//                 PieChartData(
//                   sections: [
//                     PieChartSectionData(
//                       color: Colors.blue,
//                       value: _totalCoaches.toDouble(), // Total coaches
//                       title: 'Total Coaches',
//                       radius: 80,
//                     ),
//                     // Add more sections for other details if needed
//                   ],
//                   sectionsSpace: 0,
//                   centerSpaceRadius: 40,
//                   borderData: FlBorderData(show: false),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Details:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Total Coaches: $_totalCoaches',
//               style: TextStyle(fontSize: 16),
//             ),
//             // Add more details here if needed
//           ],
//         ),
//       ),
//     );
//   }
// }