// import 'dart:convert';
// import 'dart:math';
// import 'package:darts/appbar_widget.dart';
// import 'package:darts/lane_scoreboard_management_dialog.dart';
// import 'package:darts/lane_scoreboard_management_list_widget.dart';
// import 'package:darts/websocket.dart';
// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
//
// class LaneScoreboardManagementPage extends StatefulWidget {
//   final String? serverIp;
//
//   const LaneScoreboardManagementPage({super.key, required this.serverIp});
//
//   @override
//   State<StatefulWidget> createState() {
//     return LaneScoreboardManagementPageState();
//   }
// }
//
// class LaneScoreboardManagementPageState
//     extends State<LaneScoreboardManagementPage> {
//   WebSocketChannel? channel;
//   List<Widget> widgets = [];
//   var json = [];
//
//   @override
//   void initState() {
//     super.initState();
//     initialize();
//   }
//
//   void initialize() {
//     channel = IOWebSocketChannel.connect(websocketURL(widget.serverIp!));
//     channel?.stream.listen((message) {
//       final decodedMessage = jsonDecode(message);
//       if (decodedMessage['protocol'] == 7) {
//         int j = 0;
//         for (int i = 0; i < json.length; i++) {
//           if (json[i]['laneNum'] == decodedMessage['laneNum']) {
//             j++;
//             if (j == decodedMessage['pointNum']) {
//               setState(() {
//                 json[i]['point'] = decodedMessage['newPoint'];
//               });
//             }
//           }
//         }
//         generateWidgets(message);
//       } else if (jsonDecode(message)['protocol'] == 6) {
//         int k = 0;
//         for (int i = 0; i < json.length; i++) {
//           if (json[i]['laneNum'] == decodedMessage['laneNum']) {
//             k++;
//             if (k == decodedMessage['pointNum']) {
//               json.removeAt(i);
//             }
//           }
//         }
//         generateWidgets(message);
//       }
//       if (jsonDecode(message)['protocol'] != 4) return;
//       generateWidgets(message);
//     });
//   }
//
//   void generateWidgets(message) {
//     setState(() {
//       final data = jsonDecode(message);
//       if (data['protocol'] == 4) {
//         json.add(data);
//       }
//       final laneData = <int, List<int>>{};
//       for (final row in json) {
//         final lane = row['laneNum'] as int;
//         final point = row['point'] as int;
//
//         laneData[lane] ??= [];
//         laneData[lane]!.add(point);
//       }
//
//       final maxLane = laneData.keys.fold(0, (a, b) => max(a, b));
//       widgets = [];
//       for (int lane = 0; lane <= maxLane; lane++) {
//         final points = laneData[lane];
//         if (points == null) continue;
//         widgets.add(Text(
//           "=== $lane lane ===",
//           style: const TextStyle(fontSize: 30),
//         ));
//         int i = 0;
//         for (final point in points) {
//           i++;
//           widgets.add(Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Padding(padding: EdgeInsets.all(4)),
//               Text(
//                 "Point($i): $point",
//                 style: const TextStyle(fontSize: 30, color: Colors.black),
//               ),
//               const Spacer(),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     backgroundColor: Colors.blue),
//                 onPressed: () {
//                   showDialog<void>(
//                       context: context,
//                       builder: (_) {
//                         return LaneScoreboardManagementDialogWidget(
//                             serverIp: widget.serverIp,
//                             laneNum: lane,
//                             pointNum: i);
//                       });
//                 },
//                 child: SizedBox(
//                     width: 40,
//                     height: 40,
//                     child: Image.asset(
//                       "assets/settings2.png",
//                       scale: 20,
//                     )),
//               )
//             ],
//           ));
//         }
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     socketDispose(channel);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
//           useMaterial3: true,
//           fontFamily: 'DelaGothicOne'),
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: const PreferredSize(
//             preferredSize: Size.fromHeight(105.0),
//             child: AppBarWidget(title: "レーンスコアボード管理")),
//         body: Column(
//           children: [LaneScoreboardManagementListWidget(widgets: widgets)],
//         ),
//       ),
//     );
//   }
// }
