import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Record extends StatefulWidget {
  const Record({Key? key}) : super(key: key);

  @override
  State<Record> createState() => _RecordState();
}

class _RecordState extends State<Record> {
  List data = [];
  GeoPoint point = const GeoPoint(0, 0);
  late DateTime time = DateTime.now();

  //test
  getRecord() async {
    final employee = await FirebaseFirestore.instance
        .collection('employee')
        .doc('vuUn9uuoTxFLyJ3zd4Fu')
        .collection('record')
        .get();

    for (int i = 0; i < employee.docs.length; i++) {
      data.add(employee.docs[i].data());
    }

    if (mounted) {
      setState(() {
        data;
        // point = data[0]['location'];
        // time = DateTime.fromMicrosecondsSinceEpoch(data[0]['time'] * 1000);
      });
    }
  }

  //fomat the Date data and display
  convertDate(var timeDate) {
    var _year, _month, _day, _hour, _minute;
    _year = timeDate.year;
    _minute = timeDate.minute;
    _day = timeDate.day;
    switch (timeDate.month) {
      case 1:
        _month = "January";
        break;
      case 2:
        _month = "February";
        break;
      case 3:
        _month = "March";
        break;
      case 4:
        _month = "April";
        break;
      case 5:
        _month = "May";
        break;
      case 6:
        _month = "June";
        break;
      case 7:
        _month = "July";
        break;
      case 8:
        _month = "August";
        break;
      case 9:
        _month = "September";
        break;
      case 10:
        _month = "October";
        break;
      case 11:
        _month = "November";
        break;
      case 12:
        _month = "December";
        break;
    }

    String _time;
    if (timeDate.hour > 12) {
      _time = "${timeDate.hour - 12}:${timeDate.minute} pm";
    } else {
      _time = "${timeDate.hour}:${timeDate.minute} am";
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "$_month $_day, $_year",
          style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        Text(
          _time,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    getRecord();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          var _time = data[index]['time'].toDate();
          return recordCard(_time, index);
        },
      ),
    ));
  }

  Widget recordCard(var time, int index) {
    return Card(
      elevation: 5,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Container(
        margin: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width * 0.9,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          convertDate(time),
          const Spacer(),
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
                color: const Color(0xffFDBF05),
                border: Border.all(color: Colors.black, width: 5),
                borderRadius: const BorderRadius.all(Radius.circular(100))),
            child: Center(
                child: Text(
              "${data[index]['status']}",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )),
          )
        ]),
      ),
    );
  }
}
