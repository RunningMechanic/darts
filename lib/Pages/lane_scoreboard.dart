import 'dart:convert';
import 'package:darts/websocket.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class LaneScoreboardPage extends StatefulWidget {
  final String? serverIp;
  final int? lane;

  const LaneScoreboardPage(
      {super.key, required this.serverIp, required this.lane});

  @override
  State<StatefulWidget> createState() {
    return LaneScoreboardPageState();
  }
}

class LaneScoreboardPageState extends State<LaneScoreboardPage> {
  List<String>? points = [];
  List<int>? pointsInt = [];
  WebSocketChannel? channel;
  String name = "";
  String color = "0xff000000";
  bool finish = false;
  String score = "";

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    channel?.sink.close();
    super.dispose();
  }

  Future<void> initialize() async {
    channel = IOWebSocketChannel.connect(websocketURL(widget.serverIp!));
    channel?.stream.listen((message) {
      final data = jsonDecode(message);
      if (data['value'] == widget.lane) {
        finish = false;
        if (data['protocol'] == 3) {
          setState(() {
            finish = false;
            points = [];
            name = data['text'];
            color = data['color'];
            score = "";
          });
        } else if (data['protocol'] == 9) {
          setState(() {
            points = [];
            name = "";
            color = "0xff000000"; // Reset color
            finish = false;
            score = "";
          });
        }
      }
      if (data['protocol'] == 5 && data['laneNum'] == widget.lane) {
        setState(() {
          finish = true;
          score = data['score'].toString();
        });
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return constraints.maxWidth < constraints.maxHeight
            ? _buildVertical(context)
            : _buildHorizontal(context);
      },
    );
  }

  Widget _buildVertical(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 60, 0),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/laneScoreBackground.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 188),
          // DefaultTextStyle(
          //   style: TextStyle(
          //     decoration: TextDecoration.underline,
          //     fontSize: 30,
          //     color: Color(int.parse(color)),
          //     fontFamily: 'Roboto',
          //   ),
          //   child: Text(name.isNotEmpty ? name : "No Name"),
          // ),
          const SizedBox(height: 20),
          DefaultTextStyle(
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontSize: 50,
              color: Color(int.parse(color)),
              fontFamily: 'Roboto',
            ),
            child: Text(finish ? "終了時のスコア(前回履歴): $score" : ""),
          ),
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: points?.length ?? 0,
          //     itemBuilder: (context, index) {
          //       return Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: DefaultTextStyle(
          //           style: const TextStyle(
          //             decoration: TextDecoration.underline,
          //             fontSize: 20,
          //             color: Colors.black,
          //             fontFamily: 'Roboto',
          //           ),
          //           child: Text(points![index]),
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildHorizontal(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text("縦に戻してください: $points", style: const TextStyle(fontSize: 32)),
    );
  }
}
