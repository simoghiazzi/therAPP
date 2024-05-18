import 'dart:io';
import 'package:flutter/material.dart';
import 'package:therAPP/views/Utils/top_bar.dart';
import 'package:path/path.dart' as path;

class AllPatientsBody extends StatefulWidget {
  final List<Directory> patientsDirectories;
  final String barText;

  const AllPatientsBody(
      {super.key, required this.patientsDirectories, required this.barText});

  @override
  AllPatientsBodyState createState() => AllPatientsBodyState();
}

class AllPatientsBodyState extends State<AllPatientsBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopBar(
          text: widget.barText,
        ),
        Expanded(
          child: widget.patientsDirectories.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.patientsDirectories.length,
                  itemBuilder: (context, index) {
                    String dirName =
                        path.basename(widget.patientsDirectories[index].path);
                    return Card(
                      child: ListTile(
                        title: Text(dirName),
                        onTap: () {
                          // Handle the tap event, e.g., navigate to another screen
                          print('Tapped on $dirName');
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
