import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pp/pages/scan_ble_page.dart';
import 'package:pp/pages/scan_qr_page.dart';
import 'package:pp/themes/strings.dart';
import 'package:pp/themes/styles.dart';
import 'package:pp/themes/colors.dart';
import 'package:pp/models/lecture.dart';
import 'package:pp/pages/show_qr_page.dart';

class AttendanceWhichWeek extends StatefulWidget {
  final Lecture? lecture;
  final LectureStudent? lectureStudent;
  bool isProfessor;
  AttendanceWhichWeek({super.key, this.lecture, this.lectureStudent, required this.isProfessor});

  @override
  State<AttendanceWhichWeek> createState() => _AttendanceWhichWeekState();
}

class _AttendanceWhichWeekState extends State<AttendanceWhichWeek> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        titleSpacing: 0,
        surfaceTintColor: Colors.transparent,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('주차 선택', style: mediumBlack16),
            Text(widget.isProfessor? widget.lecture!.name : widget.lectureStudent!.name, style: mediumGrey13)
          ]
        )
      ),
      body: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.only(left: 18.w),
              child: Text('출석하려는 주차를 선택해주세요!', style: mediumBlack16, textAlign: TextAlign.start),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(height: 1, color: grey_seperating_line),
                itemCount: 15,
                itemBuilder: (context, index) {
                  return WeekListItem(lecture: widget.isProfessor? widget.lecture! : null, week: index+1, isProfessor: widget.isProfessor, lectureStudent: widget.isProfessor? null : widget.lectureStudent!);
                },
              )
            ),
          ],
        ),
      )
    );
  }
}


class WeekListItem extends StatelessWidget {
  final int week;
  final Lecture? lecture;
  final LectureStudent? lectureStudent;
  bool isProfessor;
  WeekListItem({super.key, this.lecture, required this.week, required this.isProfessor, this.lectureStudent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
      child: InkWell(
        onTap: () {
          if(isProfessor){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ShowQrPage(lecture: lecture!, week: week)));
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ScanBlePage(lecture: lectureStudent!, week: week)));
          }

        },
        child: Container(
          color: white,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${week}주차', style: mediumBlack16),
              Icon(Icons.chevron_right_rounded, size: 24, color: grey_outline_inputtext)
            ]
          ),
        ),
      ),
    );
  }
}

