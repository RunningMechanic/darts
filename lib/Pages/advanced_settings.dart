import 'package:darts/appbar_widget.dart';
import 'package:darts/websocket.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class AdvancedSettings extends StatefulWidget {
  final String? serverIp;

  const AdvancedSettings({super.key, required this.serverIp});

  @override
  State<StatefulWidget> createState() {
    return AdvancedSettingsState();
  }
}

class AdvancedSettingsState extends State<AdvancedSettings> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
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
            child: AppBarWidget(title: "管理サーバー")),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "コマンドを入力",
                style: TextStyle(fontSize: 30),
              ),
              TextFormField(
                controller: _controller,
              ),
              ElevatedButton(
                  onPressed: () {
                    final channel = IOWebSocketChannel.connect(
                        websocketURL(widget.serverIp!));
                    channel.sink.add(_controller.text);
                  },
                  child: const Text("決定"))
            ],
          ),
        ),
      ),
    );
  }
}
