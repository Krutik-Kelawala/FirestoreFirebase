import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:realtimefirebase/main.dart';

class loginScreen extends StatefulWidget {
  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController OTPController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController logInEmailController = TextEditingController();
  TextEditingController logInpasswordController = TextEditingController();

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
        leading: Icon(
          Icons.flutter_dash,
          size: textsize * 0.03,
        ),
        title: Text(
          "Flutter Firestore",
          style: TextStyle(fontSize: textsize * 0.02),
        ),
        elevation: 0,
        actions: [aboutApplicationIcon(context)],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: bodyHeight * 0.02,
            ),
            Text(
              "Continue with Google",
              style: TextStyle(
                  fontSize: textsize * 0.016,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: bodyHeight * 0.01,
            ),
            signInWithGoogleBtn(context),
            Text(
              "Continue with Mobile number",
              style: TextStyle(
                  fontSize: textsize * 0.016,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: bodyHeight * 0.01,
            ),
            mobileNumberTextField(),
            sendOtpBtn(context),
            otpTextField(),
            otpSubmitBtn(),
            SizedBox(
              height: bodyHeight * 0.01,
            ),
            Text(
              "If you are new user Register here ",
              style: TextStyle(
                  fontSize: textsize * 0.016,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(
              height: bodyHeight * 0.01,
            ),
            registrationEmailTextfield(),
            registrationPasswordTextfield(),
            registrationBtn(context),
            SizedBox(
              height: bodyHeight * 0.01,
            ),
            Text(
              "If you are existing user LogIn here",
              style: TextStyle(
                  fontSize: textsize * 0.016,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(
              height: bodyHeight * 0.01,
            ),
            logInEmailTextfield(),
            logInPasswordTextfield(),
            logInBtn(context),
            SizedBox(
              height: bodyHeight * 0.03,
            )
          ],
        ),
      ),
    );
  }

  // TODO USE LOGIN

  Widget logInBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (logInEmailController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(seconds: 2),
              content: Text("Please enter Registered Email ID")));
        } else if (logInpasswordController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(seconds: 2),
              content: Text("Please enter your Password")));
        } else {
          loginThroghEmail();
        }
      },
      child: Container(
        width: width * 0.3,
        padding: EdgeInsets.all(textsize * 0.01),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.blue),
        child: Center(
          child: Text(
            "LogIn",
            style: TextStyle(color: Colors.white, fontSize: textsize * 0.016),
          ),
        ),
      ),
    );
  }

  Widget logInPasswordTextfield() {
    return Container(
        padding: EdgeInsets.all(textsize * 0.01),
        child: TextField(
          controller: logInpasswordController,
          decoration: InputDecoration(
              isDense: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: "Password",
              hintText: "Enter Your Password Here"),
        ));
  }

  Widget logInEmailTextfield() {
    return Container(
        padding: EdgeInsets.all(textsize * 0.01),
        child: TextField(
          keyboardType: TextInputType.emailAddress,
          controller: logInEmailController,
          decoration: InputDecoration(
              isDense: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: "Register Email ID",
              hintText: "Enter Your Register Email ID Here"),
        ));
  }

  // TODO USE REGISTRATION

  Widget registrationBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (emailController.text.isEmpty ||
            !emailController.text.contains("@") ||
            !emailController.text.endsWith(".com")) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(seconds: 2),
              content: Text("Please enter Valid Email Addresss")));
        } else if (passwordController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(seconds: 2),
              content: Text("Please enter Password")));
        } else {
          emailThroughRegistration();
        }
      },
      child: Container(
        width: width * 0.3,
        padding: EdgeInsets.all(textsize * 0.01),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.green),
        child: Center(
          child: Text(
            "Register",
            style: TextStyle(color: Colors.white, fontSize: textsize * 0.016),
          ),
        ),
      ),
    );
  }

  Widget registrationPasswordTextfield() {
    return Container(
        padding: EdgeInsets.all(textsize * 0.01),
        child: TextField(
          controller: passwordController,
          decoration: InputDecoration(
              isDense: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: "Password",
              hintText: "Enter Your Password Here"),
        ));
  }

  Widget registrationEmailTextfield() {
    return Container(
        padding: EdgeInsets.all(textsize * 0.01),
        child: TextField(
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
          decoration: InputDecoration(
              isDense: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: "Email ID",
              hintText: "Enter Your Email ID Here"),
        ));
  }

  // TODO USE MOBILE NUMBER

  Widget otpSubmitBtn() {
    return GestureDetector(
      onTap: () {
        if (OTPController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(seconds: 2),
              content: Text("Please enter valid OTP")));
        } else {
          onSubmitOtp();
        }
      },
      child: Container(
        width: width * 0.3,
        padding: EdgeInsets.all(textsize * 0.01),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.orange),
        child: Center(
          child: Text(
            "Submit",
            style: TextStyle(fontSize: textsize * 0.016, color: Colors.white),
          ),
        ),
      ),
    );
  }


  Widget otpTextField() {
    return Container(
        padding: EdgeInsets.all(textsize * 0.01),
        child: TextField(
          keyboardType: TextInputType.number,
          controller: OTPController,
          decoration: InputDecoration(
              isDense: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: "OTP",
              hintText: "Enter OTP Here"),
        ));
  }

  Widget sendOtpBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (mobileNumberController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(seconds: 2),
              content: Text("Please enter your Phone Number !")));
        } else if (mobileNumberController.text.length > 10) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(seconds: 2),
              content: Text("Please enter 10 Digit Number !")));
        } else if (mobileNumberController.text.length < 10) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(seconds: 2),
              content: Text("Please check your Phone Number !")));
        } else {
          phoneNumberSignIn().then((value) {
            EasyLoading.show(
                status: "Please Wait...",
                indicator: const Center(
                  child: CircularProgressIndicator(),
                )).whenComplete(() {
              EasyLoading.dismiss();
            });
          });
        }
      },
      child: Container(
        width: width * 0.3,
        padding: EdgeInsets.all(textsize * 0.01),
        decoration: BoxDecoration(
            color: Colors.lightBlue, borderRadius: BorderRadius.circular(5)),
        child: Center(
            child: Text(
          "Send OTP",
          style: TextStyle(color: Colors.white, fontSize: textsize * 0.016),
        )),
      ),
    );
  }

  Widget mobileNumberTextField() {
    return Container(
        padding: EdgeInsets.all(textsize * 0.01),
        child: TextField(
          keyboardType: TextInputType.number,
          controller: mobileNumberController,
          decoration: InputDecoration(
              isDense: true,
              prefix: const Text("+91  "),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              labelText: "Mobile No",
              hintText: "Enter Your Mobile Number Here"),
        ));
  }

  // TODO USE GOOGLE LOGIN

  Widget signInWithGoogleBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {
        signInWithGoogle().then((value) {
          EasyLoading.show(
              status: "Please Wait...",
              indicator: const Center(
                child: CircularProgressIndicator(),
              )).whenComplete(() {
            EasyLoading.dismiss();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                duration: Duration(seconds: 2),
                content: Text("SignIn SuccessFully !")));
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return firstPage(value);
              },
            ));
          });
        });
      },
      child: Container(
          padding: EdgeInsets.all(textsize * 0.01),
          margin: EdgeInsets.all(textsize * 0.01),
          decoration: BoxDecoration(
              border: Border.all(width: 1),
              color: const Color(0xFF97C4DE),
              borderRadius: BorderRadius.circular(5)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Center(
                  child: Text(
                    "G",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: textsize * 0.03,
                        color: Colors.black),
                  ),
                ),
              ),
              /*Center(
                      child: Icon(
                        Icons.g_mobiledata_rounded,
                        color: Colors.black,
                        size: textsize * 0.05,
                      ),
                    ),*/
              SizedBox(
                width: width * 0.01,
              ),
              Text(
                "SignIn With Google",
                style: TextStyle(fontSize: textsize * 0.016),
              )
            ],
          )),
    );
  }

  // TODO USE ABOUT APP DIALOGUE

  Widget aboutApplicationIcon(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: width * 0.05),
      child: IconButton(
        iconSize: textsize * 0.03,
        tooltip: "About application",
        onPressed: () {
          showAboutDialog(
            context: context,
            applicationIcon: Icon(
              Icons.flutter_dash,
              size: textsize * 0.03,
            ),
            applicationLegalese: " @ 2022 Company",
            applicationName: "Flutter Firestore",
            applicationVersion: "V 1.0",
            children: [
              SizedBox(
                height: bodyHeight * 0.03,
              ),
              Text(
                "1. Firestore Firebase",
                style: TextStyle(fontSize: textsize * 0.016),
              ),
              Text(
                "2. Authenication with Google",
                style: TextStyle(fontSize: textsize * 0.016),
              ),
              Text(
                "3. Authenication with Phone Number",
                style: TextStyle(fontSize: textsize * 0.016),
              ),
              Text(
                "4. Authenication with Email or Password",
                style: TextStyle(fontSize: textsize * 0.016),
              ),
              Text(
                "5. Realtime DataBase",
                style: TextStyle(fontSize: textsize * 0.016),
              ),
              Text(
                "6. Firestore DataBase",
                style: TextStyle(fontSize: textsize * 0.016),
              ),
              Text(
                "7. Cloud Messaging",
                style: TextStyle(fontSize: textsize * 0.016),
              ),
            ],
          );
        },
        icon: const Icon(
          Icons.info_rounded,
        ),
      ),
    );
  }

  // TODO USE LOGIN OR REGISTRATION THROUGH GOOGLE

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    //"TOKEN 1 = ${GoogleSignInAccount}");
    //"User = ${googleUser}");

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    //"TOKEN 2 = ${GoogleSignInAuthentication}");
    //"Auth = ${googleAuth}");

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    //"TOKEN 3 = ${credential}");
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // TODO USE SEND VERIFCATION CODE

  String verifyID = "";

  Future<void> phoneNumberSignIn() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.verifyPhoneNumber(
      phoneNumber: "+91 ${mobileNumberController.text}",
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          verifyID != e;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 2),
            content: Text("invalid-phone-number")));
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          verifyID = verificationId;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 2),
            content: Text("OTP Send SuccessFully !")));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // TODO USE LOGIN OR REGISTRATION THROUGH PHONE NUMBER

  Future<void> onSubmitOtp() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String smsCode = OTPController.text;

    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verifyID, smsCode: smsCode);

    // Sign the user in (or link) with the credential
    await auth.signInWithCredential(credential).then((value) {
      EasyLoading.show(
          status: "Please Wait...",
          indicator: const Center(
            child: CircularProgressIndicator(),
          ));
      Future.delayed(const Duration(seconds: 1)).whenComplete(() {
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 2),
            content: Text("SignIn Through Mobile Number Successfully !")));
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return firstPage(value);
          },
        ));
      });
    });
  }

  // TODO USE EMAIL THROUGH REGISTRATION

  Future<void> emailThroughRegistration() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )
          .then((value) {
        //"VAlue===${value}");
        EasyLoading.show(
            status: "Please Wait...",
            indicator: const Center(
              child: CircularProgressIndicator(),
            ));
        Future.delayed(const Duration(seconds: 1)).whenComplete(() {
          EasyLoading.dismiss();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(seconds: 2),
              content: Text("Register Successfully !")));
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return firstPage(value);
            },
          ));
        });
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 2),
            content: Text("The password provided is too weak.")));
        //'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 2),
            content: Text("The account already exists for that email.")));
        //'The account already exists for that email.');
      }
    } catch (e) {
      //e);
    }
  }

  // TODO USE EMAIL THROUGH LOGIN

  Future<void> loginThroghEmail() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: logInEmailController.text,
              password: logInpasswordController.text)
          .then((value) {
        //"VAlue   1 ===${value}");

        EasyLoading.show(
            status: "Please Wait...",
            indicator: const Center(
              child: CircularProgressIndicator(),
            ));
        Future.delayed(const Duration(seconds: 1)).whenComplete(() {
          EasyLoading.dismiss();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(seconds: 2),
              content: Text("LogIn Successfully !")));
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return firstPage(value);
            },
          ));
        });
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No user found for that email.")));
        //'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 2),
            content: Text("Wrong password provided for that user.")));
        //'Wrong password provided for that user.');
      }
    }
  }
}
