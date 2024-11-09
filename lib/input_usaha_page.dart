import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:data_sponsor/usaha_model.dart';
import 'package:data_sponsor/sponsor_repository.dart';

class InputUsahaPage extends StatefulWidget {
  final Usaha? usaha;
  const InputUsahaPage({super.key, this.usaha});

  @override
  _InputUsahaPageState createState() => _InputUsahaPageState();
}

class _InputUsahaPageState extends State<InputUsahaPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  File? selectedImage;
  String? selectedImageBase64;
  List<String> selectedTags = [];
  final List<String> availableTags = ['Makanan', 'Musik', 'Teknologi'];

  UsahaRepository usahaRepository = UsahaRepository();

  @override
  void initState() {
    super.initState();

    // If report already exists, initialize the data
    if (widget.usaha != null) {
      descriptionController.text = widget.usaha!.description;
      titleController.text = widget.usaha!.title;
      selectedTags = List<String>.from(widget.usaha!.tags);

      // For Web, use base64 string
      if (kIsWeb) {
        selectedImageBase64 =
            widget.usaha!.photoPath; // Set base64 string for Web
      } else {
        selectedImage =
            File(widget.usaha!.photoPath); // Existing photo path for Mobile
      }
    }
  }

  // Use file_picker to select an image
  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image, // Only allow image files
    );

    if (result != null) {
      setState(() {
        if (kIsWeb) {
          // Convert selected file to base64 string for Web
          selectedImageBase64 = base64Encode(
              result.files.single.bytes!); // Encode bytes to base64
        } else {
          selectedImage =
              File(result.files.single.path!); // For Mobile, get path
        }
      });
    }
  }

  Future<void> saveUsaha() async {
    if (_formKey.currentState?.validate() ?? false) {
      final description = descriptionController.text;
      final title = titleController.text;

      if (kIsWeb) {
        // For Web, save the base64 string
        if (selectedImageBase64 != null) {
          final report = Usaha(
            id: widget.usaha?.id ?? UniqueKey().toString(),
            title: title,
            description: description,
            tags: selectedTags,
            photoPath: selectedImageBase64!,
          );

          if (widget.usaha == null) {
            await usahaRepository.addUsaha(report);
          } else {
            await usahaRepository.updateUsaha(report);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Mohon pilih logo usaha')),
          );
          return;
        }
      } else {
        // For Mobile, save the path
        if (selectedImage != null) {
          final usaha = Usaha(
            id: widget.usaha?.id ?? UniqueKey().toString(),
            description: description,
            tags: selectedTags,
            photoPath: selectedImage!.path,
            title: title,
          );

          if (widget.usaha == null) {
            await usahaRepository.addUsaha(usaha);
          } else {
            await usahaRepository.updateUsaha(usaha);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Mohon pilih logo laporan')),
          );
        }
      }

      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.usaha == null ? 'Tambah Usaha' : 'Edit Usaha',
          style: TextStyle(
              color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Nama Usaha',
                  hintStyle: TextStyle(
                    color: Colors.black45,
                    fontSize: 15,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    borderSide:
                        BorderSide(color: Color.fromRGBO(89, 89, 89, 1)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama usaha tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: 'Deskripsi Usaha',
                  hintStyle: TextStyle(
                    color: Colors.black45,
                    fontSize: 15,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    borderSide:
                        BorderSide(color: Color.fromRGBO(89, 89, 89, 1)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi usaha tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text('Foto'),
              SizedBox(height: 8.0),
              GestureDetector(
                onTap: _pickImage,
                child: (kIsWeb && selectedImageBase64 != null)
                    ? Image.memory(
                        base64Decode(selectedImageBase64!),
                        height: 150,
                      ) // For Web, display image from base64
                    : (selectedImage != null
                        ? Image.file(selectedImage!,
                            height: 150) // For Mobile, display image file
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey[200],
                            ),
                            height: 150,
                            width: double.infinity,
                            child: Icon(Icons.camera_alt,
                                size: 50, color: Colors.grey[300]),
                          )),
              ),
              SizedBox(height: 16.0),
              Text('Tags'),
              Wrap(
                spacing: 8.0,
                children: availableTags.map((tag) {
                  return ChoiceChip(
                    labelStyle: TextStyle(color: Colors.white),
                    backgroundColor: Colors.grey[300],
                    selectedColor: Colors.blue,
                    label: Text(tag),
                    selected: selectedTags.contains(tag),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedTags.add(tag);
                        } else {
                          selectedTags.remove(tag);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 24.0),
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.blue,
              //       padding: EdgeInsets.symmetric(vertical: 16.0),
              //       textStyle: TextStyle(fontSize: 16),
              //     ),
              //     onPressed: saveUsaha,
              //     child: Text(
              //       widget.usaha == null ? 'Simpan' : 'Perbarui',
              //       style: TextStyle(color: Colors.white),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(
            24, 15, 24, 15), // Jarak dari samping kiri, kanan, dan bawah
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Color(0xFF1EAAFD),
            minimumSize: Size(200, 50), // Ukuran minimum tombol
          ),
          onPressed: saveUsaha,
          child: Text(
            widget.usaha == null ? 'Simpan' : 'Perbarui',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    descriptionController.dispose();
    titleController.dispose();
    super.dispose();
  }
}
