import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pp/themes/styles.dart';
import 'package:pp/themes/colors.dart';

class CustomAlertDialogLogout extends StatelessWidget {
  const CustomAlertDialogLogout({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: white,
      content: Container(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 12.h),
          decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(10.0)
          ),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('정말 로그아웃 하시겠습니까?', style: mediumBlack16),
                SizedBox(height: 12.h),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('확인', style: mediumWhite14),
                    style: btnBlueRound15
                )
              ]
          )
      ),
    );
  }
}