import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pp/customWidgets//custom_text_field.dart';
import 'package:pp/pages/register_page.dart';
import 'package:pp/pages/home_page.dart';
import 'package:pp/pages/scan_ble_page.dart';
import 'package:pp/themes/styles.dart';
import 'package:pp/themes/colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pp/themes/strings.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

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

  void login() async {
    if(_idController.text.isEmpty || _passwordController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('빈 칸 없이 입력해주세요', style: mediumWhite14))
      );
      return;
    }

    final url = Uri.parse('http://${ipHome}/api/users/login/');
    final response = await http.post(
      url,
      headers: {'Content-Type' : 'application/json'},
      body: jsonEncode({
        'username' : _idController.text,
        'password' : _passwordController.text
      })
    );

    if (response.statusCode == 200){
      final data = jsonDecode(response.body);
      final accessToken = data['access'];

      await saveAccessToken(accessToken);
      //Navigator.push(context, MaterialPageRoute(builder: (context) => ScanBlePage(lectureCode: 'CS101', week: 1)));
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content : Text('로그인 실패. 아이디와 비밀번호를 확인하세요.', style: mediumWhite14))
      );
    }
  }

  Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
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
                    inputType: TextInputType.text,
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
                    height: 41.h,
                    child: ElevatedButton(
                      onPressed: login,
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
