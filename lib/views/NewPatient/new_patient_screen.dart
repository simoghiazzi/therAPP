import 'package:flutter/material.dart';
import 'package:therAPP/utils/json_file_manager.dart';
import 'package:therAPP/views/NewPatient/components/new_patient_body.dart';

class NewPatientScreen extends StatefulWidget {
  /// Route of the page used by the Navigator.
  static const route = "/NewPatientScreen";

  const NewPatientScreen({super.key});

  @override
  NewPatientScreenState createState() => NewPatientScreenState();
}

class NewPatientScreenState extends State<NewPatientScreen> {
  // Variable to store the list of JSON items
  List<Map<String, dynamic>> templates = [];

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
    return const Center(
      child: NewPatientBody(),
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
