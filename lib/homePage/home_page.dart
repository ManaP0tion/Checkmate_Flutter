import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pp/themes/styles.dart';
import 'package:pp/themes/colors.dart';
import 'package:pp/homePage/lecture_tile.dart';

class User{
  String name;
  String studentId;
  String major;
  String userType;

  User({required this.name, required this.studentId, required this.major, required this.userType});
}


class HomePage extends StatelessWidget {
  HomePage({super.key});
  // 테스트용
  static User user = User(name: "김교수", studentId: "2021041076", major: "소프트웨어학부", userType: "교수자");
  static List<Lecture> lectures = [Lecture(name: '데이터 사이언스', division: '01'), Lecture(name: '임베디스 시스템', division: '01'), Lecture(name: '캡스톤 디자인', division: '02'), Lecture(name: '컴퓨터 비전', division: '01'), Lecture(name: '클라우드 컴퓨팅 ', division: '01'),];
  final isProfessor = (user.userType=='교수자');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text('체크메이트', style: boldWhite18),
        backgroundColor: blue,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 20,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: white, size: 24),
            onPressed: () {},
          )
        ]
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 360.w,
                  height: 110.h,
                  color: blue),
                Positioned(
                  top: 20.h,
                  left: 0.w,
                  right: 0.w,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Card(
                      color: white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: grey_seperating_line, width: 1.0)),
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 14.h, bottom: 14.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 52.w,
                              height: 22.h,
                              decoration: BoxDecoration(color: blue_light, borderRadius: BorderRadius.circular(10.0)),
                              child: Center(child: Text(user.userType, style: mediumBlue13))
                            ),
                            SizedBox(height: 6.h),
                            Text(user.name, style: boldBlack16),
                            SizedBox(height: 2.h),
                            Text("${user.major} | ${user.studentId}", style: mediumBlack14),
                            SizedBox(height: 10.h),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: btnBlueRound15,
                                onPressed: () {
                                  print("Login Button clicked!");
                                },
                                child: Text("로그아웃", style: mediumWhite14),
                              ),
                            )
                          ]
                        ),
                      )
                    )
                  )
                )
              ]
            ),
            SizedBox(
              height: 90.h
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
                            itemCount: lectures.length,
                            itemBuilder: (context, index) {
                              return LectureTile(isProfessor: isProfessor, lecture: lectures[index]);
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
