import 'package:flutter/material.dart';
import 'package:therAPP/utils/render_module_field.dart';
import 'package:therAPP/views/Home/components/rounded_button.dart';
import 'dart:convert';
import 'package:therAPP/views/Utils/custom_sizer.dart';
import 'package:therAPP/views/Utils/top_bar.dart';

class JsonContentScreen extends StatefulWidget {
  final String fileName;
  final String jsonContent;
  final IconData modifyIcon;

  const JsonContentScreen({
    super.key,
    required this.fileName,
    required this.jsonContent,
    this.modifyIcon = Icons.edit,
  });

  @override
  _JsonContentScreenState createState() => _JsonContentScreenState();
}

class _JsonContentScreenState extends State<JsonContentScreen> {
  int step = 1;
  bool loading = false;

  void _handleGoBack() {
    if (step > 1) {
      setState(() {
        step -= 1;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = json.decode(widget.jsonContent);

    // Remove ".json" from fileName
    String displayFileName = widget.fileName.replaceAll('.json', '');

    return Scaffold(
      body: Column(
        children: [
          TopBar(
            text: displayFileName,
            goBack: _handleGoBack,
            buttons: step == 1
                ? [
                    Container(
                      margin:
                          EdgeInsets.only(right: 3.w), // Add right margin here
                      child: InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          step += 1;
                        },
                        child: Icon(widget.modifyIcon,
                            color: Colors.white, size: 25),
                      ),
                    )
                  ]
                : [],
          ),
          Expanded(
            child: step > 1
                ? SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...data.entries.expand((entry) {
                            List<Widget> entryWidgets = [];
                            if (entry.key != "Anagrafica") {
                              entryWidgets.add(
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    entry.key.toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ),
                              );
                            }

                            entryWidgets.add(SizedBox(
                              height: (MediaQuery.of(context).orientation ==
                                      Orientation.portrait)
                                  ? 2.h
                                  : 1.h,
                            ));

                            if (entry.value is List) {
                              entryWidgets.addAll(
                                (entry.value as List).map<Widget>((item) {
                                  if (item is Map &&
                                      item['name'] != "Nome" &&
                                      item['name'] != "Cognome" &&
                                      item['name'] != "Età") {
                                    return Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                            width: 130.w,
                                            child: RenderModuleField(
                                                field: item)));
                                  }
                                  return const SizedBox.shrink();
                                }).toList(),
                              );
                            }

                            return entryWidgets;
                          }),
                          Align(
                            alignment: Alignment.center,
                            child: loading
                                ? CircularProgressIndicator()
                                : RoundedButton(
                                    text: "CONFERMA",
                                    onTap: () {
                                      loading = true;
                                      // widget.nextStep();
                                    },
                                  ),
                          ),
                          SizedBox(
                            height: (MediaQuery.of(context).orientation ==
                                    Orientation.portrait)
                                ? 4.h
                                : 3.h,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: data.keys.length,
                    itemBuilder: (context, index) {
                      String category = data.keys.elementAt(index);
                      List<dynamic> items = data[category];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              category,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 3.h),
                          ...items.map((item) {
                            String displayText;
                            if (item['type'] == 4) {
                              displayText =
                                  '${item['name']}: ${item['values'].join(', ')}';
                            } else {
                              // Display an empty string if item['value'] is null
                              dynamic value = item['value'] ?? '';
                              displayText = '${item['name']}: $value';
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayText,
                                  style: TextStyle(
                                    fontSize: 8.sp,
                                    color: Colors.black,
                                  ),
                                ),
                                if (item['notes'] != null &&
                                    item['notes']!.isNotEmpty) ...[
                                  Text(
                                    'Note: ${item['notes']}',
                                    style: TextStyle(
                                      fontSize: 7.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                ],
                              ],
                            );
                          }).toList(),
                          const SizedBox(height: 16.0),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
