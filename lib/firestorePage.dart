import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:realtimefirebase/firebaseView.dart';

class firestorePage extends StatefulWidget {
  @override
  State<firestorePage> createState() => _firestorePageState();
}

class _firestorePageState extends State<firestorePage> {
  TextEditingController firebaseNameController = TextEditingController();
  TextEditingController firebasePhonenumberController = TextEditingController();
  TextEditingController firebaseDateController = TextEditingController();

  // TODO HERE use ADD IMAGE

  /* final ImagePicker _picker = ImagePicker();
  String imageMy = ""; // use for path
  String urlimageMy = ""; // use for download image url
  String fixedImgMy = "images/user.png";
  XFile? image;*/

  late double height;
  late double width;
  late double statusbarHeight;
  late double navigationbarHeight;
  late double appbarHeight;
  late double bodyHeight;
  var textsize;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    statusbarHeight = MediaQuery.of(context).padding.top;
    navigationbarHeight = MediaQuery.of(context).padding.bottom;
    appbarHeight = kToolbarHeight;
    bodyHeight = height - statusbarHeight - navigationbarHeight - appbarHeight;
    textsize = pow((width * width) + (height * height), 1 / 2);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "FireStore DB",
          style: TextStyle(fontSize: textsize * 0.02),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: bodyHeight * 0.05,
            ),
            // selectImageContainer(context),
            nameTextField(),
            numberTextField(),
            dateTextField(),
            SizedBox(
              height: bodyHeight * 0.1,
            ),
            submitBtn(context),
            SizedBox(
              height: bodyHeight * 0.02,
            ),
            showFirebaseDBDataShow(context),
          ],
        ),
      ),
    );
  }

  Widget showFirebaseDBDataShow(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return firebaseViewPage();
          },
        ));
      },
      child: Container(
        width: width * 0.5,
        padding: EdgeInsets.all(textsize * 0.01),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.orange),
        child: Center(
          child: Text(
            "Show FireStore DB Data",
            style: TextStyle(color: Colors.white, fontSize: textsize * 0.016),
          ),
        ),
      ),
    );
  }

  Widget submitBtn(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (firebaseNameController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(seconds: 2),
              content: Text("Please enter your name !")));
        } else if (firebasePhonenumberController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(seconds: 2),
              content: Text("Please enter your Phone No !")));
        } else if (firebaseDateController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(seconds: 2),
              content: Text("Please enter Date !")));
        } else {
          dataSendToFirebase();
        }

        // TODO USE IMAGE UPLOAD VALIDATION HERE

        /*else if (image != null && image!.path.isNotEmpty) {
          setState(() {
            imageMy = image!.path;
          });
          DateTime dayTime = DateTime.now();
          final storageRef = FirebaseStorage.instance.ref();
          final spaceRef = storageRef.child(
              "Images/${firebaseNameController.text.toString()} ${dayTime.day}-${dayTime.month}-${dayTime.year} ${dayTime.hour}:${dayTime.minute}.jpg");
          await spaceRef.putFile(File(imageMy));
          await spaceRef.getDownloadURL().then((value) {
            print("abc = ${value}");
            setState(() {
              urlimageMy = value;
            });
            print("URL = ${urlimageMy}");
          });

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(seconds: 2),
              content: Text("Photo added successfully !")));

          dataSendToFirebase();
        }*/

        // TODO HERE REMOVE ICON AND ADD IMAGE

        /*else {
          DateTime dayTime = DateTime.now();
          final storageRef = FirebaseStorage.instance.ref();
          final spaceRef = storageRef.child(
              "Images/${firebaseNameController.text.toString()} ${dayTime.day}-${dayTime.month}-${dayTime.year} ${dayTime.hour}:${dayTime.minute}.jpg");
          await spaceRef.putFile(File(fixedImgMy));
          await spaceRef.getDownloadURL().then((value) {
            print("abc = ${value}");
            setState(() {
              urlimageMy = value;
            });
            print("URL = ${urlimageMy}");
          });

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(seconds: 2),
              content: Text("Photo added successfully !")));

          print(" No Found Image");
          dataSendToFirebase();
        }*/
      },
      child: Container(
        width: width * 0.5,
        padding: EdgeInsets.all(textsize * 0.01),
        decoration: BoxDecoration(
            color: Colors.lightBlue, borderRadius: BorderRadius.circular(5)),
        child: Center(
            child: Text(
          "Submit",
          style: TextStyle(color: Colors.white, fontSize: textsize * 0.016),
        )),
      ),
    );
  }

  Widget dateTextField() {
    return Container(
        padding: EdgeInsets.all(textsize * 0.01),
        child: TextField(
          controller: firebaseDateController,
          decoration: InputDecoration(
              isDense: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: "Date",
              hintText: "Enter Date Here"),
        ));
  }

  Widget numberTextField() {
    return Container(
        padding: EdgeInsets.all(textsize * 0.01),
        child: TextField(
          keyboardType: TextInputType.number,
          controller: firebasePhonenumberController,
          decoration: InputDecoration(
              isDense: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: "Phone Number",
              hintText: "Enter Your Phone Number Here"),
        ));
  }

  Widget nameTextField() {
    return Container(
        padding: EdgeInsets.all(textsize * 0.01),
        child: TextField(
          controller: firebaseNameController,
          decoration: InputDecoration(
              isDense: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: "Name",
              hintText: "Enter Your Name Here"),
        ));
  }

  // TODO USE Data Send FIRESTORE DB

  CollectionReference users =
      FirebaseFirestore.instance.collection('firebaseUsers');

  // final storageRef = FirebaseStorage.instance.ref();

  Future<void> dataSendToFirebase() {
    return users.add({
      "NAME": firebaseNameController.text,
      "NUMBER": firebasePhonenumberController.text,
      "DATE": firebaseDateController.text,
      // "IMAGE": urlimageMy,
    }).then((value) {
      EasyLoading.show(
          status: "Please Wait...",
          indicator: const Center(
            child: CircularProgressIndicator(),
          )).whenComplete(() {
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 2),
            content: Text("Added SuccessFully !")));
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return firebaseViewPage();
          },
        ));
      });
    }).catchError((error) => print("Failed to add user: $error"));
  }

