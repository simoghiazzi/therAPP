import 'package:flutter/material.dart';

/// Background of the [BaseUserHomePageBody].
///
/// It takes the [child] that is shown above the background.
class Background extends StatelessWidget {
  final Widget child;

  /// Background of the [BaseUserHomePageBody].
  ///
  /// It takes the [child] that is shown above the background.
  const Background({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
