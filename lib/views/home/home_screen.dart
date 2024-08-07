import 'package:flutter/material.dart';
import 'package:ANAMNEASY/Router/app_router_delegate.dart';
// import 'package:ANAMNEASY/Views/Utils/constants.dart';
import 'package:ANAMNEASY/views/Home/components/home_body.dart';
import 'package:provider/provider.dart';
// import 'package:sizer/sizer.dart';

/// Home page of the [BaseUser].
///
/// It contains the [BottomNavigationBar] with 2 pages: the [HomePageBody], [UserSettingsScreen].
///
/// When it is initialized, it loads all the stream of the view models of the [BaseUser].
///
/// It also takes the [pageIndex] that indicates which pages of the navigation bar it has to show.
class HomePageScreen extends StatefulWidget {
  /// Route of the page used by the Navigator.
  static const route = "/HomePageScreen";
  final int? pageIndex;

  /// Home page of the [BaseUser].
  ///
  /// It contains the [BottomNavigationBar] with 3 pages: the [HomePageBody],
  /// the [DiaryScreen] and the [UserSettingsScreen].
  ///
  /// When it is initialized, it loads all the stream of the view models of the [BaseUser].
  ///
  /// It also takes the [pageIndex] that indicates which pages of the navigation bar it has to show.
  const HomePageScreen({super.key, this.pageIndex});

  @override
  HomePageScreenState createState() => HomePageScreenState();
}

class HomePageScreenState extends State<HomePageScreen> {
  // Router Delegate
  late AppRouterDelegate routerDelegate;

  // Pages of the bottom navigation bar initialization
  late List<Widget> _pages;

  late int _currentIndex;

  @override
  void initState() {
    routerDelegate = Provider.of<AppRouterDelegate>(context, listen: false);

    // Initialization of the pages of the bottom navigation bar
    _pages = const [HomePageBody(), HomePageBody()]; //, UserSettingsScreen()];

    _currentIndex = widget.pageIndex ?? 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(index: _currentIndex, children: _pages),
      // bottomNavigationBar: SizedBox(
      //   height: 8.h, // Adjust this value according to your preference
      //   child: BottomNavigationBar(
      //     iconSize: 2.5.h,
      //     selectedFontSize: 6.sp,
      //     currentIndex: _currentIndex,
      //     showSelectedLabels: true,
      //     showUnselectedLabels: false,
      //     unselectedItemColor: kPrimaryColor,
      //     selectedItemColor: kPrimaryMediumColor,
      //     onTap: _onBottomNavTapped,
      //     items: const <BottomNavigationBarItem>[
      //       BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      //       BottomNavigationBarItem(
      //           icon: Icon(Icons.settings), label: "Settings")
      //     ],
      //   ),
      // ),
    );
  }

  /// Function called when the user change the current page from the bottom navigation bar.
  ///
  /// It sets the new [_currentIndex] of the [IndexedStack] and remove the current snack bar
  /// if one exists.
  void _onBottomNavTapped(int index) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    setState(() {
      FocusScope.of(context).unfocus();
      _currentIndex = index;
    });
  }
}
