import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pp/pages/attendance_history_page_professor.dart';
import 'package:pp/pages/attendance_history_page_student.dart';
import 'package:pp/pages/history_which_week.dart';
import 'package:pp/themes/styles.dart';
import 'package:pp/themes/colors.dart';
import 'package:pp/pages/scan_ble_page.dart';
import 'package:pp/pages/show_qr_page.dart';
import 'package:pp/models/lecture.dart';
import 'package:pp/pages/attendance_which_week.dart';

class LectureTile extends StatelessWidget {
  final Lecture? lecture;
  final LectureStudent? lectureStudent;
  final bool isProfessor;
  LectureTile({super.key, required this.isProfessor, this.lecture, this.lectureStudent});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Column(
            children: [
              SizedBox(height: 16.h),
              Row(
                  children: [
                    Text(isProfessor? lecture!.name : lectureStudent!.name, style: mediumBlack14),
                    SizedBox(width: 2.w),
                  ]
              ),
              SizedBox(height: 3.h),
              Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AttendanceWhichWeek(lecture: isProfessor? lecture! : null, lectureStudent: isProfessor? null : lectureStudent, isProfessor: isProfessor)));
                        },
                        child: isProfessor? Text("출석시작", style: mediumWhite14) : Text("출석하기", style: mediumWhite14),
                        style: TextButton.styleFrom(
                            backgroundColor: blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)
                            ),
                          elevation: 0
                        ),
                    ),
                    SizedBox(width: 10.w),
                    ElevatedButton(
                        onPressed: () {
                          if(isProfessor){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>HistoryWhichWeek(lecture: lecture!)));
                          }else{
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AttendanceHistoryStudentPage(lecture: lectureStudent!)));
                          }
                        },
                        child: Text("출석기록", style: mediumBlue14),
                        style: TextButton.styleFrom(
                            backgroundColor: blue_light,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)
                            ),
                          elevation: 0
                        ))
                  ]
              ),
              SizedBox(height: 16.h)
            ]
        )
    );
  }
}
