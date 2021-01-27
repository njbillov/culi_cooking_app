import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'data_manipulation/gql_interface.dart';
import 'theme.dart';
import 'utilities.dart';

class UploadTestScreen extends StatelessWidget {
  void pressButton() async {
    final filename = "assets/images/keto_avocado_bowl.jpeg";

    var imageBytesData = await rootBundle.load(filename);
    var imageBytes = imageBytesData.buffer.asUint8List();
    print("Read in image");
    // final filename = '${DateTime.now().millisecondsSinceEpoch}-${hashList(imageBytes)}';
    print("Created filename $filename");
    final mediaType = MediaType.parse(lookupMimeType(filename));
    log('mediaType: $mediaType');
    var fileUpload = MultipartFile.fromBytes('photo', imageBytes,
        filename: filename, contentType: mediaType);
    print("Made multipart file upload");
    final mutation = r'''
      mutation uploadFile($file: Upload!) { 
        upload(file: $file) {
          ok
        }
      }''';
    print("Created mutation query string");
    var results =
        await GraphQLWrapper.mutate(mutation, variables: {'file': fileUpload});
    if (results == null) {
      print("Operation failed");
    } else {
      print(results['upload']['ok']
          ? "Completed mutation remotely"
          : "Failed to complete remote mutation");
    }
    log(results.toString());
  }

  Future<CameraDescription> takePicture() async {
    final cameras = await availableCameras();

    final backCamera = cameras.firstWhere(
        (element) => element.lensDirection == CameraLensDirection.front);
    log(cameras.join(" "));
    return backCamera;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Test"),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          CuliButton(
            "Test upload",
            onPressed: pressButton,
          ),
          CuliButton("Take a picture", onPressed: () async {
            final camera = await takePicture();
            log(camera.lensDirection.toString());
            return Utils.changeScreens(
              context: context,
              nextWidget: () => TakePictureScreen(camera: camera),
              // squash: true,
            );
          })
        ],
      )),
    );
  }
}

// A screen that allows users to take a picture using a given camera.
// TODO test after getting on-device stuff working because the camera doesn't work in simulator.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
      enableAudio: false,
    );
    // _controller.takePicture().then((value) => log('picture taken'));
    // Next, initialize the controller. This returns a Future.
    try {
      _initializeControllerFuture = _controller
          .initialize()
          // .timeout(Duration(seconds: 10))
          .then((value) => log('controllers initialized'));
    } on CameraException catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          // log('Camera initialization future completed');
          // log('$snapshot');
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.

            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            log("trying to take a picture");
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            log("took a picture");
            // Construct the path where the image should be saved using the
            // pattern package.
            // final path = join(
            //   // Store the picture in the temp directory.
            //   // Find the temp directory using the `path_provider` plugin.
            //   (await getTemporaryDirectory()).path,
            //   '${DateTime.now()}.png',
            // );

            // Attempt to take a picture and log where it's been saved.
            _controller.setFlashMode(FlashMode.off);
            final outputImage = await _controller.takePicture();

            final imageBytes = await outputImage.readAsBytes();

            log('${outputImage.path}');

            final result = await ImageGallerySaver.saveImage(imageBytes,
                isReturnImagePathOfIOS: true);

            for (var val in result.entries) {
              print(val.toString());
            }

            log(result.toString());

            log('${result['success']}');

            final uri = Uri.parse(result['filePath'] as String);
            log('Mime type: ${lookupMimeType(uri.toFilePath())}');

            // final path = outputPath.path;
            // If the picture was taken, display it on a new screen.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                    path: uri.toFilePath(),
                    image: XFile.fromData(imageBytes, path: uri.toFilePath())),
              ),
            );
            // ignore: avoid_catches_without_on_clauses
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final XFile image;
  final String path;

  const DisplayPictureScreen({Key key, this.image, this.path})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // log('${image.mimeType}');
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(path ?? image.path)),
    );
  }
}
