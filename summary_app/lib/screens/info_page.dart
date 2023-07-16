import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:summary_app/screens/welcome_page.dart';
import '../components/reusable_widgets.dart';



class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

List<Map<String, String>> items = [
  {
    'imagePath': 'assets/images/Step1.png',
    'text':
    "This is the list of Summaries generated so far and click on the button at the bottom to further generate more such summaries.",
  },
  {
    'imagePath': 'assets/images/Step2.png',
    'text':
    "The button when clicked, gives two options. First to click an image using Camera and second to upload a PDF.",
  },
  {
    'imagePath': 'assets/images/Step3.png',
    'text':
    "There is a Navigator at the top to help you navigate to different pages. ",
  },
  {
    'imagePath': 'assets/images/Step4.png',
    'text':
    "On the Summary List Page you can delete the existing files by dragging the files left or right.",
  },
  {
    'imagePath': 'assets/images/Step4right.jpg',
    'text':
    "On the Summary List Page you can delete the existing files by dragging the files left or right.",
  },
];

class _InfoPageState extends State<InfoPage> {

  DateTime pre_backpress = DateTime.now();

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async{
        final timegap = DateTime.now().difference(pre_backpress);
        final cantExit = timegap >= Duration(seconds: 2);
        pre_backpress = DateTime.now();
        if(cantExit){
          //show snackbar
          final snack = SnackBar(content: Text('Press Back button again to exit'),duration: Duration(seconds: 2),);
          ScaffoldMessenger.of(context).showSnackBar(snack);
          return false;
        }else{
          SystemNavigator.pop();
          return true;
        }
      },
      child: Scaffold(
        drawer: const NavDrawer(),
        backgroundColor: const Color(0xFF15051D),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
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
        body: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xff190625),
                      const Color(0xff5b0941),
                      Colors.pink.shade900,
                    ],
                  )),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: MediaQuery.of(context).size.height * 0.33,
                    alignment: Alignment.center,
                    child: const Text(
                      textAlign: TextAlign.left,
                      "Summarizer by Celestial Biscuit can help you save time and effort in reading lengthy documents by giving a gist of any document you want. Just take some pictures, or upload a picture or PDF of the document and voila! your summary is ready.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.30,
                    height: MediaQuery.of(context).size.height * 0.33,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/cb_logo.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
               padding: const EdgeInsets.all(5),
              width: MediaQuery.of(context).size.width ,
              height: MediaQuery.of(context).size.height * 0.005,
              alignment: Alignment.center,
            ),
            Container(
              padding: const EdgeInsets.all(5),
              width: MediaQuery.of(context).size.width * 0.05,
              height: MediaQuery.of(context).size.height * 0.2,
              alignment: Alignment.center,
              child: Center(
                child: Text(
                  " HOW TO USE ",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: MediaQuery.of(context).size.height*0.025,
                    fontFamily: 'Adam',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 5,
                  ),
                ),
              ),
            ),
            CarouselSlider(
              items: [
                'assets/images/Step1.png',
                'assets/images/Step2.png',
                'assets/images/Step3.png',
                'assets/images/Step4.png',
                'assets/images/Step4right.jpg',
              ].map((image) {
                return Builder(
                  builder: (BuildContext context) {
                    return Stack(
                      children: [
                        Image.asset(
                          image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                        if (image == 'assets/images/Step1.png') Positioned(
                          bottom:110.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                            ),
                            child: const Text(
                              "This is the list of Summaries generated so far and click on the button at the bottom to further generate more such summaries.",

                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                        if (image == 'assets/images/Step2.png') Positioned(
                          bottom: 110.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                            ),
                            child: const Text(
                              "The button when clicked, gives two options. First to click an image using Camera and second to upload a PDF.",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                        if (image == 'assets/images/Step3.png') Positioned(
                          bottom: 110.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                            ),
                            child: const Text(
                              "There is a Navigator at the top to help you navigate to different pages. ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                        // Add this Positioned widget to display the common text on the last two images
                        if (image == 'assets/images/Step4.png' || image == 'assets/images/Step4right.jpg') Positioned(
                          bottom: 110.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                            ),
                            child: const Text(
                              "On the Summary List Page you can delete the existing files by dragging the files left or right.",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }).toList(),
              options: CarouselOptions(
                height: 500,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 1100),
                viewportFraction: 0.5,
              ),
            ),

          ],
        ),
      ),
    );
  }
}