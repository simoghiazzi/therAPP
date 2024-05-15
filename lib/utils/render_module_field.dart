import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:therAPP/views/Utils/custom_sizer.dart'; // Import for JSON decoding

Widget renderModuleField(dynamic field, BuildContext context) {
  TextEditingController controller = TextEditingController(
    text: field['value'] ?? '', // Initialize with field['value'] if not null
  );

  switch (field['type']) {
    case 1:
      return Column(
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: field['name'],
            ),
            onChanged: (text) {
              field['value'] = text; // Update field['value'] on text change
            },
          ),
          SizedBox(
            height: (MediaQuery.of(context).orientation == Orientation.portrait)
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
              labelText: field['name'],
            ),
            onChanged: (text) {
              field['value'] = text; // Update field['value'] on text change
            },
            keyboardType: TextInputType.number, // Set keyboard type to number
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly, // Allow only digits
            ],
          ),
          SizedBox(
            height: (MediaQuery.of(context).orientation == Orientation.portrait)
                ? 3.h
                : 2.h,
          ),
        ],
      );
    case 3:
      return Column(
        children: [
          Text(field['options'].toString() ?? field['options'][0]),
          // DropdownButtonFormField(
          //   value: field['value'] ?? field['options'][0],
          //   items: field['options'].map<DropdownMenuItem<String>>((option) {
          //     return DropdownMenuItem<String>(
          //       value: option,
          //       key:
          //           UniqueKey(), // Add a unique key based on the option's value
          //       child: Text(option),
          //     );
          //   }).toList(),
          //   onChanged: (newValue) {
          //     field['value'] = newValue;
          //   },
          //   decoration: InputDecoration(
          //     border: const OutlineInputBorder(),
          //     labelText: field['name'],
          //   ),
          // ),
          SizedBox(
            height: (MediaQuery.of(context).orientation == Orientation.portrait)
                ? 3.h
                : 2.h,
          ),
        ],
      );
    default:
      return Text("DEFAULT");
  }
}
