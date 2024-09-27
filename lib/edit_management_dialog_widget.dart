import 'package:darts/websocket.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class EditManagementDialogWidget extends StatefulWidget {
  final String serverIp;
  final String name;
  final String color;
  final String ip;
  final String lane;

  const EditManagementDialogWidget(
      {super.key,
      required this.ip,
      required this.serverIp,
      required this.name,
      required this.color,
      required this.lane});

  @override
  State<StatefulWidget> createState() {
    return EditManagementDialogWidgetState();
  }
}

class EditManagementDialogWidgetState
    extends State<EditManagementDialogWidget> {
  String num = "";
  int number = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('最終的なスコアを教えてね'),
      content: Text("今選択している数字。（$num）"),
      actions: <Widget>[
        Column(children: [
          ElevatedButton(
              onPressed: () {
                num = "${num}1";
                setState(() {});
              },
              child: const Text("1")),
          const Padding(padding: EdgeInsets.all(5)),
          ElevatedButton(
              onPressed: () {
                num = "${num}4";
                setState(() {});
              },
              child: const Text("4")),
          const Padding(padding: EdgeInsets.all(5)),
          ElevatedButton(
              onPressed: () {
                num = "${num}7";
                setState(() {});
              },
              child: const Text("7")),
          const Padding(padding: EdgeInsets.all(5)),
          ElevatedButton(
              onPressed: () {
                num = num.substring(0, num.length - 1);
                setState(() {});
              },
              child: const Text("消")),
        ]),
        Column(children: [
          ElevatedButton(
              onPressed: () {
                num = "${num}2";
                setState(() {});
              },
              child: const Text("2")),
          const Padding(padding: EdgeInsets.all(5)),
          ElevatedButton(
              onPressed: () {
                num = "${num}5";
                setState(() {});
              },
              child: const Text("5")),
          const Padding(padding: EdgeInsets.all(5)),
          ElevatedButton(
              onPressed: () {
                num = "${num}8";
                setState(() {});
              },
              child: const Text("8")),
          const Padding(padding: EdgeInsets.all(5)),
          ElevatedButton(
              onPressed: () {
                num = "${num}0";
                setState(() {});
              },
              child: const Text("0")),
        ]),
        Column(children: [
          ElevatedButton(
              onPressed: () {
                num = "${num}3";
                setState(() {});
              },
              child: const Text("3")),
          const Padding(padding: EdgeInsets.all(5)),
          ElevatedButton(
              onPressed: () {
                num = "${num}6";
                setState(() {});
              },
              child: const Text("6")),
          const Padding(padding: EdgeInsets.all(5)),
          ElevatedButton(
              onPressed: () {
                num = "${num}9";
                setState(() {});
              },
              child: const Text("9")),
          const Padding(padding: EdgeInsets.all(5)),
          ElevatedButton(
              onPressed: () {
                bool check = true;
                try {
                  number = int.parse(num);
                } catch (e) {
                  check = false;
                }
                Future.delayed(const Duration(seconds: 1), () {
                  if (check) {
                    final channel = IOWebSocketChannel.connect(
                        websocketURL(widget.serverIp));
                    channel.sink.add(sendJson(5, [
                      widget.serverIp,
                      widget.lane,
                      widget.name,
                      widget.color,
                      num
                    ]));
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  }
                });

                //"{\"protocol\":5,\"ip\":\"${arg[0]}\",\"laneNum\":${arg[1]},\"text\":\"${arg[2]}\",\"color\":\"${arg[3]}\",\"score\":${arg[4]}}";
              },
              child: const Text("決定")),
        ]),
      ],
    );
  }
}
