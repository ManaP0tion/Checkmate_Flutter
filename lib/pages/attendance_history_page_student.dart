import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pp/themes/styles.dart';
import 'package:pp/themes/colors.dart';
import 'package:pp/models/lecture.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pp/themes/strings.dart';

// 주차별 출석/결석 표시

class AttendanceHistoryStudentPage extends StatefulWidget {
  final LectureStudent lecture;
  AttendanceHistoryStudentPage({super.key, required this.lecture});

  @override
  State<AttendanceHistoryStudentPage> createState() => _AttendanceHistoryStudentPageState();
}

class _AttendanceHistoryStudentPageState extends State<AttendanceHistoryStudentPage> {
  List<Map<String, dynamic>> _attendance = []; // 학생 정보 리스트
  Map<int, String> _attendanceMap = {};
  String? _token;

  @override
  void initState() {
    super.initState();
    fetchAttendanceData(); // 예시용 더미 데이터 호출
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return token;
  }

  void fetchAttendanceData() async {
    final token = await getToken();
    if(token == null){
      print('no token');
      return;
    }
    setState(() {
      _token = token;
    });

    const String baseUrl = 'http://${ipHome}/api/attendance/attendance/my-records/';
    final uri = Uri.parse(baseUrl).replace(queryParameters: {'lecture_code' : widget.lecture.lectureCode});
    final response = await http.get(
      uri,
      headers: {
        'Authorization' : 'Bearer ${_token}',
        'Content-Type' : 'application/json'
      }
    );
    if(response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> records = data['records'];

      setState(() {
        _attendance = records.map((record) {
          return {
            'week' : record['week'],
            'status' : convertStatus(record['status'])
          };
        }).toList();

        for (var attendance in _attendance) {
          _attendanceMap[attendance['week']] = attendance['status'];
        }
      });
    } else {
      print('실패~~~');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('출결이력',  style: mediumBlack16),
            Text('${widget.lecture.name}', style: mediumGrey13)
          ],
        ),
        titleSpacing: 0,
      ),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: DataTable(
            headingTextStyle: boldBlack16,
            dataTextStyle: mediumBlack16,
            columns: const [
              DataColumn(label: Text('주차')),
              DataColumn(label: Text('상태'))
            ],
            rows: _attendanceMap.entries.map((entry) {
              return DataRow(
                cells: [
                  DataCell(Text('${entry.key} 주차')),
                  DataCell(Text(entry.value))
                ]
              );
            }).toList()
          )
        ),
      )
    );
  }
}

String convertStatus(String status) {
  switch (status) {
    case 'present' : return '출석';
    case 'late' : return '지각';
    case 'absent' : return '결석';
    default: return '결석';
  }
}


