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

  RenderModuleField({super.key, required this.field});

  @override
  _RenderModuleFieldState createState() => _RenderModuleFieldState();
}

class _RenderModuleFieldState extends State<RenderModuleField> {
  late TextEditingController controller;
  late TextEditingController notesController;
  late FocusNode notesFocusNode;
  late FocusNode numberFocusNode;
  ValueNotifier<bool> showNoteNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(
      text: widget.field['value']?.toString() ?? '',
    );
    notesController = TextEditingController(
      text: widget.field['notes'] ?? '',
    );
    notesFocusNode = FocusNode();
    numberFocusNode = FocusNode();
  }

  @override
  void dispose() {
    controller.dispose();
    notesController.dispose();
    notesFocusNode.dispose();
    numberFocusNode.dispose();
    showNoteNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.field['type']) {
      case 1: // TextField
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
              onSubmitted: (value) {
                FocusScope.of(context).unfocus();
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
      case 2: // TextField only NUMBERS
        return Column(
          children: [
            TextField(
              controller: controller,
              focusNode: numberFocusNode,
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
              onSubmitted: (value) {
                FocusScope.of(context).unfocus();
              },
            ),
            SizedBox(
              height:
                  (MediaQuery.of(context).orientation == Orientation.portrait)
                      ? 5.h
                      : 4.h,
            ),
          ],
        );
      case 3: // Single selection
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
                  child: ValueListenableBuilder<bool>(
                    valueListenable: showNoteNotifier,
                    builder: (context, showNote, child) {
                      return Text(
                        showNote ? "  -  " : "  +  ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10.sp,
                        ),
                      );
                    },
                  ),
                  onTap: () {
                    showNoteNotifier.value = !showNoteNotifier.value;
                    if (showNoteNotifier.value) {
                      // Request focus when the TextField is shown
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        FocusScope.of(context).requestFocus(notesFocusNode);
                      });
                    }
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
                      margin: EdgeInsets.symmetric(vertical: 0.5.h),
                      padding:
                          EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
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
                          fontSize: 8.sp,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: showNoteNotifier,
              builder: (context, showNote, child) {
                return showNote
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
                            focusNode: notesFocusNode,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Note',
                            ),
                            onChanged: (text) {
                              widget.field['notes'] = text;
                            },
                            onSubmitted: (value) {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ],
                      )
                    : Container();
              },
            ),
            SizedBox(
              height:
                  (MediaQuery.of(context).orientation == Orientation.portrait)
                      ? 6.h
                      : 5.h,
            ),
          ],
        );

      case 4: // Multiple Selection
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
                  child: ValueListenableBuilder<bool>(
                    valueListenable: showNoteNotifier,
                    builder: (context, showNote, child) {
                      return Text(
                        showNote ? "  -  " : "  +  ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10.sp,
                        ),
                      );
                    },
                  ),
                  onTap: () {
                    showNoteNotifier.value = !showNoteNotifier.value;
                    if (showNoteNotifier.value) {
                      // Request focus when the TextField is shown
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        FocusScope.of(context).requestFocus(notesFocusNode);
                      });
                    }
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
              chipColor:
                  Colors.grey[200], // Background color for unselected chips
              textStyle: const TextStyle(
                fontSize: 16, // Custom text size for unselected chips
              ),
              selectedTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 16, // Custom text size for selected chips
              ),
              decoration: const BoxDecoration(),
              scroll: false,
              onTap: (List<String?>? values) {
                setState(() {
                  widget.field['values'] = values?.cast<String>() ?? [];
                });
              },
              itemBuilder: (item, state) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 0.5.w,
                      vertical: 1.h), // Adjust padding as needed
                  child: ChoiceChip(
                    label: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 3.h), // Adjust label padding as needed
                      child: Text(item.label),
                    ),
                    selected: widget.field['values'].contains(item.value),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          widget.field['values'].add(item.value);
                        } else {
                          widget.field['values'].remove(item.value);
                        }
                      });
                    },
                    selectedColor: kPrimaryColor,
                    backgroundColor:
                        Colors.white, // Ensure this matches chipColor
                    labelStyle: widget.field['values'].contains(item.value)
                        ? TextStyle(color: Colors.white, fontSize: 8.sp)
                        : TextStyle(color: Colors.black, fontSize: 8.sp),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          15.0), // Adjust the radius as needed
                      side: const BorderSide(
                        color: kPrimaryColor, // Customize the border color here
                      ),
                    ),
                  ),
                );
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable: showNoteNotifier,
              builder: (context, showNote, child) {
                return showNote
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
                            focusNode: notesFocusNode,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Note',
                            ),
                            onChanged: (text) {
                              widget.field['notes'] = text;
                            },
                            onSubmitted: (value) {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ],
                      )
                    : Container();
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
        return Column(children: [
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
          OptionsSwipeScreen(options: options)
        ]);
      default:
        return const Text("");
    }
  }
}
