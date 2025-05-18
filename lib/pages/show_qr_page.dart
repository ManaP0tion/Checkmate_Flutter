import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pp/themes/colors.dart';
import 'package:pp/themes/styles.dart';
import 'package:pp/models/lecture.dart';

class ShowQrPage extends StatelessWidget {
  final Lecture lecture;
  ShowQrPage({super.key, required this.lecture});

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
                color: grey
              ),
              SizedBox(height: 10.h),
              Text("${lecture.name} ${lecture.division}분반", style: boldBlack16)
            ],
          )
        )
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 24.h),
        child: SizedBox(
          height: 41.h,
          child: ElevatedButton(
            onPressed: () {
              print("Register Button clicked!");
            },
            style: btnBlueRound15,
            child: Text("종료하기", style: mediumWhite16),
          ),
        ),
      ),
    );
  }
}
