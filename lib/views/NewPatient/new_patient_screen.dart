import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:therAPP/utils/json_file_manager.dart';
import 'package:therAPP/views/NewPatient/components/new_patient_body.dart';

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
        // chosenFile = fileToLoad;
        Map<String, dynamic> chosenModel = json.decode(jsonString);
        chosenModel.forEach((key, value) {
          List<Map<String, dynamic>> items =
              List<Map<String, dynamic>>.from(value);
          for (var item in items) {
            if (item['type'] == 4) {
              item['values'] = [];
            } else if (item['type'] == 5) {
              item['value'] = item['options'][0];
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

  void nextStep() {
    setState(() {
      step += 1;
      barTitle = "Anamnesi del paziente";
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
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return NewPatientBody(
              templates: snapshot.data!,
              chosenFile: chosenFile,
              updateChosenFile: updateChosenFile,
              newUserModel: newUserModel,
              step: step,
              nextStep: nextStep,
              previousStep: previousStep,
              barText: barTitle,
            );
          }
        },
      ),
    );
  }
}
