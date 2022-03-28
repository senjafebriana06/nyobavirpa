import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nyobavirpa/menu.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class DisplayImage extends StatefulWidget {
  final String imagePath;

  const DisplayImage({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<DisplayImage> createState() => _DisplayImageState();
}

class _DisplayImageState extends State<DisplayImage> {
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
      body: SingleChildScrollView(
          child: Column(children: [
        Image.file(File(widget.imagePath)),
        ElevatedButton(
            onPressed: () async {
              prefs = await SharedPreferences.getInstance();
              String? id = await prefs?.getString("id");
              String? result =
                  await uploadImage(File(widget.imagePath), 'head', id ?? '');

              await firestore
                  .collection('users')
                  .doc(id)
                  .update({'head': result});
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => MenuPage()),
                  (Route<dynamic> route) => false);
            },
            child: Text('Submit'))
      ])),
    );
  }
}
