import 'package:darts/websocket.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class LaneScoreboardManagementDialogWidget extends StatelessWidget {
  final int laneNum;
  final int pointNum;
  final String? serverIp;

  const LaneScoreboardManagementDialogWidget(
      {super.key,
      required this.laneNum,
      required this.pointNum,
      required this.serverIp});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('スコアボード管理（$laneNumレーンの$pointNum）'),
      content: const Text('修正方法'),
      actions: <Widget>[
        DropdownButton(
          items: const [
            DropdownMenuItem(
              value: '修正',
              child: Text('修正'),
            ),
            DropdownMenuItem(
              value: '削除',
              child: Text('削除'),
            ),
          ],
          onChanged: (String? value) {
            String? valueNum;
            if (value == "修正") {
              Navigator.pop(context);
              showDialog<void>(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                        title: Text('スコアボード管理（$laneNumレーンの$pointNum）'),
                        content: const Text('修正後の値'),
                        actions: <Widget>[
                          TextField(
                            onChanged: (text) {
                              valueNum = text;
                            },
                          ),
                          Builder(builder: (context) {
                            return ElevatedButton(
                                onPressed: () {
                                  final channel = IOWebSocketChannel.connect(
                                      websocketURL(serverIp!));
                                  channel.sink.add(sendJson(7, [
                                    serverIp!,
                                    laneNum.toString(),
                                    pointNum.toString(),
                                    valueNum.toString()
                                  ]));
                                  Navigator.pop(context);
                                },
                                child: const Text("決定"));
                          })
                        ]);
                  });
            } else if (value == "削除") {
              final channel =
                  IOWebSocketChannel.connect(websocketURL(serverIp!));
              channel.sink.add(sendJson(
                  6, [serverIp!, laneNum.toString(), pointNum.toString()]));
              Navigator.pop(context);
            }
          },
        )
      ],
    );
  }
}
