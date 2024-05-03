import 'package:flutter/material.dart';
import 'package:therAPP/utils/json_file_manager.dart';

class NewPatientScreen extends StatefulWidget {
  /// Route of the page used by the Navigator.
  static const route = "/NewPatientScreen";

  const NewPatientScreen({super.key});

  @override
  NewPatientScreenState createState() => NewPatientScreenState();
}

class NewPatientScreenState extends State<NewPatientScreen> {
  // Variable to store the content of the JSON file
  String templates = '';

  @override
  void initState() {
    super.initState();
    loadJsonData('assets/templates/templates_list.json').then((value) {
      setState(() {
        templates = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: templates.isEmpty
            ? CircularProgressIndicator() // Show loading indicator if data is not loaded yet
            : Text(templates), // Show JSON data as text
      ),
    );
  }

  /// Function called when the user chooses the model to be filled
  ///
  // void _onModelChosen(String filename) {
  // ScaffoldMessenger.of(context).removeCurrentSnackBar();
  // setState(() {
  //   FocusScope.of(context).unfocus();
  //   _currentIndex = index;
  // });
  // }
}
