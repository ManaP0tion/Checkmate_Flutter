import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pp/startPage/custom_text_field.dart';
import 'package:pp/themes/styles.dart';
import 'package:pp/themes/colors.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text('회원가입', style: mediumBlack18),
        titleSpacing: 20,
        backgroundColor: white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: black, size: 24),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: []
                // 교수자/학생 || 아이디, 이름, 소속, 비번, 비번확인
            )
          )
        )
      )
    );
  }
}
