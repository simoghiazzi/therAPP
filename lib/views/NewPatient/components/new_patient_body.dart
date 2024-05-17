import 'package:flutter/material.dart';
import 'package:therAPP/utils/render_module_field.dart';
import 'package:therAPP/views/Home/components/rounded_button.dart';
import 'package:therAPP/views/Utils/custom_sizer.dart';
import 'package:therAPP/views/Utils/top_bar.dart';

class NewPatientBody extends StatefulWidget {
  final bool showBack;
  final String barText;
  final List<Map<String, dynamic>> templates;
  final dynamic chosenFile;
  final Function(String) updateChosenFile;
  final Map<String, dynamic> newUserModel;
  final int step;
  final Function() nextStep;
  final Function() previousStep;
  final bool showNoNameError;

  const NewPatientBody(
      {Key? key,
      this.showBack = true,
      this.barText = "Seleziona modello",
      required this.templates,
      required this.chosenFile,
      required this.updateChosenFile,
      required this.newUserModel,
      required this.step,
      required this.nextStep,
      required this.previousStep,
      required this.showNoNameError})
      : super(key: key);

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

  Widget renderForm() {
    return Column(
      children: <Widget>[Container()],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopBar(
          text: widget.barText,
          back: widget.showBack,
          goBack: widget.step > 1 ? widget.previousStep : null,
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (widget.step == 1) ...[
                    SizedBox(
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? 40.h
                          : 30.h,
                    ),
                    DropdownButton<String>(
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
                    SizedBox(
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? 3.h
                          : 2.h,
                    ),
                    RoundedButton(
                      text: "CONFERMA",
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        widget.nextStep();
                      },
                      enabled: widget.newUserModel.isNotEmpty,
                    ),
                  ],
                  if (widget.step == 2) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...widget.newUserModel.entries.expand((entry) {
                          List<Widget> entryWidgets = [];
                          entryWidgets.add(
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                entry.key.toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ),
                          );

                          entryWidgets.add(SizedBox(
                            height: (MediaQuery.of(context).orientation ==
                                    Orientation.portrait)
                                ? 2.h
                                : 1.h,
                          ));

                          if (entry.value is List) {
                            entryWidgets.addAll(
                              (entry.value as List).map<Widget>((item) {
                                if (item is Map) {
                                  return Align(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                          width: 130.w,
                                          child:
                                              RenderModuleField(field: item)));
                                }
                                return const SizedBox.shrink();
                              }).toList(),
                            );
                          }

                          return entryWidgets;
                        }),
                        widget.showNoNameError
                            ? Align(
                                alignment: Alignment.center,
                                child: Column(children: [
                                  Text("INSERIRE NOME E COGNOME",
                                      style: TextStyle(
                                          fontSize: 7.sp, color: Colors.red)),
                                  SizedBox(
                                    height:
                                        (MediaQuery.of(context).orientation ==
                                                Orientation.portrait)
                                            ? 2.h
                                            : 1.h,
                                  )
                                ]),
                              )
                            : Container(),
                        Align(
                          alignment: Alignment.center,
                          child: RoundedButton(
                            text: "CONFERMA",
                            onTap: () {
                              widget.nextStep();
                            },
                            enabled: widget.newUserModel.isNotEmpty,
                          ),
                        ),
                        SizedBox(
                          height: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? 4.h
                              : 3.h,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
