import 'dart:convert'; // Import for JSON decoding

import 'package:flutter/services.dart' show rootBundle;

Future<List<Map<String, dynamic>>> loadJsonData(String path) async {
  String jsonString = await rootBundle.loadString(path);
  return json.decode(jsonString).cast<Map<String, dynamic>>();
}
