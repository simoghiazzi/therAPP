import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:therAPP/views/Utils/constants.dart';
import 'package:therAPP/views/Utils/custom_sizer.dart';

class RenderModuleField extends StatefulWidget {
  final dynamic field;

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

  void _showCheckboxDialog() async {
    List<String> selectedOptions =
        List<String>.from(widget.field['values'] ?? []);
    List<String> options = List<String>.from(widget.field['options'] ?? []);

    List<String>? result = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(widget.field['name']),
          content: Scrollbar(
            child: SingleChildScrollView(
              child: ListBody(
                children: options.map((option) {
                  return CheckboxListTile(
                    value: selectedOptions.contains(option),
                    title: Text(option),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedOptions.add(option);
                        } else {
                          selectedOptions.remove(option);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(selectedOptions);
              },
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        widget.field['values'] = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.field['type']) {
      case 1:
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
                      ? 3.h
                      : 2.h,
            ),
          ],
        );
      case 2:
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
                      ? 3.h
                      : 2.h,
            ),
          ],
        );
      case 3:
        return Column(
          children: [
            DropdownButtonFormField(
              value: widget.field['value'] != ''
                  ? widget.field['value']
                  : widget.field['options'][0],
              items: widget.field['options']
                  .map<DropdownMenuItem<String>>((option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  widget.field['value'] = newValue;
                });
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: widget.field['name'],
              ),
            ),
            SizedBox(
              height:
                  (MediaQuery.of(context).orientation == Orientation.portrait)
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
            ),
            SizedBox(
              height:
                  (MediaQuery.of(context).orientation == Orientation.portrait)
                      ? 4.h
                      : 3.h,
            ),
          ],
        );
      case 4:
        return Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: _showCheckboxDialog,
                  style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      side: const BorderSide(color: Colors.transparent),
                      foregroundColor: kPrimaryColor),
                  child: Text(widget.field['name'] + ':'),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).orientation ==
                          Orientation.portrait)
                      ? 1.h
                      : 2.h,
                ),
                Text('${widget.field['values']?.join(', ') ?? ''}'),
              ],
            ),
            SizedBox(
              height:
                  (MediaQuery.of(context).orientation == Orientation.portrait)
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
            ),
            SizedBox(
              height:
                  (MediaQuery.of(context).orientation == Orientation.portrait)
                      ? 4.h
                      : 3.h,
            ),
          ],
        );
      case 5:
        String text = widget.field['name'].toUpperCase() +
            ": " +
            widget.field['value'].toString();
        return Column(children: [
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
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
          SizedBox(
            height: (MediaQuery.of(context).orientation == Orientation.portrait)
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
          ),
          SizedBox(
            height: (MediaQuery.of(context).orientation == Orientation.portrait)
                ? 4.h
                : 3.h,
          ),
        ]);
      case 6:
        return Column(children: [
          Text("CIAO"),
          SizedBox(
            height: (MediaQuery.of(context).orientation == Orientation.portrait)
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
          ),
          SizedBox(
            height: (MediaQuery.of(context).orientation == Orientation.portrait)
                ? 4.h
                : 3.h,
          ),
        ]);
      default:
        return SizedBox(
          height: (MediaQuery.of(context).orientation == Orientation.portrait)
              ? 4.h
              : 3.h,
        );
    }
  }
}
