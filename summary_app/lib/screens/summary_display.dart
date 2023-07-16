import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:summary_app/screens/crop_screen.dart';
import 'home_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';




class SummaryDisplay extends StatefulWidget {
  const SummaryDisplay({
    super.key,
    required this.summarisedText,
  });
  final String summarisedText;
  @override
  State<SummaryDisplay> createState() => _SummaryDisplayState();
}

class _SummaryDisplayState extends State<SummaryDisplay> {
  int num = 1;
  String _title = 'Untitled File';
  String filePath = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A131E),
      appBar: AppBar(
        title: Text(_title),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
                icon: const Icon(
                Icons.arrow_back,
            ),
                onPressed: () {
                  summary='';
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()
                      )
                  );
                }
            );
          },

        ),
        actions: [
          PopupMenuButton(
            initialValue: 1,
            color: const Color(0xFF1A131E),
            icon: const Icon(
                Icons.menu_rounded,
                color: Colors.white,
              ),
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                const PopupMenuItem<int>(
                    value: 0,
                    child: Text(
                      'Rename',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                ),
                const PopupMenuItem<int>(
                    value: 1,
                    child: Text(
                        'Save as PDF',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )

                )
              ]
          )

        ],
        titleTextStyle: const TextStyle(
          fontFamily: 'Adam',
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: const Color(0xFF1A131E),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Text(
            widget.summarisedText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );

  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _createPDF(item: 0));
  }

  onSelected(BuildContext context, int item) {
    switch (item){
      case 0:
        _displayDialog(context);
        _renamePDF(_title);
        break;
      case 1:
        _createPDF(item: 1);
        break;
    }

  }

  Future <void> _createPDF({required int item}) async{
    PdfDocument document = PdfDocument();
    final page = document.pages.add();
    //print('Started generating...');
    final PdfLayoutResult layoutResult = PdfTextElement(
        text: widget.summarisedText,
        font: PdfStandardFont(PdfFontFamily.helvetica, 20),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)))
        .draw(
        page: page,
        bounds: Rect.fromLTWH(
            0, 0, page.getClientSize().width, page.getClientSize().height),
        format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate))!;

    //print('Generation ended. Starting to save...');
    List<int> bytes = await document.save();
    document.dispose();
    if(item==0){
      saveFile(bytes, _title);
    } else {
      saveAndOpenFile(bytes, _title);
    }
  }


  Future <void> saveFile(List<int>bytes, String fileName) async{
    //print('Open relevant folder');
    final path = (await getExternalStorageDirectory())?.path;
    //print('Make a file');
    filePath = '$path/$fileName.pdf';
    while(await File(filePath).exists()){
      _title = 'Untitled File';
      _title = '$_title $num';
      filePath = '$path/$_title.pdf';
      num++;
      setState(() {});
      // print(num);
    }
    final file = File(filePath);
    await file.writeAsBytes(bytes);
    // await OpenFile.open(file.path);
  }

  Future <void> saveAndOpenFile(List<int>bytes, String fileName) async{
    //print('Open relevant folder');
    final path = (await getExternalStorageDirectory())?.path;
    //print('Make a file');
    final file = File('$path/$fileName.pdf');
    await file.writeAsBytes(bytes);
    //print('Open file directly');
    filePath = file.path;
    await OpenFile.open(file.path);
  }

  void _renamePDF(String newFileName) async {
    var path = filePath;
    //print(path);
    await File(path).delete();
    _createPDF(item: 0);
      // var newPath = path.substring(0, lastSeparator + 1) + newFileName;
      // file.rename(newPath);
    }


  final TextEditingController _textFieldController = TextEditingController();
  _displayDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: const Text('Rename File', style: TextStyle(color: Colors.white),),
            content: TextField(
              showCursor: true,
              cursorColor: Colors.white,
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
              controller: _textFieldController,
              onChanged: (text) => setState(() {
                _title = text;
                // summary=summary;
              }),
            ),
            actions: <Widget>[
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(
                    color: Color(0xFF801267),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('SUBMIT', style: TextStyle(color: Colors.white),),
                onPressed: () {
                  _renamePDF(_title);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }



  
}



// // Dispose the document.
// document.dispose();

