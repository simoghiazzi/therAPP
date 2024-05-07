import 'package:flutter/material.dart';

/// Background of the [BaseUserHomePageBody].
///
/// It takes the [child] that is shown above the background.
class Background extends StatelessWidget {
  final Widget child;

  /// Background of the [BaseUserHomePageBody].
  ///
  /// It takes the [child] that is shown above the background.
  const Background({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: <Widget>[
          // Top Left Image
          Positioned(
              child: Image.asset("assets/images/main_top.png", scale: 2)),
          // Bottom Right Image
          Positioned(
              bottom: 0,
              right: 0,
              child: Opacity(
                  opacity: 0.5,
                  child:
                      Image.asset("assets/images/home_bottom.png", scale: 2))),
          child,
        ],
      ),
    );
  }
}
