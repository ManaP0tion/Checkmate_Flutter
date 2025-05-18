import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pp/themes/colors.dart';
import 'package:pp/themes/styles.dart';
import 'package:lottie/lottie.dart';

class ScanBlePage extends StatefulWidget {
  const ScanBlePage({super.key});

  @override
  State<ScanBlePage> createState() => _ScanBlePageState();
}

class _ScanBlePageState extends State<ScanBlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        surfaceTintColor: Colors.transparent,
        title: Text('출석하기', style: mediumBlack18),
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: black, size: 24),
          onPressed: () {
            Navigator.pop(context);
          }
        )
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/lottie_ble.json'),
              SizedBox(height: 6.h),
              Text('잠시만 기다려주세요', style: boldBlack16)
            ]
          )
        )
      )
    );
  }
}
