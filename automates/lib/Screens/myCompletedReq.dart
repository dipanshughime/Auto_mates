import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyCompleteReq extends StatefulWidget {
  const MyCompleteReq({super.key});

  @override
  State<MyCompleteReq> createState() => _MyCompleteReqState();
}

class _MyCompleteReqState extends State<MyCompleteReq> {
  @override
  late String currentUserID =
      ''; // Declare currentUserID as late and initialize it

  @override
  void initState() {
    super.initState();
    initializeCurrentUser(); // Call a method to initialize currentUserID
  }

  void initializeCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserID = user.uid;
      });
    } else {
      // Handle the case where user is null
      // currentUserID = ''; // You can choose to set a default value or handle the error differently
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Completed Requests'),
      ),
      body: FutureBuilder(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            String currentUserID = FirebaseAuth
                .instance.currentUser!.uid; // Get the current user's ID

            return StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('requests').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                List<DocumentSnapshot> filteredRequests =
                    snapshot.data!.docs.where((requestDoc) {
                  Map<String, dynamic> requestData =
                      requestDoc.data() as Map<String, dynamic>;
                  return requestData['userId'] == currentUserID &&
                      requestData['seats'] == 3;
                }).toList();

                return ListView(
                  children: filteredRequests.map((requestDoc) {
                    Map<String, dynamic> requestData =
                        requestDoc.data() as Map<String, dynamic>;
                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.location_on),
                        title: Text(requestData['destinationLocation']),
                        subtitle: Text(requestData['sourceLocation']),
                      ),
                    );
                  }).toList(),
                );
              },
            );
          } else {
            return Center(
                child: Text(
                    'User not logged in')); // Handle case where user is not logged in
          }
        },
      ),
    );
  }
}
