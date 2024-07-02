import 'package:flutter/material.dart';
import 'package:ANAMNEASY/Views/Utils/constants.dart';
import 'package:sizer/sizer.dart';

/// Header of the application.
///
/// It contains the top bar with the [SafeArea] and the name of the application.
class Header extends StatelessWidget {
  /// Header of the application.
  ///
  /// It contains the top bar with the [SafeArea] and the name of the application.
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: kPrimaryColor,
        child: SafeArea(
          child: Container(
            color: kPrimaryColor,
            height: 7.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 5.0.w),
                  child: Text(
                    "ANAMNEASY",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                        fontFamily: "Gabriola"),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
