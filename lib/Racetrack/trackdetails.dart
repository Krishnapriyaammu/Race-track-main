import 'package:flutter/material.dart';
import 'package:loginrace/Racetrack/gallery.dart';

class TrackDetails extends StatefulWidget {
  const TrackDetails({super.key});

  @override
  State<TrackDetails> createState() => _TrackDetailsState();
}

class _TrackDetailsState extends State<TrackDetails> {
  var name=TextEditingController();
  var surface=TextEditingController();
  var length=TextEditingController();
  var turns=TextEditingController();
  var record=TextEditingController();
                                final fkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(backgroundColor: Colors.blue,),
      
body: 
        
        SafeArea(
  
         child: Center(
           child: Padding(
             padding:  EdgeInsets.all(40.00),
             child: Form(
              key: fkey,
               child: Container(
                
                width: 400,
                 child: SingleChildScrollView(
                   child: Padding(
                     padding: const EdgeInsets.only(top:20,bottom: 20),
                     child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('TRACK', style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),),
                       
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Name',),
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: name,
                          validator: (value) {
                             if (value!.isEmpty) {
                        return 'enter name';
                      }
                          },
                          decoration: InputDecoration(hintText: 'Name',fillColor:  Color.fromARGB(112, 243, 214, 214),filled: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                        ),),
                     
                          // SizedBox(height: 10,),
                     
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Surface',),
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: surface,
                          validator: (value) {
                             if (value!.isEmpty) {
                        return 'enter surface';
                      }
                          },
                          decoration: InputDecoration(hintText: 'Surface',fillColor: Color.fromARGB(112, 243, 214, 214),filled: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                                         
                        ),),
                     
                          // SizedBox(height: 10,),
                     
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Length',),
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: length,
                          validator: (value) {
                             if (value!.isEmpty) {
                        return 'enter length';
                      }
                          },
                          decoration: InputDecoration(hintText: 'Length',fillColor: Color.fromARGB(112, 243, 214, 214),filled: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                        
                        ),),
                     
                          // SizedBox(height: 10,),
                     
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Turns',),
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: turns,
                          validator: (value) {
                             if (value!.isEmpty) {
                        return 'enter turns';
                      }
                          },
                          decoration: InputDecoration(hintText: 'Turns',fillColor: Color.fromARGB(112, 243, 214, 214),filled: true,
                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                                         
                        ),),
                     
                          // SizedBox(height: 10,),
                     
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Race lap record',),
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: record,
                          validator: (value) {
                            if (value!.isEmpty) {
                        return 'enter record';
                      }
               
                          },
                             
  
                          decoration: InputDecoration(hintText: 'lap record',fillColor: Color.fromARGB(112, 243, 214, 214),filled: true,
                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                        
                        ),),
                     
                        
                     
                       
                     
                        
                        SizedBox(height: 40,),
                     
                        ElevatedButton(onPressed: (){
                          print(name.text);
                          print(surface.text);
                          print(turns.text);
                          print(record.text);
                          print(length.text);
                                                                             if (fkey.currentState!.validate()) {

               
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return Gallery();
                    },));
                                                                             }
                        }, 
                        style:ButtonStyle(backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 231, 227, 227))),
                        child: Text('DONE',style: TextStyle(color: Colors.black),))
                     
                        
                        
                        
                     
                     
                     
                     
                      ],
                     ),
                   ),
                 ),
               ),
             ),
           ),
         ),
       )



    );
  }
}