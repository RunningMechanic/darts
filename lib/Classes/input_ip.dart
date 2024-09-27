import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class InputIpClass {
  String ip = "";
  String lane = "";
  int loadingNum = 0;
  String loadingText = "";
  String loadingText2 = "";
  MaterialColor color = Colors.green;
  IOWebSocketChannel? channel;
  bool connect = false;
  bool field2IsVisible = false;

  void setValueAll() {
    loadingNum = 0;
    loadingText = "";
    loadingText2 = "";
    color = Colors.green;
  }

  void setValue() {
    loadingText = "";
    loadingText2 = "";
    loadingNum++;
  }
}
