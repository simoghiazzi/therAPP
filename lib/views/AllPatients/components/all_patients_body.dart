import 'dart:io';
import 'package:flutter/material.dart';
import 'package:therAPP/views/AllPatients/components/directory_content.dart';
import 'package:therAPP/views/Utils/constants.dart';
import 'package:therAPP/views/Utils/custom_sizer.dart';
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
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 2.h,
                            horizontal: 5.w,
                          ),
                          leading: const Icon(
                            Icons.folder,
                            color: kPrimaryColor,
                          ),
                          title: Text(
                            dirName,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: kPrimaryColor,
                          ),
                          onTap: () {
                            // Navigate to the new screen and pass the selected directory
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DirectoryContentScreen(
                                  directory: widget.patientsDirectories[index],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
