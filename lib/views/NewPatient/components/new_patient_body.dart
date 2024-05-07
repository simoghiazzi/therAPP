import 'package:flutter/material.dart';
import 'package:therAPP/Router/app_router_delegate.dart';
import 'package:therAPP/views/Utils/top_bar.dart';

class NewPatientBody extends StatefulWidget {
  final bool showBack;
  final String barText;

  const NewPatientBody(
      {super.key, this.showBack = true, this.barText = "Seleziona modello"});

  @override
  NewPatientBodyState createState() => NewPatientBodyState();
}

class NewPatientBodyState extends State<NewPatientBody> {
  // Router Delegate
  late AppRouterDelegate routerDelegate;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopBar(
          text: widget.barText,
          back: widget.showBack,
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(constraints: const BoxConstraints(maxWidth: 500)),
          ),
        ),
      ],
    );
  }
}