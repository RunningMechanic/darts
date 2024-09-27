import 'dart:convert';
import 'package:darts/appbar_widget.dart';
import 'package:darts/edit_management_dialog_widget.dart';
import 'package:darts/reception_management_dialog_widget.dart';
import 'package:darts/websocket.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ReceptionManagementPage extends StatefulWidget {
  final String? serverIp;

  const ReceptionManagementPage({super.key, required this.serverIp});

  @override
  State<StatefulWidget> createState() {
    return ReceptionManagementPageState();
  }
}

class ReceptionManagementPageState extends State<ReceptionManagementPage> {
  List<Widget> widgets = [];
  WebSocketChannel? channel;
  List<Map<String, dynamic>> json = [];
  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() {
    channel = IOWebSocketChannel.connect(websocketURL(widget.serverIp!));
    channel?.stream.listen((message) {
      final data = jsonDecode(message);
      if (data['protocol'] == 3) {
        _removeNullLanes();
        _handleProtocol3Message(data);
      } else if (data['protocol'] == 2) {
        _addNewMessage(data);
      }
    });
  }

  void _handleProtocol3Message(Map<String, dynamic> data) {
    print('Received data: $data'); // Debug output for received data

    // Received data's text, color, and value
    String receivedText = data['text'];
    String receivedColor = data['color'];
    String receivedValue = data['value']?.toString() ?? "???";

    // Check if an existing entry should be updated or added
    bool updated = false;

    // Update lane values
    for (var row in json) {
      if (row['text'] == receivedText && row['color'] == receivedColor) {
        if (row['value'] == "???") {
          setState(() {
            row['value'] = receivedValue; // Update existing entry
            updated = true;
            print('Updated lane for ${row['text']}: ${row['value']}');
          });
        }
      }
    }

    // If no updates, add new data
    if (!updated) {
      json.add(data);
      setState(() {
        widgetSet(data); // Update the widget set
      });
    } else {
      widgetSet(data); // Update the widget set
    }
  }

  void _addNewMessage(Map<String, dynamic> data) {
    // Add a new message to the json list and update the widget set
    json.add(data);
    setState(() {
      widgetSet(data);
    });
  }

  void widgetSet(Map<String, dynamic> message) {
    setState(() {
      widgets.clear(); // Clear existing widgets

      final ipData = <String, List<Map<String, String>>>{};

      // Build the ipData structure
      for (final row in json) {
        final ip = row['ip'] as String;
        final text = row['text'] as String;
        final color = row['color'] as String;
        final value = row['value'].toString() as String? ?? "???";
        ipData[ip] ??= [];
        ipData[ip]!.add({'text': text, 'color': color, 'value': value});
      }

      // Create widgets based on the ipData
      for (final ip in ipData.keys) {
        widgets.add(Center(
            child: Column(children: [
          Text(
            "=== $ip ===",
            style: const TextStyle(fontSize: 30),
          )
        ])));

        for (final entry in ipData[ip]!) {
          widgets.add(Column(
            children: [
              const Padding(padding: EdgeInsets.all(4)),
              Container(
                width: 1000,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(padding: EdgeInsets.all(4)),
                          Text(
                            '${entry['text']} （ ${entry['value']} レーン）',
                            style: TextStyle(
                                fontSize: 30,
                                color: Color(int.parse(entry['color']!))),
                          ),
                          const Spacer(),
                          // ElevatedButton(
                          //   style: ElevatedButton.styleFrom(
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(10),
                          //       ),
                          //       backgroundColor: Colors.yellow),
                          //   onPressed: () {
                          //     setState(() {
                          //       ipData[ip]!.remove(entry);
                          //       if (ipData[ip]!.isEmpty) {
                          //         ipData.remove(ip); // Remove IP if no entries left
                          //       }
                          //       print(json);
                          //       print(row['color']);
                          //       json.removeWhere((row) =>
                          //       row['text'] == entry['text'] &&
                          //           row['color'] == entry['color']);
                          //       widgetSet(message); // Update the widget set
                          //     });
                          //   },
                          //   child: SizedBox(
                          //       width: 40,
                          //       height: 40,
                          //       child: Image.asset(
                          //         "assets/delete.png",
                          //         scale: 20,
                          //       )),
                          // ),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Colors.red),
                            onPressed: () {
                              if (entry['value'] == "???") return;
                              showDialog<void>(
                                  context: context,
                                  builder: (_) {
                                    return EditManagementDialogWidget(
                                      ip: ip,
                                      serverIp: widget.serverIp!,
                                      name: entry['text']!,
                                      color: entry['color']!,
                                      lane: entry['value']!,
                                    );
                                  });
                            },
                            child: SizedBox(
                                width: 40,
                                height: 40,
                                child: Image.asset(
                                  "assets/edit.png",
                                  scale: 20,
                                )),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Colors.blue),
                            onPressed: () {
                              // json.removeWhere((row) =>
                              // row['protocol'] == 2);
                              // widgetSet(message);
                              showDialog<void>(
                                  context: context,
                                  builder: (_) {
                                    return ReceptionManagementDialogWidget(
                                      ip: ip,
                                      serverIp: widget.serverIp!,
                                      name: entry['text']!,
                                      color: entry['color']!,
                                    );
                                  });
                            },
                            child: SizedBox(
                                width: 40,
                                height: 40,
                                child: Image.asset(
                                  "assets/settings2.png",
                                  scale: 20,
                                )),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ));
        }
      }
    });
  }

  @override
  void dispose() {
    channel?.sink.close();
    super.dispose();
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
              child: AppBarWidget(title: "受付画面の管理")),
          body: SingleChildScrollView(
            child: Column(
              children: [...widgets],
            ),
          )),
    );
  }

  void _removeNullLanes() {
    json.removeWhere((row) => row['protocol'] == 2);
    widgetSet({});
  }
}
