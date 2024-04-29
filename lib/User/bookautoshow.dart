import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginrace/User/statusbookingautoshow.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookAutoShow extends StatefulWidget {
  String community_id;
  String category;
   BookAutoShow({super.key, required this. community_id, required this. category});

  @override
  State<BookAutoShow> createState() => _BookAutoShowState();
}

class _BookAutoShowState extends State<BookAutoShow> {
  String _name = '';
  String _email = '';
  String _phoneNumber = '';
  String _place = '';
  String _price = '';
  DateTime? _selectedDate;


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
Future<void> _fetchPrice() async {
  try {
    // Query Firestore to get the price for the selected category
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('category_price')
        .where('category', isEqualTo: widget.category)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // Extract the price from the first document in the snapshot
      String price = snapshot.docs[0].data()['price'].toString();
      
      // Update the state with the fetched price
      setState(() {
        _price = price;
      });
    } else {
      setState(() {
        _price = 'N/A';
      });
    }
  } catch (error) {
    print('Error fetching price: $error');
  }
}
@override
void initState() {
  super.initState();
  _fetchPrice();
}



  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Auto Show'), // Display the selected category in the app bar
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Selected Category: ${widget.category}'),

                // Display fetched price
                Text('Price: $_price'),

                // TextFormField for Name
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _name = value!;
                  },
                ),
                // TextFormField for Email
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _email = value!;
                  },
                ),
                // TextFormField for Phone Number
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _phoneNumber = value!;
                  },
                ),
                // TextFormField for Place
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Place',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your place';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _place = value!;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Select Date',
                        ),
                        readOnly: true,
                        controller: TextEditingController(
                          text: _selectedDate == null ? '' : _selectedDate.toString().substring(0, 10),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      icon: Icon(Icons.calendar_today),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          try {
                            SharedPreferences sp = await SharedPreferences.getInstance();
                            var userid = sp.getString('uid');

                            await FirebaseFirestore.instance.collection('auto_show_booking').add({
                              'name': _name,
                              'email': _email,
                              'phone_number': _phoneNumber,
                              'place': _place,
                              'date': _selectedDate,
                              'userid': userid,
                              'community_id': widget.community_id,
                              'category': widget.category,
                              'status': 0,
                            });

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Booking successful!'),
                              backgroundColor: Colors.green,
                            ));
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Error: $error'),
                              backgroundColor: Colors.red,
                            ));
                          }
                        }
                      },
                      child: Text('Submit'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AutoShowStatus(category: widget.category, price: _price,community_id:widget.community_id),
                          ),
                        );
                      },
                      child: Text('View Status'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }
}