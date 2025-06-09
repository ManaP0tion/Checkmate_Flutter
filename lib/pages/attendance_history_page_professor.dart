import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pp/themes/styles.dart';
import 'package:pp/themes/colors.dart';
import 'package:pp/models/lecture.dart';
import 'package:pp/load_user_data.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:pp/themes/strings.dart';

// 학생리스트, 수동출결, WeeklyAttendanceView, MyLectureListView

class AttendacneHistoryProfessorPage extends StatefulWidget {
  final int week;
  final Lecture lecture;
  AttendacneHistoryProfessorPage({super.key, required this.week, required this.lecture});

  @override
  State<AttendacneHistoryProfessorPage> createState() => _AttendacneHistoryProfessorPageState();
}

class _AttendacneHistoryProfessorPageState extends State<AttendacneHistoryProfessorPage> {
  List<Map<String, dynamic>> students = []; // 학생 정보 리스트
  Map<int, String> statusMap = {}; // student_id -> status
  Set<int> modifiedIds = {};
  String? _token;
  Map<int, String> idToUsername = {};

  //임시
  String _sessionId = "session_id";
  int _classId = 0;

  @override
  void initState() {
    super.initState();
    initData(); // 예시용 더미 데이터 호출
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> initData() async {
    final token = await getToken();
    if(token == null) {
      print('no token');
      return;
    }
    _token = token;

    await fetchStudentUsernames();
    await fetchStudentData();
  }

  Future<void> fetchStudentData() async {
    const String baseUrl = 'http://${ipHome}/api/attendance/weekly/';
    final Map<String, String> queryParameters = {
      'lecture_code' : widget.lecture.code!,
      'week' : widget.week.toString(),
    };
    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization' : 'Bearer $_token',
          'Content-Type' : 'application/json'
        }
      );

      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        final List<dynamic> records = data['records'];

        setState(() {
          students = records.map<Map<String, dynamic>> ((record) {
            return {
              'student_id' : record['student_id'] ?? 'null',
              'name' : record['student_name'] ?? 'null',
              'status' : convertStatus(record['status'] ?? 'null')
            };
          }).toList();

          for (var student in students) {
            statusMap[student['student_id']] = student['status'];
          }

        });

      } else {
        print('실패');
      }
    } catch (e) {
      print('에러발생!! $e');
    }

  }

  Future<void> fetchStudentUsernames() async {
    const String baseUrl = 'http://${ipHome}/api/attendance/lectures/students/';
    final uri = Uri.parse(baseUrl).replace(queryParameters: {'lecture_code' : widget.lecture.code!});

    final response = await http.get(
      uri,
      headers: {
        'Authorization' : 'Bearer $_token',
        'Content-Type' : 'application/json'
      }
    );

    if(response.statusCode == 200){
      final data = jsonDecode(response.body) as List;
      for (var student in data) {
        int id = student['id'];
        String username = student['username'];
        idToUsername[id] = username;
      }
    } else {
      print('유저네임 불러오기 실패');
    }
  }

  void submitAttendance() async {
    List<Future> requests = [];

    for(var student in students) {
      int studentId = student['student_id'];
      if(!modifiedIds.contains(studentId)) continue;

      String status = reverseStatus(statusMap[studentId] ?? '');
      String username = idToUsername[studentId] ?? '';

      try{
        final response = await http.post(
          Uri.parse('http://${ipHome}/api/attendance/attendance/manual-update/'),
          headers: {
            'Authorization' : 'Bearer $_token',
            'Content-Type' : 'application/json'
          },
          body: jsonEncode({
            'lecture_code' : widget.lecture.code!,
            'week' : widget.week,
            'student_username' : username,
            'status' : status
          })
        );
        if (response.statusCode == 200){
          print('저장 성공 : $studentId');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content : Text('저장 실패 : $studentId'))
          );
          return;
        }
      } catch (e) {
        print('error : $e');
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('출석 정보 저장 완료!'))
    );
    modifiedIds.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('주차별 출결이력', style: mediumBlack16),
            Text('${widget.lecture.name} ${widget.week}주차', style: mediumGrey13)
          ]
        ),
        titleSpacing: 0,
        backgroundColor: white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          // 테이블
          Expanded(
            child: Container(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  dataRowHeight: 50.h,
                  columns: [
                    DataColumn(label: Text("이름", style: boldBlack16)),
                    DataColumn(label: Text("상태", style: boldBlack16)),
                  ],
                  rows: students.map((student) {
                    int id = student["student_id"];
                    return DataRow(cells: [
                      DataCell(Text(student["name"], style: mediumBlack16)),
                      DataCell(
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            color: getStatusColor(statusMap[id]),
                            borderRadius: BorderRadius.circular(10.0)
                          ),
                          height: 40.h,
                          child: DropdownButton<String>(
                            value: statusMap[id],
                            dropdownColor: white,
                            onChanged: (value) {
                              setState(() {
                                statusMap[id] = value!;
                                modifiedIds.add(id);
                              });
                            },
                            items: ["출석", "지각", "결석"]
                                .map((s) => DropdownMenuItem(
                              child: Text(s, style: mediumBlack16),
                              value: s,
                            ))
                                .toList(),
                          ),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 12.h, top: 12.h),
        child: SizedBox(
          height: 41.h,
          child: ElevatedButton(
            onPressed: () {
              submitAttendance();
            },
            style: btnBlueRound15,
            child: Text("저장", style: mediumWhite16),
          ),
        ),
      ),
    );
  }
}

Color getStatusColor(String? status) {
  switch (status) {
    case "출석":
      return blue_light;
    case "지각":
      return yellow_light;
    case "결석":
      return red_light;
    default:
      return Colors.grey;
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

String reverseStatus(String status){
  switch (status) {
    case '출석': return 'present';
    case '지각': return 'late';
    case '결석': return 'absent';
    default: return 'absent';
  }
}