// TODO USE IMAGE

/*Widget selectImageContainer(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          builder: (context) {
            return imagePickerDialog();
          },
          context: context,
        );
      },
      child: Container(
        height: bodyHeight * 0.2,
        width: width * 0.4,
        child: imageMy != ""
            ? Container(
                height: bodyHeight * 0.2,
                width: width * 0.4,
                decoration: BoxDecoration(
                    image: DecorationImage(image: FileImage(File(imageMy)))),
              )

            // TODO HERE REMOVE ICON AND ADD IMAGE

            : Image.asset("images/user.png"),
      ),
    );
  }*/

/*  Widget imagePickerDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: SizedBox(
        height: bodyHeight * 0.2,
        width: width * 0.2,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [cameraOntap(), galleryOntap()]),
      ),
    );
  }*/

/* Widget galleryOntap() {
    return GestureDetector(
      onTap: () {
        _getFromGallery();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image,
            size: textsize * 0.05,
          ),
          Text(
            "Gallery",
            style: TextStyle(fontSize: textsize * 0.016),
          )
        ],
      ),
    );
  }

  Widget cameraOntap() {
    return GestureDetector(
      onTap: () async {
        openCamra();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.camera_alt,
            size: textsize * 0.05,
          ),
          Text(
            "Camera",
            style: TextStyle(fontSize: textsize * 0.016),
          )
        ],
      ),
    );
  }*/

/*void _getFromGallery() async {
    image = await _picker.pickImage(source: ImageSource.gallery);
    Navigator.pop(context);
  }

  void openCamra() async {
    image = await _picker.pickImage(source: ImageSource.camera);
    Navigator.pop(context);
  }*/
}
