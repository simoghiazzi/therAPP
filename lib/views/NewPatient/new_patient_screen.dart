import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:ANAMNEASY/utils/json_file_manager.dart';
import 'dart:convert';
import 'dart:io';

import 'package:ANAMNEASY/views/NewPatient/components/new_patient_body.dart';

class NewPatientScreen extends StatefulWidget {
  static const route = "/NewPatientScreen";

  const NewPatientScreen({super.key});

  @override
  NewPatientScreenState createState() => NewPatientScreenState();
}

class NewPatientScreenState extends State<NewPatientScreen> {
  late Future<List<Map<String, dynamic>>> _templatesFuture;
  late String chosenFile = "";
  late Map<String, dynamic> newUserModel = {};
  int step = 1;
  String barTitle = "Seleziona modello";
  bool showNoNameError = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _templatesFuture = loadJsonData('assets/templates/templates_list.json');
    initModel();
  }

  void initModel() async {
    final List<Map<String, dynamic>> templates = await _templatesFuture;
    String fileToLoad = templates[0]['file'];
    try {
      String jsonString =
          await rootBundle.loadString('assets/templates/$fileToLoad');
      setState(() {
        Map<String, dynamic> chosenModel = json.decode(jsonString);
        chosenModel.forEach((key, value) {
          List<Map<String, dynamic>> items =
              List<Map<String, dynamic>>.from(value);
          for (var item in items) {
            if (item['type'] == 4) {
              item['values'] = [];
            } else if (item['type'] == 5) {
              item['value'] = item['options'][0];
            } else if (item['type'] == 6) {
              List<dynamic> options = item['options'];
              for (var option in options) {
                option['value'] = "";
                option['notes'] = "";
              }
            } else {
              item['value'] = "";
            }
            item['notes'] = "";
          }
          newUserModel[key] = items;
        });
      });
    } catch (e) {
      // Handle the error
      print('Error loading file: $e');
    }
  }

  void updateChosenFile(String newName) async {
    final List<Map<String, dynamic>> templates = await _templatesFuture;
    String fileToLoad = "";
    for (var template in templates) {
      if (template['name'] == newName) {
        fileToLoad = template['file'];
      }
    }

    try {
      String jsonString =
          await rootBundle.loadString('assets/templates/$fileToLoad');
      setState(() {
        chosenFile = fileToLoad;
        Map<String, dynamic> chosenModel = json.decode(jsonString);
        chosenModel.forEach((key, value) {
          List<Map<String, dynamic>> items =
              List<Map<String, dynamic>>.from(value);
          for (var item in items) {
            if (item['type'] == 4) {
              item['values'] = [];
            } else {
              item['value'] = "";
            }
            item['notes'] = "";
          }
          newUserModel[key] = items;
        });
      });
    } catch (e) {
      // Handle the error
      print('Error loading file: $e');
    }
  }

  Future<void> nextStep(BuildContext context) async {
    setState(() {
      loading = true;
    });
    if (step == 2 &&
        newUserModel['Anagrafica'][0]['value'] != "" &&
        newUserModel['Anagrafica'][1]['value'] != "") {
      Directory appDocDir = await getApplicationDocumentsDirectory();

      //Create Patients directory if it does not exist
      String targetPathPatients = path.join(appDocDir.path, 'patients');
      Directory targetDirPatients = Directory(targetPathPatients);
      if (!await targetDirPatients.exists()) {
        await targetDirPatients.create(recursive: true);
      }

      //Create the visit document
      String targetPath = path.join(
          appDocDir.path,
          'patients/${newUserModel['Anagrafica'][0]['value']} '
          '${newUserModel['Anagrafica'][1]['value']}');

      // Check if the directory exists, if not, create it
      Directory targetDir = Directory(targetPath);
      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
      }

      String fileName =
          '${DateTime.now().toIso8601String().split('T').first}.json';
      String filePath = path.join(targetPath, fileName);

      // Write the JSON file
      try {
        File file = File(filePath);
        await file.writeAsString(jsonEncode(newUserModel), flush: true);
        // Pop the current page
        Navigator.of(context).pop();
      } catch (e) {
        print("ERROR: $e");
      }
    }
    setState(() {
      loading = false;
      if (step < 2) {
        step += 1;
        barTitle = "Anamnesi del paziente";
      } else if (newUserModel['Anagrafica'][0]['value'] == "" ||
          newUserModel['Anagrafica'][1]['value'] == "") {
        showNoNameError = true;
      }

      if (step == 2) {}
    });
  }

  void previousStep() {
    setState(() {
      step -= 1;
      barTitle = "Seleziona modello";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _templatesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return NewPatientBody(
              templates: snapshot.data!,
              chosenFile: chosenFile,
              updateChosenFile: updateChosenFile,
              newUserModel: newUserModel,
              step: step,
              nextStep: () => nextStep(context),
              previousStep: previousStep,
              barText: barTitle,
              showNoNameError: showNoNameError,
              loading: loading,
            );
          }
        },
      ),
    );
  }
}
