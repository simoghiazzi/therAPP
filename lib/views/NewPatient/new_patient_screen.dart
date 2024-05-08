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
  late Future<List<Map<String, dynamic>>> _templatesFuture;
  late Future<String> _chosenFileFuture;

  @override
  void initState() {
    super.initState();
    _templatesFuture = loadJsonData('assets/templates/templates_list.json');
    _chosenFileFuture = _templatesFuture
        .then((value) => value.isNotEmpty ? value.first["file"] : "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Future.wait([_templatesFuture, _chosenFileFuture]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading data"));
          } else {
            List<Map<String, dynamic>> templates = snapshot.data![0];

            return NewPatientBody(
              templates: templates,
            );
          }
        },
      ),
    );
  }
}
