import 'package:flutter/services.dart' show rootBundle;

Future<String> loadJsonData(String path) async {
  return await rootBundle.loadString(path);
}
