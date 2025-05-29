import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pp/customWidgets/custom_text_field.dart';
import 'package:pp/themes/styles.dart';
import 'package:pp/themes/colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordCheckController = TextEditingController();
  final _majorController = TextEditingController();

  @override
  void dispose(){
    _nameController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    _passwordCheckController.dispose();
    _majorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        title: Text('회원가입', style: mediumBlack18),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: black, size: 24),
          onPressed: () {
            Navigator.pop(context);
          }
        )
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Padding(
          padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('이름', style: mediumBlack14),
                SizedBox(height: 6.h),
                CustomTextField(
                  controller: _nameController,
                  name: '이름을 입력해주세요',
                  inputType: TextInputType.text,
                ),
                SizedBox(height: 24.h),
                Text('소속', style: mediumBlack14),
                SizedBox(height: 6.h),
                CustomTextField(
                  controller: _majorController,
                  name: '소속을 입력해주세요',
                  inputType: TextInputType.text,
                ),
                SizedBox(height: 24.h),
                Text('학번', style: mediumBlack14),
                SizedBox(height: 6.h),
                CustomTextField(
                  controller: _idController,
                  name: '학번을 입력해주세요',
                  inputType: TextInputType.text,
                ),
                SizedBox(height: 24.h),
                Text('비밀번호', style: mediumBlack14),
                SizedBox(height: 6.h),
                CustomTextField(
                  controller: _passwordController,
                  name: '비밀번호를 입력해주세요',
                  obscureText: true,
                  inputType: TextInputType.visiblePassword,
                ),
                SizedBox(height: 24.h),
                Text('비밀번호 확인', style: mediumBlack14),
                SizedBox(height: 6.h),
                CustomTextField(
                  controller: _passwordCheckController,
                  name: '비밀번호를 다시 입력해주세요',
                  obscureText: true,
                  inputType: TextInputType.visiblePassword,
                ),
                SizedBox(height: 24.h),
              ]
            ),
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
            child: Text("회원가입", style: mediumWhite16),
          ),
        ),
      ),
    );
  }
}
