import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onClickedImg});
  final void Function(File img) onClickedImg;
  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _pickedImage;
  void pickImage() async {
    final pickedImg = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
    if (pickedImg == null) {
      return;
    }

    setState(() {
      _pickedImage = File(pickedImg.path);
    });
    widget.onClickedImg(_pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: const Color.fromARGB(116, 68, 137, 255),
          foregroundImage: _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: pickImage,
              style: ButtonStyle(
                foregroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.onPrimary),
              ),
              child: const Row(
                children: [
                  Icon(Icons.image),
                  Text('Add Image'),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
