import 'package:flutter/material.dart';

class TermsAndConditions extends StatefulWidget {
  
   TermsAndConditions({super.key});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
   bool _agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Community Terms and Conditions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              // Add your terms and conditions text specific to Auto Show Community here
              'By joining the Auto Show Community, you agree to abide by the following terms and conditions:\n\n1. Respect fellow members and their opinions.\n2. Do not engage in any form of discrimination or harassment.\n3. Follow all community guidelines and rules.\n4. Any misuse or abuse of the platform may result in suspension or termination of your account.\n\nPlease read these terms and conditions carefully. By continuing, you acknowledge that you have read, understood, and agree to abide by them.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: _agreeToTerms,
                  onChanged: (value) {
                    setState(() {
                      _agreeToTerms = value!;
                    });
                  },
                ),
                Text('I agree to the Terms and Conditions'),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_agreeToTerms) {
                    // If user agrees to terms, navigate to next screen or perform any action
                    
                  } else {
                    // Show a message indicating that the user must agree to terms
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please agree to the Terms and Conditions'),
                      ),
                    );
                  }
                },
                child: Text('SUBMIT'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Next Page'),
      ),
      body: Center(
        child: Text('Welcome to the Next Page!'),
      ),
    );
  }
}