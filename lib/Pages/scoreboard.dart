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

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() {
    channel = IOWebSocketChannel.connect(websocketURL(widget.serverIp!));
    final json = [];
    channel?.stream.listen((message) {
      final data = jsonDecode(message);
      widgets = [];
      // if (data["protocol"] == 10) {
      //   // 消したい項目: text, color, score が一致するもの
      //   String targetText = data['text'];
      //   String targetColor = data['color'];
      //   int targetScore = data['score'];
      //
      //   setState(() {
      //     // widgets の内容を検索して一致するウィジェットを削除
      //     widgets.removeWhere((widget) {
      //       if (widget is Column) {
      //         final row = widget.children.first as Row;
      //         final textWidget = row.children[1] as Text;
      //         final scoreWidget = row.children.last as Text;
      //
      //         // Text ウィジェットのデータ取得
      //         String widgetText = textWidget.data!;
      //         String widgetColor = widgetText.split(' ')[1]; // 色を取り出す仮の処理
      //         int widgetScore = int.parse(scoreWidget.data!);
      //
      //         // text, color, score が一致するかをチェック
      //         return widgetText == targetText &&
      //             widgetColor == targetColor &&
      //             widgetScore == targetScore;
      //       }
      //       return false;
      //     });
      //   });
      //   //既に表示されているwidgetから上限が合うwidgetsの一部を消す。
      //   //"{\"protocol\":10,\"ip\":\"${arg[0]}\",\"laneNum\":${arg[1]},\"text\":\"${arg[2]}\",\"color\":\"${arg[3]}\",\"score\":${arg[4]}}"
      // }
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
                    style: const TextStyle(fontSize: 60),
                  ),
                  Text("「${entry['text']} 」 様",
                      style: TextStyle(
                          fontSize: 60,
                          color: Color(int.parse(entry['color'])))),
                  const Spacer(),
                  Text("${entry['score']} 点",
                      style: const TextStyle(fontSize: 60)),
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
                        title: const Text('どの順位のデータを消しますか？'),
                        actions: <Widget>[
                          ElevatedButton(
                            child: const Text('1'),
                            onPressed: () {
                              print(widgets.length);
                              if (widgets.isNotEmpty) {
                                setState(() {
                                  widgets.removeAt(0);
                                });
                              }
                              Navigator.pop(context);
                            },
                          ),
                          ElevatedButton(
                            child: const Text('2'),
                            onPressed: () {
                              if (widgets.length >= 2) {
                                setState(() {
                                  widgets.removeAt(1);
                                });
                              }
                              Navigator.pop(context);
                            },
                          ),
                          ElevatedButton(
                            child: const Text('3'),
                            onPressed: () {
                              if (widgets.length >= 3) {
                                setState(() {
                                  widgets.removeAt(2);
                                });
                              }
                              Navigator.pop(context);
                            },
                          ),
                          ElevatedButton(
                            child: const Text('4'),
                            onPressed: () {
                              if (widgets.length >= 4) {
                                setState(() {
                                  widgets.removeAt(3);
                                });
                              }
                              Navigator.pop(context);
                            },
                          ),
                          ElevatedButton(
                            child: const Text('5'),
                            onPressed: () {
                              if (widgets.length >= 5) {
                                setState(() {
                                  widgets.removeAt(4);
                                });
                              }
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              },
              child:
                  const Text("=> 本日のランキング <=", style: TextStyle(fontSize: 50))),
          ...widgets,
          const Text("=> 昨日のランキング <=", style: TextStyle(fontSize: 50)),
          const Row(
            children: [
              Text("No.1 /「ひよ」 様", style: TextStyle(fontSize: 50)),
              Spacer(),
              Text("129 点", style: TextStyle(fontSize: 50)),
            ],
          ),
          const Row(
            children: [
              Text("No.2 /「こばれん」 様", style: TextStyle(fontSize: 50)),
              Spacer(),
              Text("120 点", style: TextStyle(fontSize: 50)),
            ],
          ),
          const Row(
            children: [
              Text("No.3 /「ゆうな」 様", style: TextStyle(fontSize: 50)),
              Spacer(),
              Text("120 点", style: TextStyle(fontSize: 50)),
            ],
          ),
          const Row(
            children: [
              Text("No.4 /「null」 様", style: TextStyle(fontSize: 50)),
              Spacer(),
              Text("117 点", style: TextStyle(fontSize: 50)),
            ],
          ),
          const Row(
            children: [
              Text("No.5 /「みらい」 様", style: TextStyle(fontSize: 50)),
              Spacer(),
              Text("110 点", style: TextStyle(fontSize: 50)),
            ],
          ),
        ]),
      ),
    );
  }
}
