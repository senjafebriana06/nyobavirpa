import 'dart:convert' as convert;
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:nyobavirpa/main.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FrontBodyImage extends StatefulWidget {
  final String imagePath;

  const FrontBodyImage({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<FrontBodyImage> createState() => _FrontBodyImageState();
}

class _FrontBodyImageState extends State<FrontBodyImage> {
  SharedPreferences? prefs;

  String? processedImageUrl;
  bool isImageProcessed = false;

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
        if (isImageProcessed)
          Image.network(processedImageUrl!, loadingBuilder:
              (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          }),
        if (!isImageProcessed) Image.file(File(widget.imagePath)),
        ElevatedButton(
            onPressed: () async {
              if (!isImageProcessed) {
                context.read<BsaState>().setB = true;

                prefs = await SharedPreferences.getInstance();
                String? id = await prefs?.getString("id");
                String? result = await uploadImage(
                    File(widget.imagePath), 'frontBody', id ?? '');
                await firestore
                    .collection('users')
                    .doc(id)
                    .update({'frontBody': result});

                var url =
                    Uri.parse('https://virpaflaskapp.azurewebsites.net/front');
                var response = await http.post(url,
                    body: {'id': id, 'image_name': basename(widget.imagePath)});
                var jsonResponse =
                    convert.jsonDecode(response.body) as Map<String, dynamic>;

                context.read<BsaState>().setBVal = jsonResponse['b'];

                setState(() {
                  isImageProcessed = true;
                  processedImageUrl = jsonResponse['result'];
                });
              } else {
                Navigator.of(context).pop(3);
              }
            },
            child: Text('Lanjut')),
      ]),
    );
  }
}
