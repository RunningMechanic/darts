import 'dart:io';

import 'package:darts/main.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatefulWidget {
  final String? title;

  const AppBarWidget({super.key, required this.title});

  @override
  State<StatefulWidget> createState() {
    return AppBarWidgetState();
  }
}

class AppBarWidgetState extends State<AppBarWidget> {
  bool longPressed = false;
  int longPressedNum = 0;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 105.0,
      title: Row(
        children: [
          SizedBox(
              width: 100, height: 100, child: Image.asset('assets/icon.png')),
          TextButton(
              onLongPress: () {
                longPressed = true;
                longPressedNum++;
              },
              onPressed: () {
                if (longPressedNum == 3) {
                  longPressedNum = 0;
                  exit(0);
                } else if (longPressed) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyApp()),
                  );
                }
                longPressed = false;
              },
              child: Text(
                'ダーツであそぼ（${widget.title}）',
                style: const TextStyle(color: Colors.black, fontSize: 70),
              ))
        ],
      ),
      backgroundColor: Colors.green,
    );
  }
}
