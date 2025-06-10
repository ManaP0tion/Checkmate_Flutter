import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pp/pages/scan_qr_page.dart';
import 'package:pp/themes/colors.dart';
import 'package:pp/themes/styles.dart';
import 'package:lottie/lottie.dart';
import 'package:pp/models/lecture.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:pp/load_user_data.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pp/themes/strings.dart';

/*class ScanBlePage extends StatefulWidget {
  //final LectureStudent lecture;
  final String lectureCode;
  final int week;
  ScanBlePage({super.key, required this.lectureCode, required this.week});

  @override
  State<ScanBlePage> createState() => _ScanBlePageState();
}

class _ScanBlePageState extends State<ScanBlePage> {
  String? _token;
  String _sessionIdBle = '';
  Map<String, dynamic>? _userData;
  int? _studentId;

  @override
  void initState(){
    super.initState();
    initTokenAndCheckBle();
  }
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> requestBlePermissions() async {
    print('[BLE] 권한 요청 시작');
    var scan = await Permission.bluetoothScan.request();
    var connect = await Permission.bluetoothConnect.request();
    var location = await Permission.location.request();

    print('[BLE] bluetoothScan: ${scan.isGranted}');
    print('[BLE] bluetoothConnect: ${connect.isGranted}');
    print('[BLE] location: ${location.isGranted}');

    if (scan.isGranted && connect.isGranted && location.isGranted) {
      print('[BLE] ✅ 모든 BLE 권한 허용됨');
    } else {
      print('[BLE] ❌ 일부 권한 거부됨');
      // 사용자에게 알림 또는 재요청 가능
    }
  }

  Future<void> initTokenAndCheckBle() async {
    print('[Init] 토큰 및 BLE 초기화 시작');
    final token = await getToken();
    if (token == null) {
      print('[Init] ❌ 토큰 없음');
      return;
    }

    print('[Init] ✅ 토큰 획득: $token');

    _userData = await fetchUserInfo();
    print('[Init] 사용자 정보 로드됨: $_userData');

    _studentId = _userData?['id'];
    print('[Init] 학생 ID: $_studentId');

    _token = token;

    await requestBlePermissions();  // 로그 찍기 위해 주석 해제

    await startScan();
  }

  Map<String, String>? _parseSessionId(String name) {
    print('[Parser] 이름 파싱 시도: $name');
    final parts = name.split('_');
    if (parts.length == 2) {
      print('[Parser] ✅ 파싱 성공: $parts');
      return {
        'lectureCode': parts[0],
        'week': parts[1]
      };
    }
    print('[Parser] ❌ 파싱 실패');
    return null;
  }

  Future<void> startScan() async {
    print('[BLE] 스캔 시작 요청');

    try{
    await FlutterBluePlus.stopScan();
    print('[BLE] 기존 스캔 중지');

    FlutterBluePlus.startScan(timeout: Duration(seconds: 10));
    print('[BLE] 새 스캔 시작됨');

    FlutterBluePlus.scanResults.listen((results) async {
      print('[BLE] 스캔 결과 수신: ${results.length}개 장치');

      for (ScanResult r in results) {
        final name = r.advertisementData.localName;
        print('[BLE] 광고 이름: $name');

        if (name != null) {
          final parsed = _parseSessionId(name);

          if (parsed != null) {
            final scannedLectureCode = parsed['lectureCode'];
            final scannedWeek = int.tryParse(parsed['week'] ?? '');

            print('[BLE] 스캔 코드: $scannedLectureCode / 주차: $scannedWeek');

            if (scannedLectureCode == widget.lectureCode &&
                scannedWeek == widget.week) {
              print('[BLE] ✅ 신호 일치');

              setState(() {
                _sessionIdBle = name;
              });

      }

              await submitBle();  // 로그 찍기 위해 await 사용
              break;
            } else {
              print('[BLE] ❌ 불일치 - 강의코드: $scannedLectureCode / ${widget.lectureCode}, 주차: $scannedWeek / ${widget.week}');
            }
          }
        }
      };
    });
  }

  Future<void> submitBle() async {
    print('[Submit] BLE 출석 제출 시작');
    final payload = {
      'student_id': _studentId,
      'lecture_code': widget.lectureCode,
      'session_id': _sessionIdBle
    };
    print('[Submit] 전송 데이터: $payload');

    final response = await http.post(
      Uri.parse('http://172.30.1.30:8000/api/attendance/attendance/ble'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(payload),
    );

    print('[Submit] 응답 코드: ${response.statusCode}');
    print('[Submit] 응답 본문: ${response.body}');

    if (response.statusCode == 200) {
      print('[Submit] ✅ 출석 성공');
      // TODO: 페이지 전환 등
    } else if (response.statusCode == 404) {
      print('[Submit] ❌ 출석 실패 - 404');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ble 인증 실패. 학생 또는 세션을 찾을 수 없습니다.', style: mediumWhite14))
      );
      Navigator.pop(context);
    } else if (response.statusCode == 403) {
      print('[Submit] ❌ 출석 실패 - 403');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ble 인증 실패. 수강하지 않는 학생입니다.', style: mediumWhite14))
      );
      Navigator.pop(context);
    } else {
      print('[Submit] ❌ 출석 실패 - 기타 에러');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        surfaceTintColor: Colors.transparent,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('출석하기', style: mediumBlack16),
            Text(' ${widget.week}주차', style: mediumGrey13)
          ]
        ),
        titleSpacing: 0,
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/lottie_ble.json'),
              SizedBox(height: 6.h),
              Text('잠시만 기다려주세요', style: boldBlack16)
            ]
          )
        )
      )
    );
  }
}*/

