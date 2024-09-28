import 'dart:io';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

WebSocket? wsLatest;

Future<HttpServer> wsServer() async {
  final connections = <WebSocket>{};

  final server = await HttpServer.bind(InternetAddress.anyIPv4, 3000);
  void wsHandler(WebSocket ws) {
    ws.listen((message) {
      for (final connection in connections) {
        connection.add(message);
      }
    }, onDone: (() {
      connections.remove(ws);
    }));
  }

  server
      .where((request) => request.uri.path == '/ws')
      .transform(WebSocketTransformer())
      .listen((WebSocket ws) {
    wsLatest = ws;
    connections.add(ws);
    wsHandler(ws);
  });

  return server;
}

WebSocket? getWebSocket() {
  return wsLatest;
}

String websocketURL(String ip) {
  if (ip.contains("tksn.me")) {
    return "wss://$ip/ws";
  } else {
    return "ws://$ip:3000/ws";
  }
}

String sendJson(int protocol, List<String> arg) {
  String jsonText = "";
  switch (protocol) {
    // case 1:
    //   //IPごとのページ遷移
    //   jsonText = "{\"protocol\":1,\"ip\":\"${arg[0]}\",\"newPage\":${arg[1]}}";
    //   break;
    case 2:
      //受付のお客様の名前と色
      jsonText =
          "{\"protocol\":2,\"ip\":\"${arg[0]}\",\"text\":\"${arg[1]}\",\"color\":\"${arg[2].toString().replaceAll("(", "").replaceAll(")", "").replaceAll("Color", "")}\"}";
      break;
    case 3:
      //受付のお客様の名前と色がどのレーンにいくのかvalue=lane
      jsonText =
          "{\"protocol\":3,\"ip\":\"${arg[0]}\",\"text\":\"${arg[1]}\",\"color\":\"${arg[2]}\",\"value\":\"${arg[3]}\"}";
      break;
    case 4:
      //スコア
      jsonText =
          "{\"protocol\":4,\"ip\":\"${arg[0]}\",\"laneNum\":${arg[1]},\"point\":\"${arg[2]}\"}";
      break;
    case 5:
      //スコア計測完了
      jsonText =
          "{\"protocol\":5,\"ip\":\"${arg[0]}\",\"laneNum\":${arg[1]},\"text\":\"${arg[2]}\",\"color\":\"${arg[3]}\",\"score\":${arg[4]}}";
      break;
    case 6:
      //スコア削除
      jsonText =
          "{\"protocol\":6,\"ip\":\"${arg[0]}\",\"laneNum\":${arg[1]},\"pointNum\":${arg[2]}}";
      break;
    case 7:
      //スコア変更
      jsonText =
          "{\"protocol\":7,\"ip\":\"${arg[0]}\",\"laneNum\":${arg[1]},\"pointNum\":${arg[2]},\"newPoint\":${arg[3]}}";
      break;
    case 8:
      //受付案内終了
      jsonText = "{\"protocol\":8,\"ip\":\"${arg[0]}\"}";
    case 9:
      //old lane
      jsonText = "{\"protocol\":9,\"old\":${arg[0]}}";
    // case 10:
    // //スコアDelete
    //   jsonText =
    //   "{\"protocol\":10,\"ip\":\"${arg[0]}\",\"laneNum\":${arg[1]},\"text\":\"${arg[2]}\",\"color\":\"${arg[3]}\",\"score\":${arg[4]}}";
  }
  return jsonText;
}

void socketDispose(WebSocketChannel? channel) {
  channel?.sink.close(status.goingAway);
}
