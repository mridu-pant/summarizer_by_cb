import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as math;
import 'package:pdf_image_renderer/pdf_image_renderer.dart';
import 'package:summary_app/screens/info_page.dart';
import 'package:summary_app/screens/welcome_page.dart';

import '../components/reusable_widgets.dart';
import 'crop_screen.dart';
List<FileSystemEntity> file = [];
List <String> images=[];
List <String> croppedImages=[];

class ExpandableFab extends StatefulWidget {
  const ExpandableFab({Key? key, required this.children, required this.distance}) : super(key: key);

  final List<Widget> children;
  final double distance;

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        value: _open ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        vsync: this);

    _expandAnimation = CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
        reverseCurve: Curves.easeOutQuad
    );
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if(_open){
        _controller.forward();
      }else{
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          _tapToClose(),
          ..._buildExpandableFabButton(),
          _tapToOpen(),
        ],
      ),
    );
  }

  Widget _tapToClose() {
    return SizedBox(
      height: 55,
      width: 55,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          child: InkWell(
            onTap: _toggle,
            child: const  Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: Color(0xFF801267),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tapToOpen() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      transformAlignment: Alignment.center,
      transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: _open ? 0.0 : 1.0,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 250),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF801267),
          onPressed: _toggle,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  List<Widget> _buildExpandableFabButton() {
    final List<Widget> children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);

    for(var i=0, angleInDegrees = 0.0; i< count; i++, angleInDegrees += step){
      children.add(
          _ExpandableFab(
              directionDegrees: angleInDegrees,
              maxDistance: widget.distance,
              progress: _expandAnimation,
              child: widget.children[i])
      );
    }

    return children;
  }
}

class _ExpandableFab extends StatelessWidget {
  const _ExpandableFab({Key? key, required this.directionDegrees, required this.maxDistance, required this.progress, required this.child}) : super(key: key);

  final double directionDegrees;
  final double maxDistance;
  final Animation<double>? progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress!,
      builder: (context, child) {
        final offset = Offset.fromDirection(
            directionDegrees * (math.pi / 180),
            progress!.value * maxDistance
        );

        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress!.value) * math.pi / 2,
            child: child,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress!,
        child: child,
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({Key? key, this.onPressed, required this.icon}) : super(key: key);

