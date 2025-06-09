import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pp/customWidgets/custom_alert_dialog_confirm.dart';
import 'package:pp/pages/home_page.dart';
import 'package:pp/themes/colors.dart';
import 'package:pp/themes/styles.dart';
import 'package:pp/models/lecture.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:pp/themes/strings.dart';
import 'package:shimmer/shimmer.dart';

 // 192.168.137.140
class ShowQrPage extends StatefulWidget {
  final Lecture lecture;
  final int week;
  ShowQrPage({super.key, required this.lecture, required this.week});

  @override
  State<ShowQrPage> createState() => _ShowQrPageState();
}

class _ShowQrPageState extends State<ShowQrPage> {
  String? _token;
  Uint8List? qrImage;
  int? sessionId;


  @override
  void initState(){
    super.initState();
    startSession();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    return token;
  }

  Future<void> startSession() async {
    final token = await getToken();
    if(token == null){
      print('no token');
      return;
    }
    setState(() {
      _token = token;
    });

    final response = await http.post(
      Uri.parse('http://${ipHome}/api/attendance/sessions/start/'),
      headers: {
        'Authorization' : 'Bearer $_token',
        'Content-Type' : 'application/json'
      },
      body: jsonEncode({
        'lecture' : widget.lecture.id,
        'week' : widget.week
      })
    );

    if(response.statusCode == 201){
      print('세션 시작 성공');

      final data = jsonDecode(response.body);
      sessionId = data['id'];

    } else if (response.statusCode == 207){
      print('라즈베리파이 연결 실패');
    } else {
      print('세션 연결 실패');
    }
  }

  void endSession() async {
    final response = await http.post(
      Uri.parse('http://${ipHome}/api/attendance/sessions/end/'),
      headers: {
        'Authorization' : 'Bearer $_token',
        'Content-Type' : 'application/json'
      },
      body: jsonEncode({
        'session_id' : sessionId
      })
    );
    if(response.statusCode == 200) {
      await showDialog(context: context, builder: (BuildContext context) => CustomAlertDialogConfirm(title: session_end_title, subtitle: session_end_subtitle));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      print('세션 종료 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        surfaceTintColor: Colors.transparent,
        title: Text('출석체크 QR', style: mediumBlack18),
        titleSpacing: 0,
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200.w,
                height: 200.h,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: 200.w,
                    height: 200.h,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0), color: Colors.grey.shade300),
                  )
                ),
              ),
              SizedBox(height: 12.h),
              Text("${widget.lecture.name} ${widget.week}주차", style: boldBlack16)
            ],
          )
        )
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 24.h),
        child: SizedBox(
          height: 41.h,
          child: ElevatedButton(
            onPressed: endSession,
            style: btnBlueRound15,
            child: Text("종료하기", style: mediumWhite16),
          ),
        ),
      ),
    );
  }
}
