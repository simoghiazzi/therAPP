import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:therAPP/views/Utils/constants.dart';
import 'package:therAPP/views/Utils/top_bar.dart';

class DirectoryContentScreen extends StatelessWidget {
  final Directory directory;

  const DirectoryContentScreen({super.key, required this.directory});

  @override
  Widget build(BuildContext context) {
    List<File> jsonFiles = directory
        .listSync()
        .where((file) => file.path.endsWith('.json'))
        .map((file) => File(file.path))
        .toList();

    return Scaffold(
      body: Column(
        children: [
          TopBar(
            text: path.basename(directory.path),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: jsonFiles.length,
              itemBuilder: (context, index) {
                String fileName = path.basename(jsonFiles[index].path);
                String date = fileName.split('.').first;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 2.0,
                    shadowColor: kPrimaryColor.withOpacity(0.5),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 15.0,
                      ),
                      leading: const Icon(
                        Icons.description,
                        color: kPrimaryColor, // Adjust as needed
                      ),
                      title: Text(
                        date,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: kPrimaryColor, // Adjust as needed
                      ),
                      onTap: () {
                        // Handle the tap event if needed
                        print('Tapped on $fileName');
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
