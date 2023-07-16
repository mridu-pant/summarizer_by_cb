import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:summary_app/screens/summary_display.dart';
import 'loading_page.dart';
import 'package:http/http.dart' as http;




String OCR_result = '';
bool OCR_complete = false;
String summary = '';
bool summary_complete = false;

CroppedFile? _croppedImg;

Future<List<String>> cropAllImages(List<String>imgpaths) async {
  List <String> croppedImages=[];
  //print("ALERT!!! In function 'cropAllImages");
  await _cropImage(imgpaths, croppedImages);
  //print("All cropped!");
  return croppedImages;

}

Future<void> deleteImg(File file) async{
  try{
    if (await file.exists()){
      await file.delete();
    }
  } catch (e){
    //print("Deletion error");
  }
}

Future<void> _cropImage(List<String> images, List<String>croppedImages) async {
  //print("ALERT!!! In function '_cropImage");
  int i=0;
  while(i<images.length){
    final pickedImg = XFile(images[i]);
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedImg.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          //toolbarTitle: 'Cropper',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: const Color(0xFF801267),
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
      ],
    );
    croppedImages.add(croppedFile!.path);
    //images.remove(images[i]);
    if (_croppedImg != null) {
      _croppedImg = croppedFile;
    }
    // deleteImg(File(pickedImg.path));
    i++;
  }
  images.clear();
  //int imglen = images.length;
  //int cropinglen = croppedImages.length;
  //print("images list size:$imglen");
  //print("cropped images list size:$cropinglen");
}

class PdfToSummariser extends StatefulWidget {
  final List <String> croppedImages;

  PdfToSummariser({super.key, required this.croppedImages});

  @override
  State<PdfToSummariser> createState() => _PdfToSummariserState();
}

class _PdfToSummariserState extends State<PdfToSummariser> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          Expanded(child: sendRequest(widget.croppedImages),), //refer line 160
        ],
      ),
    );
  }
}



Widget sendRequest(List<String> croppedImages) {
  // for(var i=0; i<croppedImages.length;i++){
  //   uploadImageToServer(croppedImages[i])
  // }

  return FutureBuilder(
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      // print(summary);
      if(summary!=''){
        // return Container(
        //   padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
        //   child: SingleChildScrollView(
        //     child: Text(
        //       OCR_result,
        //       style: const TextStyle(
        //         color: Colors.white,
        //       ),
        //     ),
        //   ),
        // );
        return SummaryDisplay(summarisedText: summary,);
      }
      return const Center(
        child: LoadingPage(),
      );
    },
    future: imageToTextForImages(croppedImages),
  );

}

class SendTextForSummary{
  SendTextForSummary(this.wordCount, this.text);
  final String text;
  final int wordCount;
}



Future imageToTextForImages(List<String> croppedImages) async {
  List <String> text = [];
  for(var i=0; i<croppedImages.length; i++){
    String result = '';
    final textDetector = GoogleMlKit.vision.textRecognizer();
    final RecognizedText recognisedText = await textDetector.processImage(InputImage.fromFilePath(croppedImages[i]));
    result = recognisedText.text;
    text.add(result);
    textDetector.close();
    await deleteImg(File(croppedImages[i]));
  }
  OCR_result = text.join(' ');
  OCR_complete = true;
  croppedImages.clear();
  await getSummary();
  // print('End of image to text for images');
}


Future getSummary() async {
  // Future.wait([imageToTextForImages(croppedImages)]);
  final url = Uri.parse('https://adssi.pythonanywhere.com/return_summary');
  final headers = {"Content-type": "application/json"};
  final response = await http.post(url, body: jsonEncode({'input_text': OCR_result}), headers: headers);
  // print(OCR_result);
  //print('Summary Status code: ${response.statusCode}');
  //print(response);
  summary = await jsonDecode(response.body)['summary'];
  // summary = OCR_result;
  //print('json decoded');
  summary_complete = true;
  // print(summary);
}







