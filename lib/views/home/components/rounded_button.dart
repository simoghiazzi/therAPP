import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:ANAMNEASY/views/Utils/constants.dart';
import 'package:ANAMNEASY/views/Utils/custom_sizer.dart';

/// Button component used in the entire application.
///
/// It takes the [text] to show inside the button, the optional [prefixIcon] that is drawn
/// before the text and the optional [suffixIcon] that is drawn after the text.
class RoundedButton extends StatelessWidget {
  final String text;
  final Function onTap;
  final Icon? prefixIcon, suffixIcon;
  final Color color, textColor;
  final bool enabled;

  /// Button component used in the entire application.
  ///
  /// It takes the [text] to show inside the button, the optional [prefixIcon] that is drawn
  /// before the text and the optional [suffixIcon] that is drawn after the text.
  const RoundedButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color = kPrimaryColor,
    this.textColor = Colors.white,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all<Size>(Size(
            SizerUtil.deviceType == DeviceType.tablet
                ? CustomSizer(20).w
                : CustomSizer(30).w,
            CustomSizer(5).h)),
        backgroundColor: WidgetStateProperty.all<Color>(
            enabled ? color : const Color(0xFFD3D3D3)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
        shadowColor: WidgetStateProperty.all<Color>(
            enabled ? kPrimaryLightColor : const Color(0xFFD3D3D3)),
      ),
      onPressed: enabled ? onTap as Function() : null,
      child: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            prefixIcon ?? Container(),
            const SizedBox(width: 5),
            Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: CustomSizer(10).sp,
                    fontWeight: FontWeight.bold,
                    color: textColor)),
            const SizedBox(width: 5),
            suffixIcon ?? Container(),
          ],
        ),
      ),
    );
  }
}
