// import 'dart:io';

// import 'package:automates/Screens/main_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';

// class RegistrationScreen extends StatefulWidget {
//   const RegistrationScreen({Key? key}) : super(key: key);

//   @override
//   _RegistrationScreenState createState() => _RegistrationScreenState();
// }

// class _RegistrationScreenState extends State<RegistrationScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//   bool _isPasswordVisible = false;
//   bool _isConfirmPasswordVisible = false;
//   String? _errorMessage;

//   final picker = ImagePicker();
//   late File _image;
//   Future<void> _register() async {
//     final String username = _usernameController.text.trim();
//     final String email = _emailController.text.trim();
//     final String password = _passwordController.text;
//     final String confirmPassword = _confirmPasswordController.text;

//     // Check if the image is null
//     if (_image == null) {
//       setState(() {
//         _errorMessage = "Please select a profile image";
//       });
//       return;
//     }

//     if (password != confirmPassword) {
//       setState(() {
//         _errorMessage = "Passwords do not match";
//       });
//       return;
//     }

//     try {
//       final UserCredential userCredential = await _auth
//           .createUserWithEmailAndPassword(email: email, password: password);

//       final User? user = userCredential.user;

//       if (user != null) {
//         // Upload image to Firebase Storage
//         Reference storageReference = FirebaseStorage.instance
//             .ref()
//             .child('profile_images')
//             .child(user.uid + '.jpg');

//         await storageReference.putFile(_image!);

//         // Get the download URL of the image
//         String imageUrl = await storageReference.getDownloadURL();

//         // Store user data in Firestore
//         await _firestore.collection('users').doc(user.uid).set({
//           'username': username,
//           'email': email,
//           'profile_image': imageUrl,
//         });

//         Navigator.of(context).pushReplacement(MaterialPageRoute(
//           builder: (context) => MainScreen(),
//         ));
//       } else {
//         // Handle the case where user is null
//         setState(() {
//           _errorMessage = "User not found";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = e.toString();
//       });
//     }
//   }

//   Future<void> _getImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Registration'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             GestureDetector(
//               onTap: _getImage,
//               child: CircleAvatar(
//                 radius: 50,
//                 backgroundImage: _image != null
//                     ? FileImage(_image!)
//                     : AssetImage('assets/images/Splash_screen.jpg')
//                         as ImageProvider,
//                 backgroundColor: Colors.grey[200],
//                 child: Icon(
//                   Icons.camera_alt,
//                   size: 30,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             _buildRoundedTextField(
//               controller: _usernameController,
//               labelText: 'Username',
//             ),
//             SizedBox(height: 20),
//             _buildRoundedTextField(
//               controller: _emailController,
//               labelText: 'Email',
//             ),
//             SizedBox(height: 20),
//             _buildRoundedPasswordField(
//               controller: _passwordController,
//               labelText: 'Password',
//               isPasswordVisible: _isPasswordVisible,
//               onChanged: (value) {},
//             ),
//             SizedBox(height: 20),
//             _buildRoundedPasswordField(
//               controller: _confirmPasswordController,
//               labelText: 'Confirm Password',
//               isPasswordVisible: _isConfirmPasswordVisible,
//               onChanged: (value) {},
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _register,
//               child: Text('Register'),
//             ),
//             if (_errorMessage != null)
//               Text(
//                 _errorMessage!,
//                 style: TextStyle(color: Colors.red),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRoundedTextField({
//     required TextEditingController controller,
//     required String labelText,
//   }) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: labelText,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20.0),
//         ),
//       ),
//     );
//   }

//   Widget _buildRoundedPasswordField({
//     required TextEditingController controller,
//     required String labelText,
//     required bool isPasswordVisible,
//     required Function(String) onChanged,
//   }) {
//     return Stack(
//       alignment: Alignment.centerRight,
//       children: [
//         TextField(
//           controller: controller,
//           decoration: InputDecoration(
//             labelText: labelText,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(20.0),
//             ),
//           ),
//           obscureText: !isPasswordVisible,
//           onChanged: onChanged,
//         ),
//         IconButton(
//           onPressed: () {
//             setState(() {
//               if (labelText == 'Password') {
//                 _isPasswordVisible = !_isPasswordVisible;
//               } else {
//                 _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
//               }
//             });
//           },
//           icon: Icon(
//             isPasswordVisible ? Icons.visibility : Icons.visibility_off,
//           ),
//         ),
//       ],
//     );
//   }
// }

//------------->>>>>>>>>>

import 'package:automates/Screens/home.dart';
import 'package:automates/Screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _errorMessage;

  Future<void> _register() async {
    final String username = _usernameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;
    if (password != confirmPassword) {
      setState(() {
        _errorMessage = "Passwords do not match";
      });
      return;
    }

    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'email': email,
        });

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MainScreen(),
        ));
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildRoundedTextField(
              controller: _usernameController,
              labelText: 'Username',
            ),
            SizedBox(height: 20),
            _buildRoundedTextField(
              controller: _emailController,
              labelText: 'Email',
            ),
            SizedBox(height: 20),
            _buildRoundedPasswordField(
              controller: _passwordController,
              labelText: 'Password',
              isPasswordVisible: _isPasswordVisible,
              onChanged: (value) {},
            ),
            SizedBox(height: 20),
            _buildRoundedPasswordField(
              controller: _confirmPasswordController,
              labelText: 'Confirm Password',
              isPasswordVisible: _isConfirmPasswordVisible,
              onChanged: (value) {},
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text('Register'),
            ),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundedTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }

  Widget _buildRoundedPasswordField({
    required TextEditingController controller,
    required String labelText,
    required bool isPasswordVisible,
    required Function(String) onChanged,
  }) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          obscureText: !isPasswordVisible,
          onChanged: onChanged,
        ),
        IconButton(
          onPressed: () {
            setState(() {
              if (labelText == 'Password') {
                _isPasswordVisible = !_isPasswordVisible;
              } else {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              }
            });
          },
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ],
    );
  }
}
