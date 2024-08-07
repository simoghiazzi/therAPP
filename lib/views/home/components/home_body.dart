import 'package:flutter/material.dart';
import 'package:ANAMNEASY/views/Home/components/background.dart';
import 'package:ANAMNEASY/views/Home/components/header.dart';
import 'package:ANAMNEASY/views/Home/components/home_page_grid.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Header(),
        Expanded(child: Background(child: HomePageGrid())),
      ],
    );
  }
}
