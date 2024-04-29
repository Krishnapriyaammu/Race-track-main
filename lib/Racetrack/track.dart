// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:loginrace/Racetrack/uploadeventimage.dart';
// import 'package:loginrace/Racetrack/uploadracetractimage.dart';

// class TrackAdd extends StatefulWidget {
//   const TrackAdd({super.key});

//   @override
//   State<TrackAdd> createState() => _TrackAddState();
// }

// class _TrackAddState extends State<TrackAdd> {
//   var trackname=TextEditingController();
//   var tracktype=TextEditingController();
//   var state=TextEditingController();
//       final fkey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(

// appBar: AppBar(backgroundColor: Colors.blue,),
      
// body: 
        
//         SafeArea(
          
  
//          child: Center(
//            child: Padding(
//              padding:  EdgeInsets.all(40.00),
//              child: Form(
//               key: fkey,
//                child: Container(
                
                
//                 width: 400,
//                  child: SingleChildScrollView(
//                    child: Padding(
//                      padding: const EdgeInsets.only(top:20,bottom: 20),
//                      child: Column(
                      
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text('RACE TRACK', style: TextStyle(
//                   fontSize: 24.0,
//                   fontWeight: FontWeight.bold,
//                 ),),
                  
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(10.0),
//                               child: Text('Track Name',),
//                             ),
//                           ],
//                         ),
//                         TextFormField(
//                           controller: trackname,
//                           validator: (value) {
//                              if (value!.isEmpty) {
//                           return 'enter track name';
//                         }
//                           },
//                           decoration: InputDecoration(hintText: 'Track Name',fillColor: Color.fromARGB(112, 243, 214, 214),filled: true,
//                           border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                                         
//                           ),
//                           ),
                     
                     
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(10.0),
//                               child: Text('Track type',),
//                             ),
//                           ],
//                         ),
//                         TextFormField(
//                           controller: tracktype,
//                           validator: (value) {
//                              if (value!.isEmpty) {
//                           return 'enter track type';
//                         }
//                           },
//                           decoration: InputDecoration(hintText: 'Track type',fillColor: Color.fromARGB(112, 243, 214, 214),filled: true,
//                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                                         
//                         ),),
                     
//                           // SizedBox(height: 10,),
                     
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(10.0),
//                               child: Text('Rating',),
//                             ),
//                           ],
//                         ),
//                         TextFormField(
//                           decoration: InputDecoration(hintText: 'Rating',fillColor: Color.fromARGB(112, 243, 214, 214),filled: true,
//                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                        
//                         ),),
                     
                        
                     
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(10.0),
//                               child: Text('State',),
//                             ),
//                           ],
//                         ),
//                         TextFormField(
//                           controller: state,
//                           validator: (value) {
//                              if (value!.isEmpty) {
//                           return 'enter state';
//                         }
//                           },
//                           decoration: InputDecoration(hintText: 'State',fillColor: Color.fromARGB(112, 243, 214, 214),filled: true,
//                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                        
//                         ),),
                     
                        
                     
                       
                     
                        
//                         SizedBox(height: 40,),
                     
//                         ElevatedButton(onPressed: (){
//                           print(trackname.text);
//                           print(tracktype.text);
//                           print(state.text);
//                                                      if (fkey.currentState!.validate()) {
               
               
//                            Navigator.push(context, MaterialPageRoute(builder: (context) {
//                               return UploadRaceTrackImage();
//                     },));
//                                                      }
//                         }, 
//                         style:ButtonStyle(backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 249, 249, 252))),
//                         child: Text('NEXT',style: TextStyle(color: Colors.black),))
                     
                        
                        
                        
                     
                     
                     
                     
//                       ],
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//            ),
//          ),
//        )






//     );
//   }
// }