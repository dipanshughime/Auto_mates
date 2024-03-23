import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ConformReqPg extends StatefulWidget {
  final String requestId;

  const ConformReqPg({Key? key, required this.requestId}) : super(key: key);

  @override
  State<ConformReqPg> createState() => _ConformReqPgState();
}

class _ConformReqPgState extends State<ConformReqPg> {
  Map<String, dynamic> requestData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    retrieveRequestData();
  }

  void retrieveRequestData() {
    FirebaseFirestore.instance
        .collection('requests')
        .doc(widget.requestId)
        .get()
        .then((doc) {
      if (doc.exists) {
        setState(() {
          requestData = doc.data() as Map<String, dynamic>;
          isLoading = false;
        });
      } else {
        setState(() {
          requestData = {
            'destinationLocation': 'Request data not found',
            'sourceLocation': '',
            'seats': '',
            'transportOption': '',
            'travelDateTime': '',
            'userId': '',
          };
          isLoading = false;
        });
      }
    }).catchError((error) {
      setState(() {
        requestData = {
          'destinationLocation': 'Error retrieving data',
          'sourceLocation': '',
          'seats': '',
          'transportOption': '',
          'travelDateTime': '',
          'userId': '',
        };
        isLoading = false;
      });
    });
  }

  String formatDateTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  String formatTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Request Page'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text('Destination Location'),
                      subtitle:
                          Text(requestData['destinationLocation'].toString()),
                    ),
                    ListTile(
                      title: Text('Source Location'),
                      subtitle: Text(requestData['sourceLocation'].toString()),
                    ),
                    ListTile(
                      title: Text('Seats filled'),
                      subtitle: Text("${requestData['seats'].toString()}/3"),
                    ),
                    ListTile(
                      title: Text('Transport Option'),
                      subtitle: Text(requestData['transportOption'].toString()),
                    ),
                    ListTile(
                      title: Text('Travel Date Time'),
                      subtitle:
                          Text(formatDateTime(requestData['travelDateTime'])),
                    ),
                    ListTile(
                      title: Text('User ID'),
                      subtitle: Text(requestData['userId'].toString()),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
