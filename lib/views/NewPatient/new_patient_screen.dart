import 'package:flutter/material.dart';
import 'package:therAPP/utils/json_file_manager.dart';
import 'package:therAPP/views/NewPatient/components/new_patient_body.dart';

class NewPatientScreen extends StatefulWidget {
  static const route = "/NewPatientScreen";

  const NewPatientScreen({Key? key}) : super(key: key);

  @override
  NewPatientScreenState createState() => NewPatientScreenState();
}

class NewPatientScreenState extends State<NewPatientScreen> {
  late Future<List<Map<String, dynamic>>> _templatesFuture;
  late String _chosenFile = "";

  @override
  void initState() {
    super.initState();
    _templatesFuture = loadJsonData('assets/templates/templates_list.json');
  }

  void updateChosenFile(String newName) {
    setState(() {
      _chosenFile = newName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _templatesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return NewPatientBody(
              templates: snapshot.data!,
              chosenFile: _chosenFile,
              updateChosenFile: updateChosenFile,
            );
          }
        },
      ),
    );
  }
}
