import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants/assets_color.dart';
import '../widgets/texts/poppins_text.dart';

class Message {
  static showSuccessToast(FToast fToast, String msg) {
    fToast
      ..removeCustomToast()
      ..showToast(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 24),
          decoration: BoxDecoration(
              color: AssetsColor.secondary,
              borderRadius: BorderRadius.circular(25)),
          child: PoppinsTextWidget(
              textAlign: TextAlign.center,
              text: msg,
              fontColor: AssetsColor.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.normal),
        ),
      );
  }

  static showFailedToast(FToast fToast, String msg) {
    fToast
      ..removeCustomToast()
      ..showToast(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 24),
          decoration: BoxDecoration(
              color: AssetsColor.red, borderRadius: BorderRadius.circular(25)),
          child: PoppinsTextWidget(
              textAlign: TextAlign.center,
              text: msg,
              fontColor: AssetsColor.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.normal),
        ),
      );
  }
}
