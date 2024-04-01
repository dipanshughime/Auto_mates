import 'package:automates/Screens/street_view.dart';
import 'package:automates/utils/qrScanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  var name = "";
  late List<String> users = [];
  late int seats = 0;
  late String currentUserID = "";
  bool showInitialButton = true;
  @override
  void initState() {
    super.initState();
    initializeCurrentUser();
    retrieveRequestData();
    fetchUsersAndSeats();
  }

  void initializeCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserID = user.uid;
      });
    }
  }

  Future<void> _loadUserName() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserID)
          .get();
      if (userSnapshot.exists) {
        // Assuming 'name' is a field in the user document
        setState(() {
          name = userSnapshot['username'];
        });
      }
    } catch (e) {
      print('Error loading user name: $e');
    }
  }

  void addUserAndIncrementSeats(String userId) {
    users.add(userId);
    setState(() {
      seats = seats + 1;
    });

    FirebaseFirestore.instance
        .collection('requests')
        .doc(widget.requestId)
        .update({
      'users': users,
      'seats': seats,
    }).then((value) {
      fetchUsersAndSeats();
    });
  }

  void fetchUsersAndSeats() {
    FirebaseFirestore.instance
        .collection('requests')
        .doc(widget.requestId)
        .get()
        .then((doc) {
      if (doc.exists) {
        List<String> fetchedUsers =
            List<String>.from(doc.data()?['users'] ?? []);
        if (fetchedUsers.contains(currentUserID)) {
          setState(() {
            showInitialButton = false;
          });
        }
        setState(() {
          users = fetchedUsers;
          seats = doc.data()?['seats'] ?? 0;
        });
      }
    });
  }

  void openQRScannerCamera() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => QRScannerPage(requestId: widget.requestId)),
    );
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
                    DropdownButton<String>(
                      value: null,
                      items: users
                          .map((user) =>
                              DropdownMenuItem(value: user, child: Text(user)))
                          .toList(),
                      onChanged: (String? selectedUser) {
                        // Handle dropdown selection if needed
                      },
                    ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     // Add current user ID to the array and increment seats count
                    //     addUserAndIncrementSeats(currentUserID);
                    //   },
                    //   child: Text('Add Current User and Increment Seats'),
                    // ),

                    showInitialButton
                        ? ElevatedButton(
                            onPressed: () {
                              addUserAndIncrementSeats(currentUserID);
                              setState(() {
                                showInitialButton = false;
                              });
                            },
                            child: Text('Accept Ride request'),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  openQRScannerCamera();
                                },
                                child: Text('QR Scanner'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            StreetViewPanoramaInitDemo(
                                              place: "VESIT",
                                              lat: 19.0501817,
                                              long: 72.8884698,
                                            )),
                                  );
                                  // Handle location button click
                                },
                                child: Text('Location'),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
      ),
    );
  }
}
