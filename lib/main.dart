import 'dart:convert';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:easy_udp/easy_udp.dart';
import 'package:wifi/wifi.dart';

TextEditingController ipaddress = new TextEditingController();
TextEditingController portno = new TextEditingController();
void main() {
  runApp(MaterialApp(home: Home()));
  ipaddress.text = "192.168.0.105";
  portno.text = "4000";
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String srcip;
  int desport;
  String desip;
  var socket;
  int i = 0;
  var stream;
  void initializer() async {
    print("values initialized");
    desip = ipaddress.text;
    srcip = await Wifi.ip;
    desport = int.parse(portno.text);
    socket = await EasyUDPSocket.bind(srcip, 8000);

    stream = await SensorManager().sensorUpdates(
      sensorId: Sensors.ACCELEROMETER,
      interval: Sensors.SENSOR_DELAY_FASTEST,
    );
  }

  void init() async {
    await initializer();
    stream.listen((sensorEvent) async {
      await socket.send(
          ascii.encode(sensorEvent.data[0].toString() +
              ',' +
              sensorEvent.data[1].toString() +
              ',' +
              sensorEvent.data[2].toString()),
          desip,
          desport);
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
