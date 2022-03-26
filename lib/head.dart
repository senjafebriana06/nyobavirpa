import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'displayimage.dart';
import 'main.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   cameras = await availableCameras();
//   runApp(const BodyCamera());
// }

class HeadCamera extends StatefulWidget {
  final bool isCameraOverlayCircle;

  const HeadCamera({Key? key, required this.isCameraOverlayCircle})
      : super(key: key);

  @override
  _HeadCameraState createState() => _HeadCameraState();
}

class _HeadCameraState extends State<HeadCamera> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CameraController controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.high);
    _initializeControllerFuture = controller.initialize();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Stack(fit: StackFit.expand, children: [
              CameraPreview(controller),
              //pengecekan bentuk camera overlay

              cameraOverlayCircle(
                  padding: 50, aspectRatio: 1, color: Color(0x55000000))
            ]);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and then get the location
            // where the image file is saved.
            // final image = await controller.takePicture();
            await controller.takePicture().then((value) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DisplayImage(
                        imagePath: value.path,
                      )));
            });
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  Widget cameraOverlayCircle(
      {required double padding,
      required double aspectRatio,
      required Color color}) {
    return LayoutBuilder(builder: (context, constraints) {
      double parentAspectRatio = constraints.maxWidth / constraints.maxHeight;
      double horizontalPadding;
      double verticalPadding;

      if (parentAspectRatio < aspectRatio) {
        horizontalPadding = padding;
        verticalPadding = (constraints.maxHeight -
                ((constraints.maxWidth - 2 * padding) / aspectRatio)) /
            2;
      } else {
        verticalPadding = padding;
        horizontalPadding = (constraints.maxWidth -
                ((constraints.maxHeight - 2 * padding) * aspectRatio)) /
            2;
      }
      return Stack(
        children: <Widget>[
          IgnorePointer(
            child: ClipPath(
              clipper: InvertedCircleClipper(),
              child: Container(
                color: const Color.fromRGBO(0, 0, 0, 0.5),
              ),
            ),
          )
        ],
      );
    });
  }
}

class InvertedCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..addOval(Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width * 0.45))
      ..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