// ... (import는 동일)

class ScanBlePage extends StatefulWidget {
  final String? lectureCode;
  final LectureStudent lecture;
  final int week;

  const ScanBlePage({super.key, this.lectureCode, required this.lecture, required this.week});

  @override
  State<ScanBlePage> createState() => _ScanBlePageState();
}

class _ScanBlePageState extends State<ScanBlePage> {
  String? _token;
  String? _sessionIdBle;
  int? _studentId;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _initialize();
    print('으악1');
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan(); // BLE 스캔 중지
    super.dispose();
  }

  Future<void> _initialize() async {
    _token = await getToken();
    print('으악악');
    if (_token == null) return;
    print('으악악악');

    final userData = await fetchUserInfo();
    print('이거 나오면 fetchㅕㄴㄷ갸ㅜ래 wjdtkd');
    _studentId = userData?['id'];
    print('으악2');
    await requestBlePermissions();
    print('으악3');
    await startScan();
    print('으악4');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> requestBlePermissions() async {
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.location.request();
  }

  Map<String, String>? _parseSessionId(String name) {
    final parts = name.split('_');
    if (parts.length == 2) {
      return {'lectureCode': parts[0], 'week': parts[1]};
    }
    return null;
  }

  Future<void> startScan() async {
    try {
      await FlutterBluePlus.stopScan();
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 1000));
      print('스캔 중~~~~');
      print('${widget.lecture.lectureCode}  ${widget.week}');

      FlutterBluePlus.scanResults.listen((results) async {
        if (_submitted) return;


        for (ScanResult r in results) {
          final name = r.advertisementData.localName;
          if (name == null) continue;
          print('${name} 이것이 이름!!!!!!!!');
          final parsed = _parseSessionId(name);
          if (parsed == null) continue;

          print('파싱 성공');
          final scannedLectureCode = parsed['lectureCode'];
          final scannedWeek = int.tryParse(parsed['week'] ?? '');
          print('저장성공!');

          if (scannedLectureCode == widget.lecture.lectureCode && scannedWeek == widget.week) {
            print('찾았다!!!!');
            print(_sessionIdBle);
            print(_studentId);
            _sessionIdBle = name;
            _submitted = true;
            await submitBle();
            break;
          }
        }
      });
    } catch (e) {
      print('[BLE] 스캔 에러: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('스캔 실패 $e', style: mediumWhite14)),
      );
    }
  }

  Future<void> submitBle() async {
    if (_sessionIdBle == null || _studentId == null || _token == null) return;

    final payload = {
      'student_id': _studentId,
      'lecture_code': widget.lecture.lectureCode,
      'session_code': _sessionIdBle
    };

    final response = await http.post(
      Uri.parse('http://${ipHome}/api/attendance/attendance/ble/'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(payload),
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => QrScanPage(lecture: widget.lecture, week: widget.week, sessionIdBle: _sessionIdBle!)));
    } else {
      String errorMsg;
      if (response.statusCode == 404) {
        errorMsg = 'Ble 인증 실패. 학생 또는 세션을 찾을 수 없습니다.';
      } else if (response.statusCode == 403) {
        errorMsg = 'Ble 인증 실패. 수강하지 않는 학생입니다.';
      } else {
        errorMsg = 'Ble 인증 실패. 알 수 없는 오류';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg, style: mediumWhite14)),
      );
      //Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        surfaceTintColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('출석하기', style: mediumBlack16),
            Text('${widget.lecture.name} ${widget.week}주차', style: mediumGrey13),
          ],
        ),
        titleSpacing: 0,
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/lottie_ble.json'),
              SizedBox(height: 6.h),
              Text('Ble 신호를 찾고 있어요!', style: boldBlack18),
              Text('잠시만 기다려주세요', style: mediumBlack16),
            ],
          ),
        ),
      ),
    );
  }
}
