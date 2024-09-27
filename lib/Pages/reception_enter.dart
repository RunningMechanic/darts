import 'dart:convert';

import 'package:darts/Pages/reception.dart';
import 'package:darts/appbar_widget.dart';
import 'package:darts/websocket.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ReceptionEnterPage extends StatefulWidget {
  final String name;
  final Color nameColor;
  final String? serverIp;

  const ReceptionEnterPage(
      {super.key,
      required this.name,
      required this.nameColor,
      required this.serverIp});

  @override
  State<StatefulWidget> createState() {
    return ReceptionEnterPageState();
  }
}

class ReceptionEnterPageState extends State<ReceptionEnterPage> {
  WebSocketChannel? channel;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    channel = IOWebSocketChannel.connect(websocketURL(widget.serverIp!));
    channel?.stream.listen((message) async {
      final data = jsonDecode(message);
      if (data['protocol'] == 3 &&
          data['text'] == widget.name &&
          data["color"] == widget.nameColor.value.toString()) {
        back();
        print("back");
      }
    });
  }

  void back() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ReceptionPage(serverIp: widget.serverIp!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
          useMaterial3: true,
          fontFamily: 'DelaGothicOne'),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(105.0),
            child: AppBarWidget(title: "受付")),
        body: Center(
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.all(60)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(color: widget.nameColor, fontSize: 50),
                  ),
                  const Text(
                    " 様",
                    style: TextStyle(color: Colors.black, fontSize: 50),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.all(30)),
              const Text(
                "受付中...",
                style: TextStyle(
                    fontSize: 50, decoration: TextDecoration.underline),
              )
            ],
          ),
        ),
      ),
    );
  }
}
