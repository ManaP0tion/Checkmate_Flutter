import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pp/themes/colors.dart';
import 'package:pp/themes/styles.dart';
import 'package:pp/models/lecture.dart';
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';
import 'package:pp/pages/home_page.dart';
import 'package:lottie/lottie.dart';

class ShowQrPage extends StatefulWidget {
  final Lecture lecture;
  ShowQrPage({super.key, required this.lecture});

  @override
  State<ShowQrPage> createState() => _ShowQrPageState();
}

class _ShowQrPageState extends State<ShowQrPage> {
  final _ble = FlutterBlePeripheral();

  @override
  void initState() {
    super.initState();

    AdvertiseData adData = AdvertiseData(
      includeDeviceName: true,
      serviceUuid: widget.lecture.bleUUID,
    );

    _ble.start(advertiseData: adData);
    print('ble 쏘는 중~~~');
  }

  void stopBle() {
    _ble.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text('출석체크 QR', style: mediumBlack18),
        titleSpacing: 0,
        backgroundColor: white,
        surfaceTintColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200.w,
              height: 200.h,
              color: Colors.grey
            ),
            SizedBox(height: 10.h),
            Text('${widget.lecture.name} ${widget.lecture.division}분반', style: boldBlack16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48.w,
                  height: 48.h,
                  child: Lottie.asset('assets/lottie_ble.json')
                ),
                Text('BLE 신호 송출 중', style: mediumGrey14)
              ]
            )
          ]
        )
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 24.h),
        child: SizedBox(
          height: 45.h,
          child: ElevatedButton(
            onPressed: () {
              stopBle();
              print('블루투스 종료 완료!');
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            style: btnBlueRound15,
            child: Text("종료하기", style: mediumWhite16),
          )
        )
      ),
    );
  }
}

