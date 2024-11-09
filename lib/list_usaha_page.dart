import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:data_sponsor/input_usaha_page.dart';
import 'sponsor_repository.dart';
import 'usaha_model.dart';

class ListUsahaPage extends StatefulWidget {
  const ListUsahaPage({Key? key}) : super(key: key);

  @override
  _ListUsahaPageState createState() => _ListUsahaPageState();
}

class _ListUsahaPageState extends State<ListUsahaPage> {
  final UsahaRepository _repository = UsahaRepository();
  List<Usaha> _usahas = [];

  @override
  void initState() {
    super.initState();
    _loadUsahas();
  }

  Future<void> _loadUsahas() async {
    final usahas = await _repository.getUsaha();
    setState(() {
      _usahas = usahas;
    });
  }

  Future<void> _deleteUsaha(Usaha usaha) async {
    // Confirm delete action
    final bool? shouldDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi hapus'),
          content: Text('Yakin akan menghapus usaha?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel delete
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm delete
              },
            ),
          ],
        );
      },
    );

    // If the user confirmed, delete the report
    if (shouldDelete == true) {
      await _repository.deleteUsaha(usaha.id); // Perform deletion
      _loadUsahas(); // Reload reports after deletion
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'List Data Usaha',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black54),
          ),
          const SizedBox(height: 16), // Space between title and list
          Expanded(
            child: ListView.builder(
              itemCount: _usahas.length,
              itemBuilder: (context, index) {
                final usaha = _usahas[index];

                // Check if photoPath is available, and show either the image or a placeholder text
                Widget leadingWidget;

                if (usaha.photoPath != null && usaha.photoPath!.isNotEmpty) {
                  if (kIsWeb) {
                    // Web platform: use base64 string and display with Image.memory
                    String base64String = usaha.photoPath ?? '';

                    leadingWidget = base64String.isNotEmpty
                        ? Image.memory(
                            base64Decode(
                                base64String), // Decode the cleaned base64 string
                            width: 40, // Adjust the size as needed
                            height: 40,
                            fit: BoxFit.cover,
                          )
                        : Text(
                            'Belum ada data',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          );
                  } else {
                    // Mobile/Desktop platform: use Image.file
                    leadingWidget = Image.file(
                      File(usaha.photoPath!),
                      width: 40, // Adjust the size as needed
                      height: 40,
                      fit: BoxFit.cover,
                    );
                  }
                } else {
                  leadingWidget = Text(
                    'Belum ada data',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  );
                }

                return Card(
                  elevation: 4,
                  shadowColor: Colors.transparent,
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: leadingWidget, // Display the image or text
                    title: Text(usaha.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${usaha.description}"),
                        Text('Tags: ${usaha.tags.join(', ')}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edit Button
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.black54),
                          onPressed: () {
                            // Navigate to InputReportPage for editing
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InputUsahaPage(
                                    usaha:
                                        usaha), // Pass the report to the edit page
                              ),
                            ).then((_) {
                              // Reload reports after returning from InputReportPage
                              _loadUsahas();
                            });
                          },
                        ),
                        // Delete Button
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteUsaha(usaha);
                          },
                        ),
                      ],
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
