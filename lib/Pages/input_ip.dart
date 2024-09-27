import 'dart:async';

import 'package:darts/Classes/input_ip.dart';
import 'package:darts/Pages/advanced_settings.dart';
import 'package:darts/Pages/reception.dart';
import 'package:darts/Pages/reception_management.dart';
import 'package:darts/Pages/lane_scoreboard.dart';
import 'package:darts/Pages/scoreboard.dart';
import 'package:darts/Pages/server.dart';
import 'package:darts/appbar_widget.dart';
import 'package:darts/websocket.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class InputIpPage extends StatefulWidget {
  final int newPage;

  const InputIpPage({super.key, required this.newPage});

  @override
  State<StatefulWidget> createState() {
    return InputIpPageState();
  }
}

class InputIpPageState extends State<InputIpPage> {
  final timeMax = 9;
  bool buttonValid = true;
  InputIpClass C = InputIpClass();

  @override
  void initState() {
    super.initState();
    if (widget.newPage == 3) C.field2IsVisible = true;
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
            child: AppBarWidget(title: "設定入力")),
        body: Column(
          children: [
            const Padding(padding: EdgeInsets.all(20)),
            SizedBox(
              width: 700,
              child: TextField(
                onChanged: (changedText) {
                  setState(() {
                    C.ip = changedText;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'サーバーIPを入れてね',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            C.field2IsVisible
                ? SizedBox(
                    width: 700,
                    child: TextField(
                      onChanged: (changedText) {
                        setState(() {
                          C.lane = changedText;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'レーン番号を入れてね',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            const Padding(padding: EdgeInsets.all(5)),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(250, 150),
                ),
                onPressed: buttonValid == false
                    ? null
                    : () async {
                        buttonValid = false;
                        C.setValueAll();
                        Timer.periodic(
                          const Duration(seconds: 1),
                          (Timer timer) {
                            C.setValue();
                            if (C.loadingNum >= timeMax) {
                              timer.cancel();
                            }
                            for (int i = 0; i < C.loadingNum; i++) {
                              C.loadingText = '${C.loadingText}|';
                            }
                            for (int i = 0; i < timeMax - C.loadingNum; i++) {
                              C.loadingText2 = '${C.loadingText2}|';
                            }
                            setState(() {});
                          },
                        );
                        Widget page = const ServerPage();
                        Future.delayed(Duration(seconds: timeMax), () {
                          if (C.connect) {
                            // C.channel?.sink.add(
                            //     sendJson(1, [C.ip, widget.newPage.toString()]));
                            switch (widget.newPage) {
                              case 1:
                                page = ReceptionPage(serverIp: C.ip);
                                break;
                              case 2:
                                page = ReceptionManagementPage(serverIp: C.ip);
                                break;
                              case 3:
                                page = LaneScoreboardPage(
                                    serverIp: C.ip, lane: int.parse(C.lane));
                                break;
                              // case 4:
                              //   page = LaneScoreboardManagementPage(
                              //       serverIp: C.ip);
                              //   break;
                              case 5:
                                page = ScoreboardPage(serverIp: C.ip);
                                break;
                              case 6:
                                page = const ServerPage();
                                break;
                              case 7:
                                page = AdvancedSettings(serverIp: C.ip);
                            }
                            if (widget.newPage == 3 && C.lane != "") {
                              if (!context.mounted) return;
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => page),
                              );
                            } else if (widget.newPage != 3) {
                              if (!context.mounted) return;
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => page),
                              );
                            }
                          } else {
                            C.color = Colors.red;
                            buttonValid = true;
                          }
                        });
                        C.connect = true;
                        try {
                          C.channel =
                              IOWebSocketChannel.connect(websocketURL(C.ip));
                          await C.channel?.ready;
                        } catch (e) {
                          C.connect = false;
                        }
                      },
                child: const Text(
                  "決定",
                  style: TextStyle(fontSize: 40),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(C.loadingText,
                    style: TextStyle(fontSize: 70, color: C.color)),
                Text(C.loadingText2, style: const TextStyle(fontSize: 70)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
