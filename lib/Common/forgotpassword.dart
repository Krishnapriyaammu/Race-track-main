import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ForgotPasword extends StatefulWidget {
  const ForgotPasword({super.key});

  @override
  State<ForgotPasword> createState() => _ForgotPaswordState();
}

class _ForgotPaswordState extends State<ForgotPasword> {
   final _formKey = GlobalKey<FormState>();
  var email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: email,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter an email';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? true) {
                      bool emailExists = await checkEmailExists(email.text);
                      if (emailExists) {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (ctx) =>
                        //         StoreResetPassword(email: email.text),
                        //   ),
                        // );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Email does not exist',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: Text('Next'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF67B0DA),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      // Query Firestore collection "user_register" for the provided email
      var querySnapshot = await FirebaseFirestore.instance
          .collection('user_register')
          .where('email', isEqualTo: email)
          .get();
      // Check if any documents match the provided email
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking email: $e");
      return false;
    }
  }
}