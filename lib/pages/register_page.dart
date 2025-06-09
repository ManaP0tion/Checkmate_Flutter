import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pp/customWidgets/custom_text_field.dart';
import 'package:pp/pages/start_page.dart';
import 'package:pp/models/user.dart';
import 'package:pp/themes/styles.dart';
import 'package:pp/themes/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pp/customWidgets/custom_alert_dialog_confirm.dart';
import 'package:pp/themes/strings.dart';

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
  String _selectedUserType = '';

  @override
  void dispose(){
    _nameController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    _passwordCheckController.dispose();
    _majorController.dispose();
    super.dispose();
  }

  void register() async {
    if(_nameController.text.isEmpty || _idController.text.isEmpty || _passwordController.text.isEmpty || _passwordCheckController.text.isEmpty || _majorController.text.isEmpty || _selectedUserType==null){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content : Text('모든 항목을 입력해주세요', style: mediumBlack13))
      );
      return;
    }
    if(_passwordController.text != _passwordCheckController.text){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content : Text('비밀번호가 일치하지 않습니다.', style: mediumBlack13))
      );
      return;
    }
    String userType = _selectedUserType == '학생' ? 'student' : 'professor';
    final url = Uri.parse('http://10.0.2.2:8000/register');
    final response = await http.post(
      url,
      headers: {'Content-Type' : 'application/json'},
      body: jsonEncode({
        'username' : _idController.text,
        'password' : _passwordController.text,
        'name' : _nameController.text,
        'student_id' : _idController.text,
        'major' : _majorController.text,
        'user_type' : userType
      })
    );

    if(response.statusCode == 201){
      await showDialog(context: context, builder: (BuildContext context) => CustomAlertDialogConfirm(title: register_dialog_title, subtitle: register_dialog_subtitle), barrierDismissible: false);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StartPage()));
    } else {
      final error = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content : Text('회원가입 실패 : ${error.toString()}', style: mediumBlack13))
      );
    }
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
                Text('사용자 타입', style: mediumBlack16),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RadioListTile(
                        title: Text('학생', style: mediumBlack14),
                        value: '학생',
                        groupValue: _selectedUserType,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedUserType = value!;
                          });
                        },
                        activeColor: blue,
                        visualDensity: VisualDensity(horizontal: -4)
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        title: Text('교수자', style: mediumBlack14),
                        value: '교수자',
                        groupValue: _selectedUserType,
                        onChanged: (String? value){
                          setState(() {
                            _selectedUserType = value!;
                          });
                        },
                        activeColor: blue,
                        visualDensity: VisualDensity(horizontal: -4),
                      ),
                    ),
                    SizedBox(width: 50.w)
                  ]
                ),
                SizedBox(height: 24.h),
                Text('이름', style: mediumBlack16),
                SizedBox(height: 6.h),
                CustomTextField(
                  controller: _nameController,
                  name: '이름을 입력해주세요',
                  inputType: TextInputType.visiblePassword,
                ),
                SizedBox(height: 24.h),
                Text('소속', style: mediumBlack16),
                SizedBox(height: 6.h),
                CustomTextField(
                  controller: _majorController,
                  name: '소속을 입력해주세요',
                  inputType: TextInputType.visiblePassword,
                ),
                SizedBox(height: 24.h),
                Text('학번', style: mediumBlack16),
                SizedBox(height: 6.h),
                CustomTextField(
                  controller: _idController,
                  name: '학번을 입력해주세요',
                  inputType: TextInputType.visiblePassword,
                ),
                SizedBox(height: 24.h),
                Text('비밀번호', style: mediumBlack16),
                SizedBox(height: 6.h),
                CustomTextField(
                  controller: _passwordController,
                  name: '비밀번호를 입력해주세요',
                  obscureText: true,
                  inputType: TextInputType.visiblePassword,
                ),
                SizedBox(height: 24.h),
                Text('비밀번호 확인', style: mediumBlack16),
                SizedBox(height: 6.h),
                CustomTextField(
                  controller: _passwordCheckController,
                  name: '비밀번호를 다시 입력해주세요',
                  obscureText: true,
                  inputType: TextInputType.visiblePassword,
                ),
                SizedBox(height: 64.h),
              ]
            ),
      )
      )
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 24.h),
        child: SizedBox(
          height: 42.h,
          child: ElevatedButton(
            onPressed: () async {
              User(
                name: _nameController.text,
                userType: _selectedUserType,
                major: _majorController.text,
                studentId: _idController.text
              );
              register();
              //테스트용
              //await showDialog(context: context, builder: (BuildContext context) => CustomAlertDialogConfirm(title: register_dialog_title, subtitle: register_dialog_subtitle), barrierDismissible: false);
              //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StartPage()));
            },
            style: btnBlueRound15,
            child: Text("회원가입", style: mediumWhite16),
          ),
        ),
      ),
    );
  }
}
