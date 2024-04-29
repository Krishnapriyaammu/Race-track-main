import 'package:flutter/material.dart';
import 'package:loginrace/Community/luxurycar.dart';
import 'package:loginrace/Community/motorbike.dart';
import 'package:loginrace/Community/sportscar.dart';
import 'package:loginrace/Community/vintagecar.dart';

class SearchAutoshow extends StatefulWidget {
  String community_id;
   SearchAutoshow({super.key, required this. community_id});

  @override
  State<SearchAutoshow> createState() => _SearchAutoshowState();
}

class _SearchAutoshowState extends State<SearchAutoshow> {
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
                            builder: (context) => LuxuryCar(community_id: widget.community_id,),
                          ),
                        );
                        break;
                      case 'Sports Car':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SportsCar(community_id: widget.community_id,),
                          ),
                        );
                        break;
                      case 'Motor Bikes':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MotorBike(community_id: widget.community_id,),
                          ),
                        );
                        break;
                      case 'Vintage Car':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VintageCar(community_id:widget.community_id),
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