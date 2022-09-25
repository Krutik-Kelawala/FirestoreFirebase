import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class firebaseViewPage extends StatefulWidget {
  @override
  State<firebaseViewPage> createState() => _firebaseViewPageState();
}

class _firebaseViewPageState extends State<firebaseViewPage> {
  @override
  Stream<QuerySnapshot> collectionStream =
      FirebaseFirestore.instance.collection('firebaseUsers').snapshots();

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
          "FireStore Data View",
          style: TextStyle(fontSize: textsize * 0.02),
        ),
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: collectionStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text(
              "Something went Wrong ... ",
              style: TextStyle(fontSize: textsize * 0.016),
            ));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                SizedBox(
                  height: bodyHeight * 0.05,
                ),
                Text(
                  "Loading ....",
                  style: TextStyle(fontSize: textsize * 0.015),
                )
              ],
            ));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.tealAccent),
                margin: EdgeInsets.all(textsize * 0.01),
                padding: EdgeInsets.all(textsize * 0.01),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name : ${snapshot.data!.docs[index]["NAME"]}",
                        style: TextStyle(fontSize: textsize * 0.015),
                      ),
                      Text(
                        "Phone Number : ${snapshot.data!.docs[index]["NUMBER"]}",
                        style: TextStyle(fontSize: textsize * 0.015),
                      ),
                      Text(
                        "Date : ${snapshot.data!.docs[index]["DATE"]}",
                        style: TextStyle(fontSize: textsize * 0.015),
                      )
                    ]),
              );
            },
          );
        },
      ),
    );
  }
}
