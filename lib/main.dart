import 'dart:convert';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sensors/sensors.dart';
import 'package:easy_udp/easy_udp.dart';
import 'package:wifi/wifi.dart';

void main() {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController ipaddress = new TextEditingController();
  TextEditingController portno = new TextEditingController();
  String srcip;
  int desport;
  String desip;
  var socket;
  int i = 0;

  void initializer() async {
    print("values initialized");
    desip = ipaddress.text;
    srcip = await Wifi.ip;
    desport = int.parse(portno.text);
    socket = await EasyUDPSocket.bind(srcip, 8000);
  }

  void init() async {
    await initializer();
    accelerometerEvents.listen((AccelerometerEvent event) async {
      await socket.send(
          ascii.encode(event.toString() + i.toString()), desip, desport);
      // await socket.send(ascii.encode(i.toString()), desip, desport);

      print(i);
      i += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('send udp data'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: ipaddress,
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'IP Address',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          TextField(
            controller: portno,
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Port NO',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
              child: Text("start sending"),
              onPressed: () async => {
                    init(),
                  })
        ],
      ),
    );
  }
}
