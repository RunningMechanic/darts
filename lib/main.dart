import 'package:darts/button_field_widget.dart';
import 'package:darts/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await WindowManager.instance.setFullScreen(true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
          useMaterial3: true,
          fontFamily: 'DelaGothicOne'),
      debugShowCheckedModeBanner: false,
      title: 'ダーツで遊ぼ',
      home: const Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(105.0),
            child: AppBarWidget(
              title: "ホーム",
            )),
        body: Column(
          children: [
            Padding(padding: EdgeInsets.all(10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonFieldWidget(
                    buttonText: '受付画面',
                    imagePath: 'assets/reception.png',
                    buttonNum: 1),
                ButtonFieldWidget(
                    buttonText: '受付画面（管理）',
                    imagePath: 'assets/receptionManagement.png',
                    buttonNum: 2),
                ButtonFieldWidget(
                    buttonText: '各レーンの得点表示',
                    imagePath: 'assets/darts.png',
                    buttonNum: 3),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ButtonFieldWidget(
                  buttonText: '詳細設定',
                  imagePath: 'assets/gear.png',
                  buttonNum: 7),
              ButtonFieldWidget(
                  buttonText: 'スコアボード',
                  imagePath: 'assets/scoreboard.png',
                  buttonNum: 5),
              ButtonFieldWidget(
                  buttonText: '管理サーバー',
                  imagePath: 'assets/server.png',
                  buttonNum: 6),
            ]),
          ],
        ),
      ),
    );
  }
}
