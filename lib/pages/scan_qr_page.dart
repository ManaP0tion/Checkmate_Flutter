import 'package:flutter/material.dart';
import 'package:pp/customWidgets/custom_alert_dialog_confirm.dart';
import 'package:pp/themes/styles.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:pp/pages/home_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QrScanPage extends StatefulWidget {
  const QrScanPage({super.key});

  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrText; // qr 스캔 결과

  void _onQRViewCreated(QRViewController controller){
    this.controller = controller;
    controller.scannedDataStream.listen((scanData){
      setState(() {
        qrText = scanData.code;
        controller.pauseCamera();
        //
        showDialog(context: context, builder: (BuildContext context) => CustomAlertDialogConfirm());
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage())
        );
      });
    });
  }

  @override
  void dispose(){
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('출석QR 스캔', style: mediumBlack18)),
      body: Stack(
        children: [
          Positioned.fill(
            child: QRView(key: qrKey, onQRViewCreated: _onQRViewCreated)
          )
        ]
      )
    );
  }
}
