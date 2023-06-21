import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dropdown_values.dart';

class AssetEntryPage extends StatefulWidget {
  const AssetEntryPage({Key? key}) : super(key: key);

  @override
  _AssetEntryPageState createState() => _AssetEntryPageState();
}

class _AssetEntryPageState extends State<AssetEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _picker = ImagePicker();
  File? _imageFile;
  List<String> _selectedTypes = [''];
  final _dropdownValues = dropdownValues;
  final Map<String, List<String>> _categoryTypes = categoryTypes;

  final _formData = {
    'Select Category': '',
    'Select Type': '',
    // 'Age': '',
    'Current Location': '',
    'Unit Number': '',
  };

  Future<void> _pickImage(ImageSource source) async {
    final XFile? selected = await _picker.pickImage(source: source);
    if (selected != null) {
      setState(() {
        _imageFile = File(selected.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asset Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height *
                    0.1, // 30% of screen height
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/westway.png'),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              for (var dropdown in _dropdownValues.entries)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: _buildDropdownButton(
                    hint: dropdown.key,
                    value: _formData[dropdown.key]!,
                    items: dropdown.key == 'Select Type'
                        ? _selectedTypes
                        : dropdown.value,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: _buildTextField(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 17),
                child: _imageFile != null
                    ? Image.file(_imageFile!)
                    : Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text('No image selected.'),
                        ),
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.photo_library_outlined, size: 39),
                    color: const Color.fromARGB(255, 0, 0, 0),
                    onPressed: () => _pickImage(ImageSource.gallery),
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo_camera_outlined, size: 39),
                    color: const Color.fromARGB(255, 0, 0, 0),
                    onPressed: () => _pickImage(ImageSource.camera),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: _buildSaveButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DropdownButtonFormField<String> _buildDropdownButton({
    required String hint,
    required String value,
    required List<String> items,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: hint,
      ),
      value: value.isEmpty ? null : value,
      onChanged: (String? value) {
        setState(() {
          _formData[hint] = value!;
          if (hint == 'Select Category' && value != '') {
            _selectedTypes = _categoryTypes[value]!;
          }
        });
      },
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      // validator: (value) {
      //   if (value == null || value.isEmpty) {
      //     return 'Please select a $hint';
      //   }
      //   return null;
      // },
    );
  }

  TextFormField _buildTextField() {
    return TextFormField(
      onChanged: (value) {
        _formData['Unit Number'] = value;
      },
      decoration: const InputDecoration(
        labelText: 'Unit Number',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter unit number';
        }
        return null;
      },
    );
  }

  Padding _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Processing Data')),
            );
            await _firestore
                .collection('assets')
                .doc(_formData['Unit Number'])
                .set({
              'createdAt': Timestamp.now(),
              'currentLocation': _formData['Current Location'],
              'age': _formData['Age'],
              'category': _formData['Select Category'],
              'type': _formData['Select Type'],
            });

            if (_imageFile != null) {
              var snapshot = await _storage
                  .ref()
                  .child('assets/${_formData['Unit Number']}.png')
                  .putFile(_imageFile!);
              var downloadUrl = await snapshot.ref.getDownloadURL();
              await _firestore
                  .collection('assets')
                  .doc(_formData['Unit Number'])
                  .update({'imageUrl': downloadUrl});
            }
          }
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blueGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 12),
        ),
        child: const Text('Save'),
      ),
    );
  }
}
