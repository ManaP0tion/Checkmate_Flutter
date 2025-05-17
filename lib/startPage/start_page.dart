import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pp/startPage/custom_text_field.dart';
import 'package:pp/themes/styles.dart';
import 'package:pp/themes/colors.dart';

class StartPage extends StatefulWidget {
  StartPage({super.key});

  final idController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("CHECKMATE", style: boldBlack36),
                  SizedBox(height: 28.h),
                  CustomTextField(
                    controller: widget.idController,
                    name: '학번을 입력해주세요',
                    inputType: TextInputType.text,
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: widget.passwordController,
                    name: '비밀번호를 입력해주세요',
                    obscureText: true,
                    inputType: TextInputType.visiblePassword
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: double.infinity,
                    height: 41.h,
                    child: ElevatedButton(
                      onPressed: () {
                        print("Login Button clicked!");
                      },
                      style: btnBlueRound15,
                      child: Text("로그인", style: mediumWhite16),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  InkWell(
                    child: Text('회원가입', style: boldBlack16.copyWith(fontSize: 14.sp, color: blue)),
                    onTap: () {

                    },
                  )
                ]
              )
            )
          ),
        )
      )
    );
  }
}
