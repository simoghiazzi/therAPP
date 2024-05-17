import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:therAPP/utils/options_swipe_screen.dart';
import 'package:therAPP/views/Utils/constants.dart';
import 'package:therAPP/views/Utils/custom_sizer.dart';

// ignore: must_be_immutable
class RenderModuleField extends StatefulWidget {
  final dynamic field;
  bool showNote = false;

  RenderModuleField({Key? key, required this.field}) : super(key: key);

  @override
  _RenderModuleFieldState createState() => _RenderModuleFieldState();
}

class _RenderModuleFieldState extends State<RenderModuleField> {
  late TextEditingController controller;
  late TextEditingController notesController;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(
      text: widget.field['value']?.toString() ?? '',
    );
    notesController = TextEditingController(
      text: widget.field['notes'] ?? '',
    );
  }

  @override
  void dispose() {
    controller.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.field['type']) {
      case 1: //TextField
        return Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: widget.field['name'],
              ),
              onChanged: (text) {
                setState(() {
                  widget.field['value'] = text;
                });
              },
            ),
            SizedBox(
              height:
                  (MediaQuery.of(context).orientation == Orientation.portrait)
                      ? 4.h
                      : 3.h,
            ),
          ],
        );
      case 2: //TextField only NUMBERS
        return Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: widget.field['name'],
              ),
              onChanged: (text) {
                setState(() {
                  widget.field['value'] = text;
                });
              },
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            SizedBox(
              height:
                  (MediaQuery.of(context).orientation == Orientation.portrait)
                      ? 5.h
                      : 4.h,
            ),
          ],
        );
      case 3: //Single selection
        List<String> options = List<String>.from(widget.field['options'] ?? []);
        String? selectedOption = widget.field['values']?.isNotEmpty == true
            ? widget.field['values']![0]
            : null;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.field['name'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9.sp),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).orientation ==
                          Orientation.portrait)
                      ? 1.h
                      : 2.h,
                ),
                GestureDetector(
                  child: Text(
                    widget.showNote ? "  -  " : "  +  ",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp),
                  ),
                  onTap: () {
                    setState(() {
                      widget.showNote = !widget.showNote;
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height:
                  (MediaQuery.of(context).orientation == Orientation.portrait)
                      ? 1.h
                      : 0.5.h,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8.0,
                children: options.map((option) {
                  bool isSelected = selectedOption == option;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          // Deselect the item if it's already selected
                          selectedOption = null;
                          widget.field['values'] = [];
                        } else {
                          // Select the item if it's not already selected
                          selectedOption = option;
                          widget.field['values'] = [selectedOption];
                        }
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: isSelected ? kPrimaryColor : Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(
                          color: kPrimaryColor,
                          width: 1.0, // Adjust border width as needed
                        ),
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            widget.showNote
                ? Column(
                    children: [
                      SizedBox(
                        height: (MediaQuery.of(context).orientation ==
                                Orientation.portrait)
                            ? 1.h
                            : 0.5.h,
                      ),
                      TextField(
                        controller: notesController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Note',
                        ),
                        onChanged: (text) {
                          setState(() {
                            widget.field['notes'] = text;
                          });
                        },
                      )
                    ],
                  )
                : Container(),
            SizedBox(
              height:
                  (MediaQuery.of(context).orientation == Orientation.portrait)
                      ? 6.h
                      : 5.h,
            ),
          ],
        );

      case 4: //Multiple Selection
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .center, // Centers the row's children horizontally
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.field['name'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9.sp),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).orientation ==
                          Orientation.portrait)
                      ? 1.h
                      : 2.h,
                ),
                GestureDetector(
                  child: Text(
                    widget.showNote ? "  -  " : "  +  ",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp),
                  ),
                  onTap: () {
                    setState(() {
                      widget.showNote = !widget.showNote;
                    });
                  },
                ),
              ],
            ),
            MultiSelectChipField<String?>(
              items: List<String>.from(widget.field['options'])
                  .map((String option) =>
                      MultiSelectItem<String?>(option, option))
                  .toList(),
              initialValue: widget.field['values']?.cast<String?>() ?? [],
              title: Text(widget.field['name']),
              showHeader: false,
              selectedChipColor: kPrimaryColor,
              selectedTextStyle: const TextStyle(color: Colors.white),
              decoration: const BoxDecoration(),
              scroll: false,
              onTap: (List<String?>? values) {
                setState(() {
                  widget.field['values'] = values?.cast<String>() ?? [];
                });
              },
            ),
            widget.showNote
                ? Column(children: [
                    SizedBox(
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? 1.h
                          : 0.5.h,
                    ),
                    TextField(
                      controller: notesController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Note',
                      ),
                      onChanged: (text) {
                        setState(() {
                          widget.field['notes'] = text;
                        });
                      },
                    )
                  ])
                : Container(),
            SizedBox(
              height:
                  (MediaQuery.of(context).orientation == Orientation.portrait)
                      ? 5.h
                      : 4.h,
            ),
          ],
        );
      case 5: //Slider
        String text = widget.field['name'].toUpperCase() +
            ": " +
            widget.field['value'].toString();
        return Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment
                .center, // Centers the row's children horizontally
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width:
                    (MediaQuery.of(context).orientation == Orientation.portrait)
                        ? 2.h
                        : 2.h,
              ),
              GestureDetector(
                child: Text(
                  widget.showNote ? "  -  " : "  +  ",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp),
                ),
                onTap: () {
                  setState(() {
                    widget.showNote = !widget.showNote;
                  });
                },
              ),
            ],
          ),
          SizedBox(
            height: (MediaQuery.of(context).orientation == Orientation.portrait)
                ? 3.h
                : 2.h,
          ),
          Slider(
            value: widget.field['value'] != ''
                ? widget.field['value'].toDouble()
                : widget.field['options'][0].toDouble(),
            min: widget.field['options'][0].toDouble(),
            max: widget.field['options'][1].toDouble(),
            divisions: widget.field['options'][1] - widget.field['options'][0],
            label: widget.field['value'].toString(),
            activeColor: kPrimaryColor,
            onChanged: (double value) {
              setState(() {
                widget.field['value'] = value.round();
              });
            },
          ),
          widget.showNote
              ? Column(children: [
                  SizedBox(
                    height: (MediaQuery.of(context).orientation ==
                            Orientation.portrait)
                        ? 1.h
                        : 0.5.h,
                  ),
                  TextField(
                    controller: notesController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Note',
                    ),
                    onChanged: (text) {
                      setState(() {
                        widget.field['notes'] = text;
                      });
                    },
                  )
                ])
              : Container(),
          SizedBox(
            height: (MediaQuery.of(context).orientation == Orientation.portrait)
                ? 5.h
                : 4.h,
          ),
        ]);
      case 6: //Swipe
        List<Map<String, dynamic>> options =
            List<Map<String, dynamic>>.from(widget.field['options'] ?? []);
        return OptionsSwipeScreen(options: options);
      default:
        return const Text("DEFAULT");
    }
  }
}
