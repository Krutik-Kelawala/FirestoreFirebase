import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:realtimefirebase/firestorePage.dart';
import 'package:realtimefirebase/viewPage.dart';

import 'firebase_options.dart';
import 'loginPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) {
    runApp(MaterialApp(
      builder: EasyLoading.init(
        builder: (context, child) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
              child: child!);
        },
      ),
      home: loginScreen(),
    ));
  });
}

class firstPage extends StatefulWidget {
  UserCredential value;

  firstPage(this.value);

  @override
  State<firstPage> createState() => _firstPageState();
}

class _firstPageState extends State<firstPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseMessaging.instance.getToken().then((value) {
      String? token = value;
      //"NotificatioToken = ${token}");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      //"message recieved");
      //event.notification!.body);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      //'Message clicked!');
    });
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signOut() async {
    if (auth != null) {
      await auth.signOut();
      await GoogleSignIn().signOut();
    }
  }

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
            "Realtime DB",
            style: TextStyle(fontSize: textsize * 0.02),
          ),
          elevation: 0,
          actions: [
            signOutBtn(context),
          ]),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: bodyHeight * 0.02,
            ),
            nameEmailNumberText(),
            SizedBox(
              height: bodyHeight * 0.01,
            ),
            nameTextfield(),
            numberTextfield(),
            dateTextfield(),
            SizedBox(
              height: bodyHeight * 0.05,
            ),
            submitBtn(context),
            SizedBox(
              height: bodyHeight * 0.02,
            ),
            showrealtilmeDBDataBtn(context),
            SizedBox(
              height: bodyHeight * 0.02,
            ),
            fireStoreDBPageBtn(context),
            SizedBox(
              height: bodyHeight * 0.2,
            ),
            createTimeText(),
            logInTimeText(),
          ],
        ),
      ),
    );
  }

  Widget logInTimeText() {
    return Center(
        child: Text(
      "Last SignIn : ${DateFormat('E, d MMM yyyy HH:mm:ss').format(DateTime.parse(widget.value.user!.metadata.lastSignInTime!.toLocal().toString()))}",
      style: TextStyle(fontSize: textsize * 0.015, height: textsize * 0.0014),
    ));
  }

  Widget createTimeText() {
    return Center(
        child: Text(
      "Create Time : ${DateFormat('E, d MMM yyyy HH:mm:ss').format(DateTime.parse(widget.value.user!.metadata.creationTime!.toLocal().toString()))}",
      style: TextStyle(fontSize: textsize * 0.015, height: textsize * 0.0014),
    ));
  }

  Widget fireStoreDBPageBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return firestorePage();
          },
        ));
      },
      child: Container(
        width: width * 0.5,
        padding: EdgeInsets.all(textsize * 0.01),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.indigo),
        child: Center(
          child: Text(
            "FireStore DB Page",
            style: TextStyle(fontSize: textsize * 0.016, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget showrealtilmeDBDataBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return dataView();
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
            "Show RealTime DB Data",
            style: TextStyle(color: Colors.white, fontSize: textsize * 0.016),
          ),
        ),
      ),
    );
  }

  Widget submitBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (nameController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(seconds: 2),
              content: Text("Please enter your name !")));
        } else if (phonenumberController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(seconds: 2),
              content: Text("Please enter your Phone No !")));
        } else if (dateController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(seconds: 2),
              content: Text("Please enter Date !")));
        } else {
          dataSendToDB().then((value) {
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
                  return dataView();
                },
              ));
            });
          });
        }
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

  Widget dateTextfield() {
    return Container(
        padding: EdgeInsets.all(textsize * 0.01),
        child: TextField(
          controller: dateController,
          decoration: InputDecoration(
              isDense: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: "Date",
              hintText: "Enter Date Here"),
        ));
  }

  Widget numberTextfield() {
    return Container(
        padding: EdgeInsets.all(textsize * 0.01),
        child: TextField(
          keyboardType: TextInputType.number,
          controller: phonenumberController,
          decoration: InputDecoration(
              isDense: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: "Phone Number",
              hintText: "Enter Your Phone Number Here"),
        ));
  }

  Widget nameTextfield() {
    return Container(
        padding: EdgeInsets.all(textsize * 0.01),
        child: TextField(
          controller: nameController,
          decoration: InputDecoration(
              isDense: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: "Name",
              hintText: "Enter Your Name Here"),
        ));
  }

  Container nameEmailNumberText() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(textsize * 0.01),
      margin: EdgeInsets.symmetric(horizontal: width * 0.02),
      decoration: BoxDecoration(
          color: const Color(0xFF88C1C9),
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        children: [
          Text(
            "Name  : ${widget.value.user!.displayName}",
            style: TextStyle(
                fontSize: textsize * 0.015, height: textsize * 0.0014),
          ),
          Text("VerifiedEmail : ${widget.value.user!.emailVerified}",
              style: TextStyle(
                  fontSize: textsize * 0.015, height: textsize * 0.0014)),
          Text("Email ID : ${widget.value.user!.email}",
              style: TextStyle(
                  fontSize: textsize * 0.015, height: textsize * 0.0014)),
          Text("Phone Number : ${widget.value.user!.phoneNumber}",
              style: TextStyle(
                  fontSize: textsize * 0.015, height: textsize * 0.0014)),
        ],
      ),
    );
  }

  // TODO USE SIGN OUT

  PopupMenuItem<dynamic> signOutBtn(BuildContext context) {
    return PopupMenuItem(
      textStyle: const TextStyle(color: Colors.white),
      onTap: () {
        EasyLoading.show(
            status: "Please Wait...",
            indicator: const Center(
              child: CircularProgressIndicator(),
            )).whenComplete(() {
          EasyLoading.dismiss();
          signOut();
          showDialog(
            barrierDismissible: false,
            builder: (context) {
              return exitDialogue();
            },
            context: context,
          );

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(seconds: 2),
              content: Text("SignOut Successfully !")));
        });
      },
      child: Text(
        "Sign Out",
        style: TextStyle(fontSize: textsize * 0.016),
      ),
    );
  }

  // TODO USE Data Send REALTIME DB

  Future<void> dataSendToDB() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("usersAll").push();

    await ref.set({
      "name": nameController.text,
      "phoneNumber": phonenumberController.text,
      "date": dateController.text
    });
  }

  // TODO USE EXIT AND LOGOUT DIALOG

  Widget exitDialogue() {
    return Center(
      child: Wrap(
        children: [
          AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            content: Center(
              child: Text(
                "LogOut Successfully !",
                style:
                    TextStyle(color: Colors.black, fontSize: textsize * 0.016),
              ),
            ),
            actions: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    SystemNavigator.pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.circular(5)),
                    height: bodyHeight * 0.06,
                    width: width * 0.26,
                    child: Center(
                      child: Text(
                        "Ok",
                        style: TextStyle(
                            color: Colors.white, fontSize: textsize * 0.02),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
