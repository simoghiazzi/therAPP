import 'package:flutter/material.dart'; // Import for JSON decoding

Widget renderModuleField(dynamic field) {
  return Text(
    'Item: ${field['name']}; Value: ${field['value']}; Notes: ${field['notes']};',
    style: const TextStyle(fontSize: 14),
  );
}
