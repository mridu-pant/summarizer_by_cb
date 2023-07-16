
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';

import 'crop_screen.dart';



//List of paths of images and their cropped versions. Defined here so that there is no need to alter them in setState

List <String> croppedImages=[];
List <String> text = [];

class SendTextForSummary{
  SendTextForSummary(this.wordCount, this.text);
  final String text;
  final int wordCount;
}
// A screen that allows users to take a picture using a given camera and then crop and display it (display is temp. Will be sent to ocr).
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
  super.key,
  required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isProcessComplete = false;
  List <String> images=[];
  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.high,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }
  late XFile image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          Expanded(child: _body(),), //refer line 160
        ],
      ),
    );
  }


  Widget _cameraDisplay() {
    double? height = MediaQuery.maybeOf(context)?.size.height;
    // double? width = MediaQuery.maybeOf(context)?.size.width;
    // print("Process Complete? $_isProcessComplete");
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 20),
          //width: MediaQuery.of(context).size.width*0.8,
          height: height!*0.8,
          // width: width,
          // height: MediaQuery.of(context).size.height*0.80,
          child: FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                return CameraPreview(_controller);
              } else {
                // Otherwise, display a loading indicator.
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
        SizedBox(
          height: height!*0.05,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // SizedBox(
            //   width: 30,
            // ),
            ElevatedButton(//on pressing, let's us pick images from gallery
                style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: const Color(0xFF801267),
                    padding: const EdgeInsets.all(20)
                ),
                onPressed: () async {
                  // Pick the Picture from folder
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    allowMultiple: true,
                    type: FileType.custom,
                    allowedExtensions: ['jpg', 'png', 'jpeg'],
                  );
                  if (result != null) {
                    setState(() {
                      for(var i=0; i<result.count; i++){
                        images.add(result.paths[i]!);
                      }
                    });
                  }
                  if(images.isNotEmpty && !_isProcessComplete){
                    croppedImages = await cropAllImages(images);
                    //refer line 155
                    croppedImages = croppedImages;
                    setState(() {
                      _isProcessComplete=true;
                    });
                  }
                },
                child: const Icon(
                    Icons.image
                )
            ),
            // SizedBox(
            //   width: 50,
            // ),
            ElevatedButton( //On clicking, takes picture
                style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: const Color(0xFF801267),
                    padding: const EdgeInsets.all(20)
                ),
                onPressed: () async {
                  SnackBar snackBar = await clickOnCameraButton();
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: const Icon(Icons.camera_alt,)
            ),

            ElevatedButton( //on pressing, let's us crop all images
                style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    //padding: const EdgeInsets.fromLTRB(60, 60, 60, 0)
                    backgroundColor: const Color(0xFF801267),
                    padding: const EdgeInsets.all(20)
                ),
                onPressed: () async {
                  if(images.isNotEmpty && !_isProcessComplete){
                    croppedImages = await cropAllImages(images);
                    //refer line 155
                    croppedImages = croppedImages;
                    setState(() {
                      _isProcessComplete=true;
                      images.clear();
                    });
                  }
                  else{
                    // print("Invalid operation- Take a picture to continue");
                    SnackBar snackBar = const SnackBar(
                        content: Text('Click a picture or pick an image to continue'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: const Icon(
                    Icons.arrow_forward
                )
            ),
          ]
        ),
      ],
    );
  }

  Widget _body(){
    if(!_isProcessComplete){
      //print("Have to take pic");
      return _cameraDisplay(); //refer line 90
    }
    else{
      //print("Pics have been cropped");
      return sendRequest(croppedImages);
    }
  }

  Future<SnackBar> clickOnCameraButton() async {
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      // Ensure that the camera is initialized.
      await _initializeControllerFuture;

      // Attempt to take a picture and get the file `image`
      // where it was saved.
      image = await _controller.takePicture();
      setState(() {
        images.add(image.path); //add path of image taken to the list images
      });
      return const SnackBar(
        content: Text('Image taken!'),
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      // If an error occurs, log the error to the console.
      // print(e);
      return const SnackBar(
        content: Text('Something is wrong. Please try again'),
        duration: Duration(seconds: 2),
      );
    }
  }

}
