import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

import 'theme.dart';

class ImagePickerExample extends StatefulWidget {
  @override
  _ImagePickerExampleState createState() => _ImagePickerExampleState();
}

class _ImagePickerExampleState extends State<ImagePickerExample> {
  File _image;
  final picker = ImagePicker();

  Future getImage(ImageSource imageSource) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    print(pickedFile.path);

    print("Media type: ${MediaType.parse(lookupMimeType(pickedFile.path))}");
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Center(
        child: ListView(physics: BouncingScrollPhysics(), children: [
          _image == null
              ? Text(
                  'No image selected.',
                  textAlign: TextAlign.center,
                )
              : Image.file(_image),
          CuliButton("Gallery",
              onPressed: () async => getImage(ImageSource.gallery)),
          CuliButton("Camera",
              onPressed: () async => getImage(ImageSource.camera)),
        ]),
      ),
    );
  }
}
