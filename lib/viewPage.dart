import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class dataView extends StatefulWidget {
  @override
  State<dataView> createState() => _dataViewState();
}

class _dataViewState extends State<dataView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showData();
    setState(() {
      isLoading = true;
    });
  }

  List realTimeDataList = [];
  bool isLoading = false;

  showData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("usersAll");
    Stream<DatabaseEvent> stream = ref.onValue;

// Subscribe to the stream!
    stream.listen((DatabaseEvent event) {
      realTimeDataList.clear();
      Map dataViewMap = event.snapshot.value as Map;
      //"view daaata = ${dataViewMap}");
      dataViewMap.forEach((key, value) {
        if (this.mounted) {
          setState(() {
            realTimeDataList.add(value);
          });
        }
      }); // DataSnapshot
      //"My Data ${realTimeDataList}");
    });
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
          "Realtime Data View",
          style: TextStyle(fontSize: textsize * 0.02),
        ),
        elevation: 0,
      ),
      body: isLoading
          ? ListView.builder(
              itemCount: realTimeDataList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(textsize * 0.01),
                  padding: EdgeInsets.all(textsize * 0.01),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.yellow,
                      border: Border.all(width: 1)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name : ${realTimeDataList[index]['name']}",
                          style: TextStyle(fontSize: textsize * 0.015),
                        ),
                        Text(
                          "Mobile No : ${realTimeDataList[index]['phoneNumber']}",
                          style: TextStyle(fontSize: textsize * 0.015),
                        ),
                        Text(
                          "Date : ${realTimeDataList[index]['date']}",
                          style: TextStyle(fontSize: textsize * 0.015),
                        ),
                      ]),
                );
              },
            )
          : Center(
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
            )),
    );
  }
}
