import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pp/themes/styles.dart';
import 'package:pp/themes/colors.dart';
import 'package:pp/pages/home_page.dart';

class CustomAlertDialogConfirm extends StatelessWidget {
  const CustomAlertDialogConfirm({super.key});

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
            Text('정상적으로 출석처리 되었습니다', style: mediumBlack16),
            SizedBox(height: 12.h),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
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
