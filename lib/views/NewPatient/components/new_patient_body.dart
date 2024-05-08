import 'package:flutter/material.dart';
import 'package:therAPP/Router/app_router_delegate.dart';
import 'package:therAPP/views/Utils/top_bar.dart';

class NewPatientBody extends StatefulWidget {
  final bool showBack;
  final String barText;

  final List<Map<String, dynamic>> templates;

  const NewPatientBody(
      {super.key,
      this.showBack = true,
      this.barText = "Seleziona modello",
      required this.templates});

  @override
  NewPatientBodyState createState() => NewPatientBodyState();
}

class NewPatientBodyState extends State<NewPatientBody> {
  // Router Delegate
  late AppRouterDelegate routerDelegate;
  String _selectedName = '';

  @override
  void initState() {
    super.initState();
    // Initialize the selected value to the name of the first element
    _selectedName = widget.templates[0]['name'];
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
              child: Container(
                child: DropdownButton<String>(
                  value: _selectedName,
                  items: widget.templates.map<DropdownMenuItem<String>>(
                    (Map<String, dynamic> item) {
                      return DropdownMenuItem<String>(
                        value: item["name"],
                        child: Text(item["name"]),
                      );
                    },
                  ).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedName = newValue!;
                    });
                  },
                ),
              )),
        ),
      ],
    );
  }
}
