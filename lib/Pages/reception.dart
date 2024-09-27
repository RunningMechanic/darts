import 'package:darts/appbar_widget.dart';
import 'package:darts/Pages/reception_enter.dart';
import 'package:darts/color.dart';
import 'package:darts/websocket.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class ReceptionPage extends StatefulWidget {
  final String? serverIp;

  const ReceptionPage({super.key, required this.serverIp});

  @override
  State<StatefulWidget> createState() {
    return ReceptionPageState();
  }
}

class ReceptionPageState extends State<ReceptionPage> {
  final textFieldController = TextEditingController();
  Color? sColors = Colors.black;
  String text = "";

//   WebSocketChannel? channel;
// void back(){
//   channel = IOWebSocketChannel.connect(websocketURL(widget.serverIp!));
//
//   channel?.stream.listen((message) {
//     if(message["protocol"]==3 && message["text"]==text){}
//   });
// }
  void colorSelect(String changedText) {
    setState(() {
      if (changedText.contains("&")
          //&& changedText.indexOf("&") + 2 < changedText.length
          ) {
        try {
          text = changedText.substring(0, changedText.indexOf("&")) +
              changedText.substring(
                  changedText.indexOf("&") + 2, changedText.length);
        } on RangeError catch (e) {
          print('RangeError occurred: $e');
        }
      } else {
        text = changedText;
      }
    });

    setState(() {
      sColors = colorSection(changedText) ?? Colors.black;
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
              child: AppBarWidget(title: "受付")),
          body: Stack(
            children: [
              Column(
                children: [
                  const Padding(padding: EdgeInsets.all(10)),
                  const Text(
                    "受付案内",
                    style: TextStyle(
                        fontSize: 80, decoration: TextDecoration.underline),
                  ),
                  Text(
                    text,
                    style: TextStyle(fontSize: 50, color: sColors),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(100, 10, 100, 10),
                    child: TextField(
                      style: TextStyle(
                        color: sColors,
                      ),
                      onChanged: (changedText) {
                        colorSelect(changedText);
                      },
                      controller: textFieldController,
                      decoration: const InputDecoration(
                        labelText: 'ニックネームを入れてね',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  SizedBox(
                      width: 200,
                      height: 100,
                      child: TextButton(
                        onPressed: () async {
                          if (text.isEmpty) {
                            return; // 0文字の場合のエラーメッセージ
                          } else if (text.length > 10) {
                            return; // 10文字を超えた場合のエラーメッセージ
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReceptionEnterPage(
                                      serverIp: widget.serverIp!,
                                      name: text,
                                      nameColor: sColors ?? Colors.black,
                                    )),
                          );
                          final channel = IOWebSocketChannel.connect(
                              websocketURL(widget.serverIp!));
                          channel.sink.add(sendJson(2, [
                            widget.serverIp!,
                            text,
                            (sColors ?? Colors.black).value.toString()
                          ]));
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(color: Colors.black)),
                        ),
                        child: const Text(
                          "決定",
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                      )),
                  const Padding(padding: EdgeInsets.all(10)),
                  const Text(
                    "※ニックネームは１文字以上１０文字以内。\n※グループの場合はグループ名。\n※１グループ３人まで。\n※終わったら近くの係員に教えてね。",
                    style: TextStyle(color: Colors.red),
                  )
                ],
              ),
              // const Padding(padding: EdgeInsets.all(200)),
              // Positioned(
              //   right: 10, // 画面の右から10ピクセルの位置
              //   bottom: 10, // 画面の下から10ピクセルの位置
              //   child: Container(
              //       alignment: Alignment.bottomRight,
              //       child: Text("serverIP:${widget.serverIp!}")),
              // ),
            ],
          )),
    );
  }
}
