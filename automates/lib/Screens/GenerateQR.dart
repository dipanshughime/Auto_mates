import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeGenerator extends StatefulWidget {
  final String orderId;

  const QRCodeGenerator({Key? key, required this.orderId}) : super(key: key);

  @override
  _QRCodeGeneratorState createState() => _QRCodeGeneratorState();
}

class _QRCodeGeneratorState extends State<QRCodeGenerator> {
  String? senderId;

  @override
  void initState() {
    super.initState();
    _getSenderId();
  }

  Future<void> _getSenderId() async {
    DateTime timestamp = DateTime.now();
  }

  @override
  void dispose() {
    DateTime timestamp = DateTime.now();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: widget.orderId,
              version: QrVersions.auto,
              size: 320,
              gapless: false,
            ),
            const SizedBox(height: 20.0) // Display the encoded data
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: QRCodeGenerator(orderId: 'Your QR Code Data'),
    ),
  );
}
