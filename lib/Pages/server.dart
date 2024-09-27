import 'dart:convert';
import 'dart:io';

import 'package:darts/appbar_widget.dart';
import 'package:darts/get_ip.dart';
import 'package:darts/websocket.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ServerPage extends StatefulWidget {
  const ServerPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return ServerPageState();
  }
}

class ServerPageState extends State<ServerPage> with RouteAware {
  String? ip = "";
  List<String>? messages = [];
  WebSocketChannel? channel;
  HttpServer? server;
  int i = 0;
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
  final exePath = Platform.resolvedExecutable;
  String fileName =
      "${DateFormat('yyyy-MM-dd_HH_mm_ss-').format(DateTime.now())}data.json";

  @override
  void initState() {
    i = 0;
    super.initState();
    initialize();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute) {
      routeObserver.subscribe(this, modalRoute);
    }
  }

  @override
  void didPush() {
    socketDispose(channel);
    i++;
    if (i > 1) {
      Future.delayed(const Duration(seconds: 2), () {
        server?.close(force: true);
      });
    }
  }

  Future<void> saveJsonToFile(List<String>? jsonData) async {
    try {
      final exeDir = File(exePath).parent.path;
      final path = '$exeDir/$fileName';
      final file = File(path);
      await file.writeAsString("$jsonData");
    } catch (e) {
      print("Failed to save JSON data: $e");
    }
  }

  Future<Object> pickAndLoadJsonFile() async {
    try {
      final exeDir = File(exePath).parent.path;
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        initialDirectory: exeDir,
      );

      if (result != null && result.files.single.path != null) {
        String filePath = result.files.single.path!;
        File file = File(filePath);
        String contents = await file.readAsString();
        channel = IOWebSocketChannel.connect(websocketURL("localhost"));
        // 文字列をListとしてデコード
        List<dynamic> jsonList = jsonDecode(contents);

        // 各オブジェクトをStringに変換し、List<String>にする
        List<String> stringList =
            jsonList.map((item) => jsonEncode(item)).toList();

        for (String content in stringList) {
          channel?.sink.add(content);
        }
        return contents;
      } else {
        print("No file selected");
        return [];
      }
    } catch (e) {
      print("Error loading JSON file: $e");
      return [];
    }
  }

  Future<void> initialize() async {
    final ipWs = await getIp();
    server = await wsServer();
    setState(() {
      ip = ipWs;
      channel = IOWebSocketChannel.connect(websocketURL(ip!));
      channel?.stream.listen((message) async {
        setState(() {
          messages?.add(message);
        });
        await saveJsonToFile(messages);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: <NavigatorObserver>[routeObserver],
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
              Text(
                "貴方のIPアドレス：$ip",
                style: const TextStyle(fontSize: 30),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: messages?.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 20,
                    child: Center(
                      child: Text(
                        messages![index],
                      ),
                    ),
                  );
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    final jsonData = await pickAndLoadJsonFile();
                    print(jsonData);
                  },
                  child: const Text("データの再読み込み")),
            ],
          ),
        ),
      ),
    );
  }
}
