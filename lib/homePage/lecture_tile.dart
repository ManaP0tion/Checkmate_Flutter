import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pp/themes/styles.dart';
import 'package:pp/themes/colors.dart';
import 'package:pp/qr_scan_page.dart';

class Lecture{
  String name;
  String division;

  Lecture({required this.name, required this.division});
}

class LectureTile extends StatelessWidget {
  final Lecture lecture;
  bool isProfessor;
  LectureTile({super.key, required this.isProfessor, required this.lecture});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Column(
            children: [
              SizedBox(height: 16.h),
              Row(
                  children: [
                    Text(lecture.name, style: mediumBlack14),
                    SizedBox(width: 2.w),
                    Text(lecture.division, style: mediumGrey14)
                  ]
              ),
              SizedBox(height: 3.h),
              Row(
                  children: [
                    ElevatedButton(
                        onPressed: isProfessor ? () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => QrScanPage()));
                        }: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => QrScanPage()));
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
                        onPressed: () {print("출석기록 버튼 클릭됨");},
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