  final VoidCallback? onPressed;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF801267),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      elevation: 4.0,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
      ),
    );
  }
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool isSelectionMode = false;
  Map<int, bool> selectedFlag = {};
  List <FileSystemEntity> delFiles = [];

  @override
  void initState() {
    _files=[];
    getDir();
    super.initState();
  }

  late List<FileSystemEntity> _files;
  Future<void> getDir() async {
    final directory = await getExternalStorageDirectory();
    final dir = directory?.path;
    String pdfDirectory = '$dir/';
    final myDir = Directory(pdfDirectory);
    setState(() {
      _files = myDir.listSync(recursive: true, followLinks: false);
    });
    //print(_files);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const InfoPage()));
        return true;
      },
      child: Scaffold(
        drawer: const NavDrawer(),
        backgroundColor: Colors.black,
        // appBar: AppBar(
        //   backgroundColor: Colors.black,
        //   leading: IconButton(
        //     onPressed: () {
        //       Navigator.push(context, MaterialPageRoute(builder: (context)=>const AboutPage()));
        //     },
        //     icon: const Icon(
        //       Icons.menu,
        //       color: Colors.white,
        //       size: 30,
        //     ),
        //   ),
        // ),
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.black54,
                        title: const Text('Logout', style: TextStyle(color: Colors.white),),
                        content: const Text('Are you sure you want to log out?', style: TextStyle(color: Colors.white),),
                        actions: [
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
                            child: const Text('Yes', style: TextStyle(color: Colors.white),),
                            onPressed: () async {
                              signOut();
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute( builder: (context) => const WelcomePage()), (route) => false);

                            },
                          ),
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
                            child: const Text('No', style: TextStyle(color: Colors.white),),
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    }
                  );

                  },
                icon: const Icon(Icons.logout, color: Colors.white,)
            )
          ],
        ),

        body: ListView.builder(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 25,
          ),
          // gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          //   maxCrossAxisExtent: 180,
          //   mainAxisSpacing: 10,
          //   crossAxisSpacing: 10,
          // ),
          itemBuilder: (context, index) {
            if(_files.isEmpty){
              return const Center(child: Text('Generate your first summary!', style: TextStyle(color: Colors.white70)));
            }
            return Dismissible(
              // background: Container(
              //   //color: Color(0xFF801267),
              //   child: (child: Icon(Icons.delete, color: Colors.white70,)),
              // ),
              key: UniqueKey(),
              background: Container(
                //color: Colors.red,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              secondaryBackground: Container(
                //color: Colors.red,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const <Widget>[
                      Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ),
              onDismissed: (direction) async {
                await _files[index].delete();
                setState(() {
                  _files.removeAt(index);
                });
              },
              child: GestureDetector(
                onTap: () async {
                  await OpenFile.open(_files[index].path);
                },
                // onTap: ()=> onTap(isSelected, index),
                // onLongPress: () => onLongPress(isSelected, index),
                child: Card(
                  key: Key(index.toString()),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFF806CC)),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 10.0,
                  margin: const EdgeInsets.only(bottom: 20),
                  shadowColor: const Color(0xFFF806CC),
                  child: Stack(
                    children: [
                      Container(
                        color: const Color(0xFF1A131E),
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        //margin: const EdgeInsets.all(30),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(right: 10),
                              child: const Icon(
                                Icons.picture_as_pdf_outlined,
                                size: 40,
                                color: Color(0xFF801267),
                              ),
                              // child: _buildSelectIcon(isSelected!, selectedFlag, index),
                            ),

                            Container(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(
                                _files[index].path.split('/').last,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: _files.length,
        ),

        floatingActionButton: ExpandableFab(
          distance: 60,
          children: [
            ActionButton(
              icon: const Icon(Icons.upload_file_outlined, color: Colors.white),
              onPressed: () async {
                renderPdfImage();

                // Navigator.push(context, MaterialPageRoute(builder: (context)=>PdfToCrop(croppedImages: croppedImages)));
              },
            ),
            ActionButton(
              icon: const Icon(Icons.add_a_photo_outlined, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, 'camera_page');
              },
            ),
          ],
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );

  }



  void renderPdfImage() async {
    // Get a path from a pdf file (we are using the file_picker package (https://pub.dev/packages/file_picker))
    FilePickerResult? pdf = await FilePicker.platform.pickFiles(allowedExtensions: ['pdf'], type: FileType.custom);
    String? path = pdf?.paths[0];
    // Initialize the renderer
    final rendererPDF = PdfImageRendererPdf(path: path!);
    // open the pdf document
    await rendererPDF.open();

    final count = await rendererPDF.getPageCount();

    for(var i=0; i<count; i++){
      await rendererPDF.openPage(pageIndex: i);
      final size = await rendererPDF.getPageSize(pageIndex: i);
      final img = await rendererPDF.renderPage(
        pageIndex: i,
        x: 0,
        y: 0,
        width: size.width, // you can pass a custom size here to crop the image
        height: size.height, // you can pass a custom size here to crop the image
        scale: 1, // increase the scale for better quality (e.g. for zooming)
        background: Colors.white,
      );


      String fileName = 'temp$i.jpg';

      final path = (await getTemporaryDirectory()).path;
      final file = File('$path/$fileName');
      await file.writeAsBytes(img!);
      await rendererPDF.closePage(pageIndex: i);
      images.add(file.path);
    }

    // close the PDF after rendering the page
    rendererPDF.close();
    // TakePictureScreen.cropAllImages();
    //print(images[0]);
    List <String> croppedImages = await cropAllImages(images);
    goToNextPage(croppedImages);
  }

  void goToNextPage(List <String> croppedImages){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>PdfToSummariser(croppedImages: croppedImages)));
  }

  Future getFileType(file)
  {

    return file.stat();
  }

  onTap(bool? isSelected, int index) async {
    if (isSelectionMode) {
      setState(() {
        selectedFlag[index] = !isSelected!;
        isSelectionMode = selectedFlag.containsValue(true);
      });
    } else {
      // Open Detail Page
      await OpenFile.open(_files[index].path);
    }
  }

  onLongPress(bool? isSelected, int index) {
    setState(() {
      selectedFlag[index] = !isSelected!;
      isSelectionMode = selectedFlag.containsValue(true);
    });
  }


}





