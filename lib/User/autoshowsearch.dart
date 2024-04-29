import 'package:flutter/material.dart';
import 'package:loginrace/Community/sportscar.dart';
import 'package:loginrace/Community/vintagecar.dart';
import 'package:loginrace/User/Vintagepage.dart';
import 'package:loginrace/User/luxuarycarpage.dart';
import 'package:loginrace/User/motorbike.dart';
import 'package:loginrace/User/sportscarpage.dart';

class AutoshowSearch extends StatefulWidget {
  String communityId;
   AutoshowSearch({super.key, required this. communityId});

  @override
  State<AutoshowSearch> createState() => _AutoshowSearchState();
}

class _AutoshowSearchState extends State<AutoshowSearch> {
   String? _selectedVehicle;

  final List<String> _vehicleTypes = [
    'Luxury Car',
    'Sports Car',
    'Motor Bikes',
    'Vintage Car',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Page'),
      ),
       body: Center(
        child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedVehicle,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Select a vehicle type',
                ),
                items: _vehicleTypes.map((String vehicleType) {
                  return DropdownMenuItem<String>(
                    value: vehicleType,
                    child: Text(vehicleType),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedVehicle = newValue;
                  });
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Implement navigation based on the selected vehicle type
                  if (_selectedVehicle != null) {
                    // Navigate to corresponding page
                    switch (_selectedVehicle) {
                      case 'Luxury Car':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LuxuaryPage(community_id:widget.communityId),
                          ),
                        );
                        break;
                      case 'Sports Car':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SportsCarPage(community_id:widget.communityId),
                          ),
                        );
                        break;
                      case 'Motor Bikes':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MotorBikePage(community_id:widget.communityId),
                          ),
                        );
                        break;
                      case 'Vintage Car':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VintageCarPage(community_id:widget.communityId),
                          ),
                        );
                        break;
                      default:
                        break;
                    }
                  } else {
                    print('Please select a vehicle type');
                  }
                },
                child: Text('Search'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}