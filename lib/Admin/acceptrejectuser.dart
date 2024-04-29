import 'package:flutter/material.dart';

class Adminaccpetrejectuser extends StatefulWidget {
  const Adminaccpetrejectuser({super.key});

  @override
  State<Adminaccpetrejectuser> createState() => _AdminaccpetrejectuserState();
}

class _AdminaccpetrejectuserState extends State<Adminaccpetrejectuser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
      
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(8)),
              height: 300,width: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                     Center(
                       child: CircleAvatar(
                        backgroundImage: AssetImage('images/imaaaa.jpg'),
                        radius: 30,
                                       ),
                     ),
                     Center(
                      child: Column(
                        children: [
                          Text('Krishnapriya'),
                        ],
                      ),
                    ),
                  
                 SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 130),
                    child: Text(
                      'Chennai',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                 
                  Padding(
                    padding: const EdgeInsets.only(left: 130),
                    child: Text(
                      '812972416',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                 
                  Padding(
                    padding: const EdgeInsets.only(left: 130),
                    child: Text(
                      'License',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                   
                 
                 
                    
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                   
                        },
                        child: Text('Accept'),style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      ),
                       ElevatedButton(
                        onPressed: () {
                          
                        },
                        child: Text('Reject'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      ),
                    ],),
                ],
            ),
              ),
          ),
          ),
      ),













    );
  }
}