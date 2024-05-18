import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:therAPP/views/AllPatients/components/all_patients_body.dart';

Future<List<Directory>> listDirectories(String path) async {
  Directory directory = Directory(path);
  List<Directory> directories = [];

  if (await directory.exists()) {
    await for (var entity in directory.list()) {
      if (entity is Directory) {
        directories.add(entity);
      }
    }
  }

  return directories;
}

class AllPatientsScreen extends StatefulWidget {
  static const route = "/AllPatientsScreen";

  const AllPatientsScreen({super.key});

  @override
  AllPatientsScreenState createState() => AllPatientsScreenState();
}

class AllPatientsScreenState extends State<AllPatientsScreen> {
  List<Directory> patientsDirectories = [];

  @override
  void initState() {
    super.initState();
    _fetchDirectories();
  }

  Future<void> _fetchDirectories() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String patientsDirPath = path.join(appDir.path, 'patients');
    List<Directory> directories = await listDirectories(patientsDirPath);

    setState(() {
      patientsDirectories = directories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AllPatientsBody(
            patientsDirectories: patientsDirectories,
            barText: "LISTA PAZIENTI"));
  }
}
