import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pp/customWidgets//custom_text_field.dart';
import 'package:pp/pages/register_page.dart';
import 'package:pp/pages/home_page.dart';
import 'package:pp/themes/styles.dart';
import 'package:pp/themes/colors.dart';

class StartPage extends StatefulWidget {
  StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose(){
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
                    controller: _idController,
                    name: '학번을 입력해주세요',
                    inputType: TextInputType.visiblePassword,
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: _passwordController,
                    name: '비밀번호를 입력해주세요',
                    obscureText: true,
                    inputType: TextInputType.visiblePassword
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: double.infinity,
                    height: 42.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                      style: btnBlueRound15,
                      child: Text("로그인", style: mediumWhite16),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  InkWell(
                    child: Text('회원가입', style: boldBlack16.copyWith(fontSize: 14.sp, color: blue)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
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
