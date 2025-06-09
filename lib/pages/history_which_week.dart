import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pp/pages/scan_ble_page.dart';
import 'package:pp/themes/strings.dart';
import 'package:pp/themes/styles.dart';
import 'package:pp/themes/colors.dart';
import 'package:pp/models/lecture.dart';
import 'package:pp/pages/attendance_history_page_professor.dart';


class HistoryWhichWeek extends StatelessWidget {
  final Lecture lecture;
  HistoryWhichWeek({super.key,required this.lecture});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
            backgroundColor: white,
            titleSpacing: 0,
            surfaceTintColor: Colors.transparent,
            title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('주차 선택', style: mediumBlack16),
                  Text(lecture.name, style: mediumGrey13)
                ]
            )
        ),
        body: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.only(left: 18.w),
                child: Text('출결이력을 확인할 주차를 선택해주세요!', style: mediumBlack16, textAlign: TextAlign.start),
              ),
              SizedBox(height: 10.h),
              Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(height: 1, color: grey_seperating_line),
                    itemCount: 15,
                    itemBuilder: (context, index) {
                      return WeekListItem(lecture: lecture, week: index+1);
                    },
                  )
              ),
            ],
          ),
        )
    );
  }
}

class WeekListItem extends StatelessWidget {
  final int week;
  final Lecture lecture;
  WeekListItem({super.key, required this.lecture, required this.week});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AttendacneHistoryProfessorPage(week: week, lecture: lecture)));
        },
        child: Container(
          color: white,
          width: double.infinity,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${week}주차', style: mediumBlack16),
                Icon(Icons.chevron_right_rounded, size: 24, color: grey_outline_inputtext)
              ]
          ),
        ),
      ),
    );
  }
}

