import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function(File image) imagePickFn;

  UserImagePicker(this.imagePickFn);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImageFile;

  void _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.getImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 320,
        maxHeight: 320,
      );
      final pickedImageFile = File(pickedImage.path);
      setState(() => _pickedImageFile = pickedImageFile);
      widget.imagePickFn(_pickedImageFile);
    } catch (err) {
      print('UserImagePick:Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImageFile != null ? FileImage(_pickedImageFile) : null,
        ),
        FlatButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text('Add image'),
          textColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}
