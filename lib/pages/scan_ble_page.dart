import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pp/pages/scan_qr_page.dart';
import 'package:pp/themes/colors.dart';
import 'package:pp/themes/styles.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:pp/models/lecture.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:lottie/lottie.dart';

class ScanBlePage extends StatefulWidget {
  final Lecture lecture;
  ScanBlePage({super.key, required this.lecture});

  @override
  State<ScanBlePage> createState() => _ScanBlePageState();
}

class _ScanBlePageState extends State<ScanBlePage> {
  bool _foundProfessor = false;

  @override
  Widget build(BuildContext context) {

    Future<void> _startScan() async {
      await Permission.bluetoothScan.request();
      await Permission.location.request();

      FlutterBluePlus.startScan(timeout: Duration(seconds: 5));

      FlutterBluePlus.scanResults.listen((results) {
        for(ScanResult r in results){
          final serviceUuids = r.advertisementData.serviceUuids;
          if(serviceUuids.contains(widget.lecture.bleUUID)) {
            setState(() {
              _foundProfessor = true;
            });
            FlutterBluePlus.stopScan();
            Navigator.push(context, MaterialPageRoute(builder: (context) => QrScanPage()));
            break;
          }
        }
      });
    }

    @override
    void initState() {
      super.initState();
      _startScan();
    }

    @override
    void dispose() {
      super.dispose();
    }

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        surfaceTintColor: Colors.transparent,
        title: Text('출석하기', style: mediumBlack18),
        titleSpacing: 0,
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 120.h),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${widget.lecture.name} ${widget.lecture.division}분반', style: mediumBlack16),
                      SizedBox(height: 2.h),
                      Text('블루투스 신호를 찾고 있어요!\n잠시만 기다려주세요', style: boldBlack20, textAlign: TextAlign.center),
                    ]
                  ),
                  SizedBox(height: 12.h),
                  Center(
                    child: SizedBox(
                      width: 250.w,
                      height: 250.h,
                      child: _foundProfessor?
                      Lottie.asset('assets/lottie_check.json') : Lottie.asset('assets/lottie_ble.json')
                    ),
                  )
                ]
              ),
            )
          ),
        )
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 36.h),
        child: SizedBox(width: double.infinity, child: Text('블루투스 신호를 찾으면 QR코드를 스캔해주세요!', style: mediumGrey14, textAlign: TextAlign.center)),
      )

    );
  }
}
