import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ANAMNEASY/Views/Utils/custom_sizer.dart';
import 'package:ANAMNEASY/Views/Utils/constants.dart';
import 'package:ANAMNEASY/Router/app_router_delegate.dart';

class TopBar extends StatelessWidget {
  final String text;
  final double? textSize;
  final IconData backIcon;
  final List<Widget>? buttons;
  final bool back;
  final Function()? goBack;

  const TopBar({
    super.key,
    required this.text,
    this.textSize,
    this.backIcon = Icons.arrow_back_ios_new_rounded,
    this.buttons,
    this.back = true,
    this.goBack,
  });

  @override
  Widget build(BuildContext context) {
    AppRouterDelegate routerDelegate =
        Provider.of<AppRouterDelegate>(context, listen: false);

    assert(debugCheckHasMaterial(context));

    return Container(
      color: kPrimaryColor,
      child: SafeArea(
        child: Container(
          height: 7.8.h,
          padding: EdgeInsets.symmetric(horizontal: 2.5.w),
          decoration: const BoxDecoration(color: kPrimaryColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              if (back)
                Container(
                  margin: EdgeInsets.only(right: 3.w), // Add right margin here
                  child: InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      if (goBack != null) {
                        goBack!();
                      } else {
                        routerDelegate.pop();
                      }
                    },
                    child: Icon(backIcon, color: Colors.white, size: 25),
                  ),
                )
              else
                SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: textSize ?? 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (buttons != null)
                Row(
                  children: buttons!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
