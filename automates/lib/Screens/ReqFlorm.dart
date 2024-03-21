import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestForm extends StatefulWidget {
  @override
  _RequestFormState createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final _formKey = GlobalKey<FormState>();
  String _sourceLocation = '';
  String _destinationLocation = '';
  DateTime _travelDateTime = DateTime.now();
  String _selectedTransportOption = 'Auto';
  var seat = 1;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _travelDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _travelDateTime)
      setState(() {
        _travelDateTime = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_travelDateTime),
    );
    if (picked != null)
      setState(() {
        _travelDateTime = DateTime(
          _travelDateTime.year,
          _travelDateTime.month,
          _travelDateTime.day,
          picked.hour,
          picked.minute,
        );
      });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Get current user ID (You need to implement this part)
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      String userId = user!.uid; // Replace with actual user ID retrieval

      // Save form data to Firestore under user's 'requests' subcollection
      await FirebaseFirestore.instance.collection('requests').add({
        'userId': userId,
        'sourceLocation': _sourceLocation,
        'destinationLocation': _destinationLocation,
        'travelDateTime': _travelDateTime,
        'transportOption': _selectedTransportOption,
        'seats': seat,
        "status": ''
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('requests')
          .add({
        'userId': userId,
        'sourceLocation': _sourceLocation,
        'destinationLocation': _destinationLocation,
        'travelDateTime': _travelDateTime,
        'transportOption': _selectedTransportOption,
        'seats': seat,
        "status": ''
      });

      // Clear form fields after submission
      setState(() {
        _sourceLocation = '';
        _destinationLocation = '';
        _travelDateTime = DateTime.now();
        _selectedTransportOption = 'Auto';
      });

      // Show a success message or navigate to a new screen
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Form submitted successfully!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Request Form'),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Source Location'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter source location';
                  }
                  return null;
                },
                onSaved: (value) {
                  _sourceLocation = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Destination Location'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter destination location';
                  }
                  return null;
                },
                onSaved: (value) {
                  _destinationLocation = value!;
                },
              ),
              ListTile(
                title: Text('Travel Date: ${_travelDateTime.toLocal()}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () {
                  _selectDate(context);
                },
              ),
              ListTile(
                title: Text(
                    'Travel Time: ${_travelDateTime.toLocal().hour}:${_travelDateTime.toLocal().minute}'),
                trailing: Icon(Icons.access_time),
                onTap: () {
                  _selectTime(context);
                },
              ),
              DropdownButtonFormField(
                value: _selectedTransportOption,
                items: ['Auto', 'Cab', 'Taxi']
                    .map((transport) => DropdownMenuItem(
                          value: transport,
                          child: Text(transport),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTransportOption = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Transport Option'),
              ),
              FloatingActionButton(
                onPressed: () => _submitForm(),
                tooltip: 'Submit',
                child: Icon(Icons.check),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
