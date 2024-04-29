import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginrace/Common/Login.dart';

class ForgotRental extends StatefulWidget {
  const ForgotRental({super.key});

  @override
  State<ForgotRental> createState() => _ForgotRentalState();
}

class _ForgotRentalState extends State<ForgotRental> {
   var email = TextEditingController();
  var password = TextEditingController();
  var cpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Reset Password',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 45, right: 20),
            child: TextFormField(
              controller: email,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your email';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 45, right: 20),
            child: TextFormField(
              controller: password,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter new password';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 45, right: 20),
            child: TextFormField(
              controller: cpassword,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter password';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Confirm Password',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: ElevatedButton(
              onPressed: () async {
                if (cpassword.text == password.text) {
                  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                      .collection('RentalRegister')
                      .where('email', isEqualTo: email.text)
                      .get();

                  if (querySnapshot.docs.isNotEmpty) {
                    DocumentReference userDocRef =
                        querySnapshot.docs.first.reference;
                    await userDocRef.update({
                      'password': password.text,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Password updated",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    );

                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login(type: 'rental'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "No user found with the provided email.",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Passwords don't match",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }
              },
              child: Text('Done'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF67B0DA),
              ),
            ),
          ),
        ],
      ),
    );
  }
}