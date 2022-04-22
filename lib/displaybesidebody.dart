import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BesideBodyImage extends StatefulWidget {
  final String imagePath;

  const BesideBodyImage({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<BesideBodyImage> createState() => _BesideBodyImageState();
}

class _BesideBodyImageState extends State<BesideBodyImage> {

  SharedPreferences? prefs;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  Future<String?> uploadImage(File image, String type, String id) async {
    firebase_storage.UploadTask task;

    task = firebase_storage.FirebaseStorage.instance
        .ref('images/$id/$type/${basename(image.path)}')
        .putFile(image);

    task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
      print('Task state: ${snapshot.state}');
      print(
          'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
    }, onError: (e) {
      print(task.snapshot);

      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    });

    try {
      var dowurl = await (await task).ref.getDownloadURL();
      return dowurl.toString();
    } on firebase_core.FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Column(children: [
        Image.file(File(widget.imagePath)),
        ElevatedButton(onPressed: ()async {
          prefs = await SharedPreferences.getInstance();
          String? id = await prefs?.getString("id");
          String? result = await uploadImage(File(widget.imagePath), 'besideBody', id ?? '');

          await firestore.collection('users').doc(id).update({'besideBody': result});

          Navigator.of(context).pop(3);
        }, child: Text('Submit'))
      ]),
    );
  }
}
