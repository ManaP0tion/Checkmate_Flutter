import 'package:flutter/material.dart';
import 'package:pp/customWidgets/custom_alert_dialog_confirm.dart';
import 'package:pp/themes/styles.dart';
import 'package:pp/themes/colors.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:pp/pages/home_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pp/themes/strings.dart';
import 'package:pp/models/lecture.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class QrScanPage extends StatefulWidget {
  final LectureStudent lecture;
  final int week;
  final String sessionIdBle;
  QrScanPage({super.key, required this.lecture, required this.week, required this.sessionIdBle});

  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrText; // qr 스캔 결과
  String? _token;

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> initTokenAndQrScan() async {
    final token = await getToken();
    if(token == null) {
      print('no token');
      return;
    }
    setState(() {
      _token = token;
    });
    await submitQr();
  }

  void _onQRViewCreated(QRViewController controller){
    this.controller = controller;

    initTokenAndQrScan().then((_) {
      controller.scannedDataStream.listen((scanData) {
        setState(() {
          qrText = scanData.code;
          controller.pauseCamera();

          showDialog(
            context: context,
            builder: (BuildContext context) => CustomAlertDialogConfirm(
              title: attendance_dialog_title,
              subtitle: attendance_dialog_subtitle,
            ),
          );

          submitQr();
        });
      });
    });
  }

  Future<void> submitQr() async {
    final response = await http.post(
      Uri.parse('http://${ipHome}/api/attendance/attendance/qr/'),
      headers: {
        'Authorization' : 'Bearer ${_token}',
        'Content-Type' : 'application/json'
      },
      body: {
        'session_id' : widget.sessionIdBle
      }
    );

    if(response.statusCode == 200){
      print('qr 인증 완료!');
      submitAttendance();
    } else if (response.statusCode == 404) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content : Text('Qr 인증 실패. 세션을 찾을 수 없습니다.', style: mediumWhite14))
      );
      Navigator.pop(context);
    }
  }

  Future<void> submitAttendance() async {
    final response = await http.post(
      Uri.parse('http://${ipHome}/api/attendance/attendance/submit'),
      headers: {
        'Authorization' : 'Bearer ${_token}',
        'Content-Type' : 'application/json'
      },
      body: {
        'session_code' : widget.sessionIdBle,
        'status' : 0
      }
    );

    if(response.statusCode == 200) {
      await showDialog(context: context, builder: (BuildContext context) => CustomAlertDialogConfirm(title: attendance_dialog_title, subtitle: attendance_dialog_subtitle), barrierDismissible: false);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      print('실패');
    }
  }

  @override
  void dispose(){
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('출석QR 스캔', style: mediumBlack16),
            Text('${widget.lecture.name} ${widget.week}주차', style: mediumGrey13)
          ]
        ),
      ),
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
