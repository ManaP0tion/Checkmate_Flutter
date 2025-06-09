import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pp/themes/strings.dart';
import 'package:pp/themes/styles.dart';
import 'package:pp/themes/colors.dart';
import 'package:pp/customWidgets/lecture_tile.dart';
import 'package:pp/models/lecture.dart';
import 'package:pp/models/user.dart';
import 'package:pp/customWidgets/custom_alert_dialog_confirm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pp/pages/start_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pp/themes/strings.dart';


class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? userData;
  User? user;
  List<Lecture> _lectures = [];
  List<LectureStudent> _lecturesStudent = [];
  bool isProfessor = false;
  bool _isLoading = true;
  String? _token;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await loadUserData();

    if(user != null) {
      if(isProfessor){
        await loadLectureDataProfessor();
      } else {
        await loadLectureDataStudent();
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> loadLectureDataStudent() async {
    try{
      final response = await http.get(
        Uri.parse('http://${ipHome}/api/attendance/my-lectures/'),
        headers: {
          'Authorization' : 'Bearer $_token',
          'Content-Type' : 'application/json'
        }
      );

      if(response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          _lecturesStudent = data.map((json) => LectureStudent.fromJson(json)).toList();
        });
      } else {
        throw Exception('강의 목록 불러오기 실패');
      }
    } catch (e) {
      print('학생 강의 로드 중 에러');
      // 에러 처리
    }
  }

  Future<void> loadLectureDataProfessor() async {
    try{
      final response = await http.get(
          Uri.parse('http://${ipHome}/api/attendance/lectures/my/'),
          headers: {
            'Authorization' : 'Bearer $_token',
            'Content-Type' : 'application/json'
          }
      );

      if(response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          _lectures = data.map((json) => Lecture.fromJson(json)).toList();
        });
      } else {
        throw Exception('강의 목록 불러오기 실패');
      }
    } catch (e) {
      print('교수 강의 로드 중 에러');
      // 에러 처리
    }
  }



  Future<void> loadUserData() async {
    final data = await fetchUserInfo();
    setState(() {
      userData = data;
      user = User(name: userData!['name'], studentId: userData!['username'], major: userData!['role'] == 'student' ? userData!['major'] : userData!['department'], userType: userData!['role'] == 'student' ? '학생' : '교수자');
      isProfessor = user!.userType=='교수자';
    });
  }

  Future<Map<String, dynamic>?> fetchUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if(token == null){
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StartPage()));
      return null;
    }
    _token = token;

    final response = await http.get(
      Uri.parse('http://${ipHome}/api/users/me/'),
      headers: {
        'Authorization' : 'Bearer $_token',
        'Content-Type' : 'application/json'
      }
    );

    if(response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null; // 오류처리
    }

  }


  @override
  Widget build(BuildContext context) {
    if(_isLoading) {
      return Scaffold(
        backgroundColor: white,
        body: Center(child: CircularProgressIndicator(color: blue))
      );
    }
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text('체크메이트', style: boldBlack18, textAlign: TextAlign.start),
        leading: SizedBox.shrink(),
        leadingWidth: 8.w,
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: black, size: 24),
            onPressed: () {
              showDialog(context: context, builder: (BuildContext context) => CustomAlertDialogConfirm(title: attendance_dialog_title, subtitle: attendance_dialog_subtitle), barrierDismissible: false);
            },
          )
        ]
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: SizedBox(
                width: double.infinity,
                child: Card(
                  color: white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: grey_seperating_line, width: 1.0)),
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 14.h, bottom: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 52.w,
                          height: 22.h,
                          decoration: BoxDecoration(color: blue_light, borderRadius: BorderRadius.circular(10.0)),
                          child: Center(child: Text(user!.userType, style: mediumBlue13))
                        ),
                        SizedBox(height: 6.h),
                        Text(user!.name, style: boldBlack16),
                        SizedBox(height: 2.h),
                        Text("${user!.studentId} | ${user!.major}", style: mediumBlack14),
                      ]
                    ),
                  )
                ),
              )
            ),
            SizedBox(
              height: 32.h
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("강의 목록", style: boldBlack16),
                    SizedBox(height: 4.h),
                    Expanded(
                      child: Card(
                          color: white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: grey_seperating_line, width: 1.0)),
                          child: Padding(
                              padding: EdgeInsets.only(left: 16.w, right: 16.w),
                              child: ListView.separated(
                                separatorBuilder: (context, index) => Divider(color: grey_seperating_line, height: 1),
                                itemCount: isProfessor? _lectures.length : _lecturesStudent.length,//_lectures.length,
                                itemBuilder: (context, index) {
                                  return LectureTile(isProfessor: isProfessor, lecture: isProfessor? _lectures[index] : null, lectureStudent: isProfessor? null : _lecturesStudent[index]);
                                },
                              )
                          )
                      ),
                    )
                  ]
                )
              ),
            ),
            SizedBox(height: 30.h)
          ]
        ),
      )
    );
  }
}
