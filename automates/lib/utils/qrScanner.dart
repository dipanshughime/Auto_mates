import 'package:automates/Screens/ConformReq.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerPage extends StatefulWidget {
  final String requestId;
  const QRScannerPage({Key? key, required this.requestId}) : super(key: key);

  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

// class _QRScannerPageState extends State<QRScannerPage> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   late QRViewController controller;
//   String scannedValue = '';

//  Future<void> scanQR() async {
//     String barcodeScanRes;
//     try {

//       if (scannedValue == widget.requestId) {
//         //if scanner matches
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) =>
//                   ScanPackageSender(barcodeScanRes: barcodeScanRes)),
//         );
//       } else {
//         //if scanner doesn't match
//         Navigator.pop(context);
//       }
//     } on PlatformException {
//       barcodeScanRes = 'Failed to get platform version.';
//     }

//     // Show SnackBar

//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('QR Scanner'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Container(
//             height: MediaQuery.of(context).size.height *
//                 0.5, // Set the height to 50% of the screen height
//             child: QRView(
//               overlay: QrScannerOverlayShape(
//                 borderColor: Colors.white,
//               ),
//               key: qrKey,
//               onQRViewCreated: _onQRViewCreated,
//             ),
//           ),
//           Text('Scanned Value: $scannedValue'),
//         ],
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         scannedValue = scanData.code!;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  String scannedValue = '';

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      if (scannedValue == widget.requestId) {
        // If scanner matches, show confirmation dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('QR Code Scanned Successfully'),
              content: Text('Confirmation message here'),
            );
          },
        );

        // Delay for 5 seconds before navigating to home page
        await Future.delayed(Duration(seconds: 5));

        // Navigate to home page
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConformReqPg(
                    requestId: widget.requestId,
                  )),
        );
      } else {
        // If scanner doesn't match, navigate back
        Navigator.pop(context);
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: QRView(
              overlay: QrScannerOverlayShape(
                borderColor: Colors.white,
              ),
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Text('Scanned Value: $scannedValue'),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        scannedValue = scanData.code!;
        scanQR(); // Call scanQR function when QR code is scanned
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
