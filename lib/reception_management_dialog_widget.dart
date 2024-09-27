import 'package:darts/websocket.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class ReceptionManagementDialogWidget extends StatelessWidget {
  final String serverIp;
  final String name;
  final String color;
  final String ip;

  const ReceptionManagementDialogWidget(
      {super.key,
      required this.ip,
      required this.serverIp,
      required this.name,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('受付管理'),
      content: const Text('何レーンに移動させますか？'),
      actions: <Widget>[
        DropdownButton(
          items: const [
            DropdownMenuItem(
              value: '1',
              child: Text('1'),
            ),
            DropdownMenuItem(
              value: '2',
              child: Text('2'),
            ),
            DropdownMenuItem(
              value: '3',
              child: Text('3'),
            ),
            DropdownMenuItem(
              value: '4',
              child: Text('4'),
            ),
            DropdownMenuItem(
              value: '5',
              child: Text('5'),
            ),
          ],
          onChanged: (String? value) {
            final channel = IOWebSocketChannel.connect(websocketURL(serverIp));
            channel.sink.add(sendJson(3, [serverIp, name, color, value!]));
            channel.sink.add(sendJson(8, [ip]));
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
