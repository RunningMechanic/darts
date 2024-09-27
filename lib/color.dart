import 'package:flutter/material.dart';

Color? colorSection(String changedText) {
  Color? sColors;
  if (changedText.contains("&a")) {
    sColors = const Color(0xff55FF55);
  } else if (changedText.contains("&b")) {
    sColors = const Color(0xff55FFFF);
  } else if (changedText.contains("&c")) {
    sColors = const Color(0xffFF5555);
  } else if (changedText.contains("&d")) {
    sColors = const Color(0xffFF55FF);
  } else if (changedText.contains("&e")) {
    sColors = const Color(0xffFFFF55);
  } else if (changedText.contains("&g")) {
    sColors = const Color(0xffDDD605);
  } else if (changedText.contains("&0")) {
    sColors = const Color(0xff000000);
  } else if (changedText.contains("&1")) {
    sColors = const Color(0xff0000AA);
  } else if (changedText.contains("&2")) {
    sColors = const Color(0xff00AA00);
  } else if (changedText.contains("&3")) {
    sColors = const Color(0xff00AAAA);
  } else if (changedText.contains("&4")) {
    sColors = const Color(0xffAA0000);
  } else if (changedText.contains("&5")) {
    sColors = const Color(0xffAA00AA);
  } else if (changedText.contains("&6")) {
    sColors = const Color(0xffFFAA00);
  } else if (changedText.contains("&7")) {
    sColors = const Color(0xffAAAAAA);
  } else if (changedText.contains("&8")) {
    sColors = const Color(0xff555555);
  } else if (changedText.contains("&9")) {
    sColors = const Color(0xff5555FF);
  }
  return sColors;
}
