import 'dart:convert';

import 'package:darts/appbar_widget.dart';
import 'package:darts/websocket.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ScoreboardPage extends StatefulWidget {
  final String? serverIp;

  const ScoreboardPage({super.key, required this.serverIp});

  @override
  State<StatefulWidget> createState() {
    return ScoreboardPageState();
  }
}

class ScoreboardPageState extends State<ScoreboardPage> {
  List<Widget> widgets = [];
  WebSocketChannel? channel;
  var json=[];
  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() {
    channel = IOWebSocketChannel.connect(websocketURL(widget.serverIp!));
    channel?.stream.listen((message) {
      final data = jsonDecode(message);
      widgets = [];
      if (data["protocol"] != 5) return;
      json.add(data);
      setState(() {
        final entries = <Map<String, dynamic>>[];
        for (final row in json) {
          final lane = row['laneNum'] as int;
          final text = row['text'] as String;
          final color = row['color'] as String;
          final score = row['score'] as int;

          entries.add(
              {'lane': lane, 'text': text, 'color': color, 'score': score});
        }

        entries.sort((a, b) => b['score'].compareTo(a['score']));
        int i = 0;
        for (final entry in entries) {
          i++;
          widgets.add(Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No.$i / ',
                    style: const TextStyle(fontSize: 50),
                  ),
                  Text("「${entry['text']} 」 様",
                      style: TextStyle(
                          fontSize: 50,
                          color: Color(int.parse(entry['color'])))),
                  const Spacer(),
                  Text("${entry['score']} 点",
                      style: const TextStyle(fontSize: 50)),
                ],
              ),
            ],
          ));
          if (widgets.length > 5) {
            widgets.removeLast();
          }
        }
      });
    });
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
            child: AppBarWidget(title: "スコアボード")),
        body: Column(children: [
          // const Text("=> 本日のランキング <=", style: TextStyle(fontSize: 50)),
          TextButton(
              onPressed: () {
                showDialog<void>(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: const Text('下から何番目を消しますか？'),
                        actions: <Widget>[
                          ElevatedButton(
                            child: const Text('1'),
                            onPressed: () {
                              print(widgets.length);
                              if (widgets.isNotEmpty) {
                                setState(() {
                                  widgets.removeAt(0);
                                  json.removeAt(0);
                                  sort(json);
                                });
                              }
                              //Navigator.pop(context);
                            },
                          ),
                          ElevatedButton(
                            child: const Text('2'),
                            onPressed: () {
                              if (widgets.length >= 2) {
                                setState(() {
                                  print(widgets);
                                  print(json);
                                  widgets.removeAt(1);
                                  json.removeAt(1);
                                  sort(json);
                                  print(widgets);
                                  print(json);
                                });
                              }
                              // Navigator.pop(context);
                            },
                          ),
                          ElevatedButton(
                            child: const Text('3'),
                            onPressed: () {
                              if (widgets.length >= 3) {
                                setState(() {
                                  widgets.removeAt(2);
                                  json.removeAt(2);
                                  sort(json);
                                });
                              }
                              // Navigator.pop(context);
                            },
                          ),
                          ElevatedButton(
                            child: const Text('4'),
                            onPressed: () {
                              if (widgets.length >= 4) {
                                setState(() {
                                  widgets.removeAt(3);
                                  json.removeAt(3);
                                  sort(json);
                                });
                              }
                              // Navigator.pop(context);
                            },
                          ),
                          ElevatedButton(
                            child: const Text('5'),
                            onPressed: () {
                              if (widgets.length >= 5) {
                                setState(() {
                                  widgets.removeAt(4);
                                  json.removeAt(4);
                                  sort(json);
                                });
                              }
                              // Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              },
              child:
                  const Text("=> 本日のランキング <=", style: TextStyle(fontSize: 40))),
          ...widgets,
        ]),
      ),
    );
  }
  void sort(json){
    final entries = <Map<String, dynamic>>[];
    for (final row in json) {
      final lane = row['laneNum'] as int;
      final text = row['text'] as String;
      final color = row['color'] as String;
      final score = row['score'] as int;

      entries.add(
          {'lane': lane, 'text': text, 'color': color, 'score': score});
    }

    entries.sort((a, b) => b['score'].compareTo(a['score']));
    int i = 0;
    widgets=[];
    for (final entry in entries) {
      i++;
      widgets.add(Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No.$i / ',
                style: const TextStyle(fontSize: 50),
              ),
              Text("「${entry['text']} 」 様",
                  style: TextStyle(
                      fontSize: 50,
                      color: Color(int.parse(entry['color'])))),
              const Spacer(),
              Text("${entry['score']} 点",
                  style: const TextStyle(fontSize: 50)),
            ],
          ),
        ],
      ));
      if (widgets.length > 5) {
        widgets.removeLast();
      }
    }
  }
}
