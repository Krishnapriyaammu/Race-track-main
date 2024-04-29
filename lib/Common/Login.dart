import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loginrace/Admin/adminhome.dart';
import 'package:loginrace/Community/communityregis.dart';
import 'package:loginrace/Community/forgotcommunity.dart';
import 'package:loginrace/Community/navigation.dart';
import 'package:loginrace/Racetrack/forgotracetrack.dart';
import 'package:loginrace/Racetrack/navigationracetrack.dart';
import 'package:loginrace/Racetrack/racetrackhome1.dart';
import 'package:loginrace/Racetrack/registration.dart';
import 'package:loginrace/Rental/forgotrental.dart';
import 'package:loginrace/Rental/rentalregistration.dart';
import 'package:loginrace/Rental/rentnavigation.dart';
import 'package:loginrace/User/forgotuser.dart';
import 'package:loginrace/User/navigationuser.dart';
import 'package:loginrace/User/userHomee.dart';
import 'package:loginrace/User/userhome.dart';
import 'package:loginrace/User/userregis.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  String type;
  Login({Key? key, required this.type}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController user = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  final GlobalKey<FormState> fkey = GlobalKey<FormState>();

  Future<void> checkData() async {
    if (email.text == 'admin@gmail.com' && pass.text == 'admin123') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return AdminHome();
      }));
    }

    if (widget.type == 'user') {
      
      final QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('user_register')
          .where('email', isEqualTo: email.text)
          .where('password', isEqualTo: pass.text)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        print('______________________');
        var userid = userSnapshot.docs[0].id;
          var image_url = userSnapshot.docs[0]['image_url'];
            var username = userSnapshot.docs[0]['name'];
             var email = userSnapshot.docs[0]['email'];
             var mobileno = userSnapshot.docs[0]['mobile no'];
             var place = userSnapshot.docs[0]['place'];

      
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setString('uid', userid);
          sp.setString('name', username);
            sp.setString('image_url',image_url);
            sp.setString('email', email);
            sp.setString('mobile no', mobileno);
            sp.setString('place', place);

        if(userSnapshot.docs.isNotEmpty){

        Fluttertoast.showToast(msg: 'Login Successful as User');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return NavigationUser();
        }));
      } }

      else {
        showLoginFailedDialog();
      }

    }

       
    if (widget.type == 'race track')
     {
      final QuerySnapshot raceSnapshot = await FirebaseFirestore.instance
          .collection('race_track_register')
          .where('email', isEqualTo: email.text)
          .where('password', isEqualTo: pass.text)
          .get();
        
      if (raceSnapshot.docs.isNotEmpty) {
    var raceTrackData = raceSnapshot.docs[0].data() as Map<String, dynamic>;
    
    if (raceTrackData != null && raceTrackData['status'] == 1) {
      var userid = raceSnapshot.docs[0].id;
      var image_url = raceTrackData['image_url'];
      var username = raceTrackData['name'];

      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString('uid', userid);
      sp.setString('name', username);
      sp.setString('image_url',image_url);

      Fluttertoast.showToast(msg: 'Login Successful as Race Track');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return RaceTrackNavigation();
      }));
    } else {
      Fluttertoast.showToast(msg: 'Race Track login is pending approval from admin');
    }
  } else {
    showLoginFailedDialog();
  }
}


    if (widget.type == 'rental') {
      final QuerySnapshot rentSnapshot = await FirebaseFirestore.instance
          .collection('rentalregister')
          .where('email', isEqualTo: email.text)
          .where('password', isEqualTo: pass.text)
          .get();

      if (rentSnapshot.docs.isNotEmpty) {
            var rentalData = rentSnapshot.docs[0].data() as Map<String, dynamic>;
              if (rentalData != null && rentalData['status'] == 1) {


        var userid = rentSnapshot.docs[0].id;
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setString('uid', userid);

        Fluttertoast.showToast(msg: 'Login Successful as Rental');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return RentNavigationbar();
        }));
      }
       else {
      Fluttertoast.showToast(msg: 'Race Track login is pending approval from admin');
    }
      }
       else {
        showLoginFailedDialog();
      }
    }

    if (widget.type == 'community') {
      final QuerySnapshot commSnapshot = await FirebaseFirestore.instance
          .collection('community_register')
          .where('email', isEqualTo: email.text)
          .where('password', isEqualTo: pass.text)
          .get();

      if (commSnapshot.docs.isNotEmpty) {
                    var coomunityData = commSnapshot.docs[0].data() as Map<String, dynamic>;
                                  if (coomunityData != null && coomunityData['status'] == 1) {


        var userid = commSnapshot.docs[0].id;
          var image_url = commSnapshot.docs[0]['image_url'];
            var username = commSnapshot.docs[0]['name'];
            var email =commSnapshot.docs[0]['email'];

        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setString('uid', userid);
          sp.setString('name', username);
          sp.setString('email', email);
            sp.setString('image_url',image_url);



        Fluttertoast.showToast(msg: 'Login Successful as Community');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return Navigation();
        }));
      }
       else {
      Fluttertoast.showToast(msg: 'Race Track login is pending approval from admin');
    }
      }
       else {
        showLoginFailedDialog();
      }
    }
  }

  void showLoginFailedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login Failed'),
        content: Text('Invalid username or password. Please try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: fkey,
            child: Container(
              width: 400,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('images/logo1.png'),
                    SizedBox(height: 20),
                    Text('Enter Email'),
                    TextFormField(
                      controller: email,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Email',
                        fillColor: Color.fromARGB(111, 247, 73, 73),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text('Enter Password'),
                    TextFormField(
                      controller: pass,
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Password',
                        fillColor: Color.fromARGB(111, 247, 73, 73),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
  
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    InkWell(
      onTap: () {
        // Check the type and navigate accordingly
        if (widget.type == "user") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ForgotUser()),
          );
        } else if (widget.type == "race track") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ForgotRacetrack()),
          );
        } else if (widget.type == "rental") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ForgotRental()),
          );
        } else if (widget.type == "community") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ForgotCommunity()),
          );
        }
      },
      child: Text(
        "forgot password?",
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: Color.fromARGB(255, 20, 97, 160),
        ),
      ),
    ),
  ],
),

                        
                       ElevatedButton(
                        onPressed: () async {
                          if (fkey.currentState!.validate()) {
                            print('-------------');
                            await checkData();
                            //  Navigator.push(context, MaterialPageRoute(builder:(context) {
                            //       return Navigationbar();
                            //     },));
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB(111, 247, 73, 73))),
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                              color: Color.fromARGB(255, 245, 244, 245)),
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    TextButton(
                      onPressed: () {
                        if (widget.type == 'user') {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return UserRgistration();
                            },
                          ));
                        } else if (widget.type == 'race track') {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return raceRegistration();
                            },
                          ));
                        } else if (widget.type == 'rental') {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return RentalRegister();
                            },
                          ));
                        } else if (widget.type == 'community') {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return CommunityRegister();
                            },
                          ));
                        } 
                      
                      },
                      child: Text('Not Registered yet? Sign up'),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}