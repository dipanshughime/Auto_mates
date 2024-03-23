import 'package:automates/Screens/ConformReq.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OtherOngoingReq extends StatefulWidget {
  const OtherOngoingReq({Key? key});

  @override
  State<OtherOngoingReq> createState() => _OtherOngoingReqState();
}

class _OtherOngoingReqState extends State<OtherOngoingReq> {
  late String currentUserID = '';

  @override
  void initState() {
    super.initState();
    initializeCurrentUser();
  }

  void initializeCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserID = user.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Other Ongoing Requests'),
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            return StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('requests').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                List<DocumentSnapshot> filteredRequests =
                    snapshot.data!.docs.where((requestDoc) {
                  Map<String, dynamic> requestData =
                      requestDoc.data() as Map<String, dynamic>;
                  return requestData['userId'] != currentUserID &&
                      requestData['seats'] != 3;
                }).toList();

                return ListView(
                  children: filteredRequests.map((requestDoc) {
                    Map<String, dynamic> requestData =
                        requestDoc.data() as Map<String, dynamic>;
                    return Card(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ConformReqPg(requestId: requestDoc.id),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: Icon(Icons.location_on),
                          title: Text(requestData['destinationLocation']),
                          subtitle: Text(requestData['sourceLocation']),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            );
          } else {
            return Center(child: Text('User not logged in'));
          }
        },
      ),
    );
  }
}
