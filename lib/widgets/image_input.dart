import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  ImageInput(
    this.onSelectImage,
  );

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;
  final picker = ImagePicker();

  Future _takenPicture() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );
    final fileImage = File(pickedFile.path);
    setState(() {
      _storedImage = fileImage;
    });

    Directory appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;

    final fileName = path.basename(pickedFile.path);
    final saveImage = await fileImage.copy('$appDocPath/$fileName');

    widget.onSelectImage(saveImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 100,
          width: 150,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          alignment: Alignment.center,
          child: _storedImage != null
              ? Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: FlatButton.icon(
            onPressed: _takenPicture,
            icon: Icon(Icons.camera_alt),
            label: Text('Take a Picture'),
            textColor: Theme.of(context).primaryColor,
          ),
        )
      ],
    );
  }
}
