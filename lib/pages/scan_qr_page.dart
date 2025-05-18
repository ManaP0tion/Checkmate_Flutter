import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QrScanPage extends StatefulWidget {
  const QrScanPage({super.key});

  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrText;
  bool _isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('qr Test')),
      body: Stack(
        children: [
          Positioned.fill(
            child: QRView(key: qrKey, onQRViewCreated: _onQRViewCreated)
          ),
          if(_isScanned)
            Center(
              child: Text(qrText ?? '')
            )
        ]
      )
    );
  }

  void _onQRViewCreated(QRViewController controller){
    this.controller = controller;
    controller.scannedDataStream.listen((scanData){
      setState(() {
        qrText = scanData.code;
      });
    });
  }

  @override
  void dispose(){
    controller?.dispose();
    super.dispose();
  }
}
