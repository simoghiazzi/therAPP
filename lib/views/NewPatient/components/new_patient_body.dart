import 'package:flutter/material.dart';
import 'package:therAPP/views/Utils/custom_sizer.dart';
import 'package:therAPP/views/Utils/top_bar.dart';

class NewPatientBody extends StatefulWidget {
  final bool showBack;
  final String barText;
  final List<Map<String, dynamic>> templates;
  final dynamic chosenFile;
  final Function(String) updateChosenFile;

  const NewPatientBody({
    Key? key,
    this.showBack = true,
    this.barText = "Seleziona modello",
    required this.templates,
    required this.chosenFile,
    required this.updateChosenFile,
  }) : super(key: key);

  @override
  NewPatientBodyState createState() => NewPatientBodyState();
}

class NewPatientBodyState extends State<NewPatientBody> {
  late String _chosenFileName = "";
  dynamic _previousChosenFile;

  @override
  void initState() {
    super.initState();
    _chosenFileName = widget.chosenFile == ""
        ? widget.templates[0]['name']
        : widget.chosenFile;
    _previousChosenFile = widget.chosenFile;
  }

  @override
  void didUpdateWidget(covariant NewPatientBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.chosenFile != _previousChosenFile) {
      _previousChosenFile = widget.chosenFile;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopBar(
          text: widget.barText,
          back: widget.showBack,
        ),
        SizedBox(
            height: (MediaQuery.of(context).orientation == Orientation.portrait)
                ? 50.h
                : 40.h),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: DropdownButton<String>(
              value: _chosenFileName,
              items: widget.templates.map<DropdownMenuItem<String>>(
                (Map<String, dynamic> item) {
                  return DropdownMenuItem<String>(
                    value: item["name"],
                    child: Text(item["name"]),
                  );
                },
              ).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _chosenFileName = newValue;
                  });
                  widget.updateChosenFile(newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
