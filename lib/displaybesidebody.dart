import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:nyobavirpa/main.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "dart:math" show pi;

class SideBodyImage extends StatefulWidget {
  final String imagePath;

  const SideBodyImage({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<SideBodyImage> createState() => _SideBodyImageState();
}

class _SideBodyImageState extends State<SideBodyImage> {
  SharedPreferences? prefs;

  String? processedImageUrl;
  bool isImageProcessed = false;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  double getWeight(double a, double b, double t) {
    double bsa = (pi / 2) * ((a * b) + ((a + b) * t)) * 1.32 * 0.0001;
    return bsa * bsa * 3600 / t;
  }

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
        if (context.read<BsaState>().a_set && context.read<BsaState>().b_set)
          Text(
              "Berat badan ${getWeight(context.read<BsaState>().a, context.read<BsaState>().b, context.read<BsaState>().t)}"),
        if (context.read<BsaState>().a_set && context.read<BsaState>().b_set)
          Text("Tinggi badan ${context.read<BsaState>().t}"),
        ElevatedButton(
            onPressed: () async {
              if (!isImageProcessed) {
                prefs = await SharedPreferences.getInstance();
                String? id = await prefs?.getString("id");
                String? result = await uploadImage(
                    File(widget.imagePath), 'besideBody', id ?? '');
                await firestore
                    .collection('users')
                    .doc(id)
                    .update({'besideBody': result});

                var url =
                    Uri.parse('https://virpaflaskapp.azurewebsites.net/side');
                var response = await http.post(url,
                    body: {'id': id, 'image_name': basename(widget.imagePath)});
                print(response.body);
                var jsonResponse =
                    convert.jsonDecode(response.body) as Map<String, dynamic>;

                context.read<BsaState>().setAVal = jsonResponse['a'];
                context.read<BsaState>().setTVal = jsonResponse['t'];
                context.read<BsaState>().setA = true;
                setState(() {
                  isImageProcessed = true;
                  processedImageUrl = jsonResponse['result'];
                });
              } else {
                Navigator.of(context).pop(3);
                context.read<BsaState>().reset();
              }
            },
            child: Text('Lanjut'))
      ]),
    );
  }
}
