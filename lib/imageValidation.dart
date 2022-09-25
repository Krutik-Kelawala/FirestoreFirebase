import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realtimefirebase/loginPage.dart';

class imageValidate extends StatefulWidget {
  const imageValidate({Key? key}) : super(key: key);

  @override
  State<imageValidate> createState() => _imageValidateState();
}

class _imageValidateState extends State<imageValidate> {
  final ImagePicker _picker = ImagePicker();
  String imageMy = "";
  XFile? image;
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Validate'),
      ),
      body: SingleChildScrollView(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          InkWell(
            onTap: () {
              showDialog(
                builder: (context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: SizedBox(
                      height: 150,
                      width: 150,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                openCamra();
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.camera_alt),
                                  Text("Camera")
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _getFromGallery();
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.image),
                                  Text("Gallery")
                                ],
                              ),
                            )
                          ]),
                    ),
                  );
                },
                context: context,
              );
            },
            child: Container(
                height: 200,
                width: 200,
                child: imageMy != ""
                    ? Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(File(imageMy)))),
                      )
                    : Image.asset(
                        "images/user.png",
                      )),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                  label: const Text("Name"),
                  hintText: "Enter your name here",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                DateTime dayTime = DateTime.now();
                final storageRef = FirebaseStorage.instance.ref();
                final spaceRef = storageRef
                    .child(
                        "Images/${nameController.text.toString()} ${dayTime.day}-${dayTime.month}-${dayTime.year} ${dayTime.hour}:${dayTime.hour}.jpg")
                    .putFile(File(imageMy));

                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return loginScreen();
                  },
                ));
              },
              child: const Text("Submit"))
        ]),
      ),
    );
  }

  void _getFromGallery() async {
    image = await _picker.pickImage(source: ImageSource.gallery).then((value) {
      if (image != null && image!.path.isNotEmpty) {
        setState(() {
          imageMy = image!.path;
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 2),
            content: Text("Photo added successfully !")));
        print("  Image ${imageMy}");
      } else {
        print(" No Found Image");
        return;
        // const AssetImage("images/user.png");

      }
    });
    Navigator.pop(context);
  }

  void openCamra() async {
    image = await _picker.pickImage(source: ImageSource.camera).then((value) {
      if (image != null && image!.path.isNotEmpty) {
        setState(() {
          imageMy = image!.path;
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 2),
            content: Text("Photo added successfully !")));
        print("  Image ${imageMy}");
      } else {
        print(" No Found Image");
        return;
        // const AssetImage("images/user.png");
      }
    });
    Navigator.pop(context);
  }
}
