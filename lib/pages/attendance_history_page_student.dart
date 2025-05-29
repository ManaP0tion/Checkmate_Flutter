import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pp/themes/styles.dart';
import 'package:pp/themes/colors.dart';
import 'package:pp/models/lecture.dart';

// 주차별 출석/결석 표시

class AttendanceHistoryStudentPage extends StatelessWidget {
  final Lecture lecture;
  AttendanceHistoryStudentPage({super.key, required this.lecture});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        title: Text('출결기록', style: mediumWhite16),
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          Text('${lecture.name} ${lecture.division}분반', style: boldBlack18),

        ]
      )
    );
  }
}
