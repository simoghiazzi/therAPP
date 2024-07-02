import 'package:ANAMNEASY/views/Home/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:ANAMNEASY/Views/Utils/constants.dart';
import 'package:ANAMNEASY/Router/app_router_delegate.dart';

/// ANAMNEASY project author: @simoneghiazzi
///
/// Copyright 2024. All rights reserved.
/// The ANAMNEASY authors.

void main() {
  // Flutter initialization
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  final String? homePage;

  const MyApp({super.key, this.homePage});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  AppRouterDelegate routerDelegate = AppRouterDelegate();

  @override
  void initState() {
    // Add the WelcomePage to the routerDelegate and the homePage only if the user is already logged
    routerDelegate.replaceAll([
      const RouteSettings(name: HomePageScreen.route),
      if (widget.homePage != null) ...[RouteSettings(name: widget.homePage)],
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppRouterDelegate>(
            create: (_) => routerDelegate),
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) {
          // Check the device type and disable the landscape orientation if it is not a tablet
          if (!(deviceType == DeviceType.tablet)) {
            SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "ANAMNEASY",
            theme: ThemeData(
              primaryColor: kPrimaryColor,
              scaffoldBackgroundColor: Colors.white,
              fontFamily: "Lato",
            ),
            home: Router(
              routerDelegate: routerDelegate,
              backButtonDispatcher: RootBackButtonDispatcher(),
            ),
          );
        },
      ),
    );
  }
}
