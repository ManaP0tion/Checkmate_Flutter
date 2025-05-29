import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pp/themes/styles.dart';
import 'package:pp/themes/colors.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:pp/models/lecture.dart';

// 학생리스트, 수동출결

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

  @override
  void initState() {
    super.initState();
    fetchStudentData(); // 예시용 더미 데이터 호출
  }

  void fetchStudentData() async {
    // 실제 API로 대체 가능
    setState(() {
      students = [
        {
          "student_id": 1,
          "name": "홍길동",
          "student_number": "20211234",
          "major": "컴퓨터공학과",
          "status": "출석"
        },
        {
          "student_id": 2,
          "name": "이영희",
          "student_number": "20211235",
          "major": "소프트웨어공학과",
          "status": "결석"
        },
        {
          "student_id": 3,
          "name": "박박박",
          "student_number": "20211236",
          "major": "소프트웨어공학과",
          "status": "결석"
        },
        {
          "student_id": 4,
          "name": "김김김",
          "student_number": "20211237",
          "major": "소프트웨어공학과",
          "status": "결석"
        },
        {
          "student_id": 4,
          "name": "김김김",
          "student_number": "20211237",
          "major": "소프트웨어공학과",
          "status": "결석"
        },{
          "student_id": 4,
          "name": "김김김",
          "student_number": "20211237",
          "major": "소프트웨어공학과",
          "status": "결석"
        },{
          "student_id": 4,
          "name": "김김김",
          "student_number": "20211237",
          "major": "소프트웨어공학과",
          "status": "결석"
        },{
          "student_id": 4,
          "name": "김김김",
          "student_number": "20211237",
          "major": "소프트웨어공학과",
          "status": "결석"
        },{
          "student_id": 4,
          "name": "김김김",
          "student_number": "20211237",
          "major": "소프트웨어공학과",
          "status": "결석"
        },{
          "student_id": 4,
          "name": "김김김",
          "student_number": "20211237",
          "major": "소프트웨어공학과",
          "status": "결석"
        },{
          "student_id": 4,
          "name": "김김김",
          "student_number": "20211237",
          "major": "소프트웨어공학과",
          "status": "결석"
        },



      ];

      // 초기 statusMap 설정
      for (var student in students) {
        statusMap[student["student_id"]] = student["status"];
      }
    });
  }

  void submitAttendance() async {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("출석 정보 저장 완료")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text('주차별 출결이력', style: mediumBlack16),
        titleSpacing: 0,
        backgroundColor: white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 과목, 분반, 주차 정보
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: Text("${widget.lecture.name} ${widget.lecture.division}분반 - ${widget.week}주차", style: boldBlack18),
          ),
          // 테이블
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  dataRowHeight: 50.h,
                  columns: [
                    DataColumn(label: Text("학번", style: boldBlack16)),
                    DataColumn(label: Text("이름", style: boldBlack16)),
                    DataColumn(label: Text("전공", style: boldBlack16)),
                    DataColumn(label: Text("상태", style: boldBlack16)),
                  ],
                  rows: students.map((student) {
                    int id = student["student_id"];
                    return DataRow(cells: [
                      DataCell(Text(student["student_number"], style: mediumBlack16)),
                      DataCell(Text(student["name"], style: mediumBlack16)),
                      DataCell(Text(student["major"], style: mediumBlack16)),
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
