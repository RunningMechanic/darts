import 'package:darts/Pages/input_ip.dart';
import 'package:darts/Pages/server.dart';
import 'package:flutter/material.dart';

class ButtonFieldWidget extends StatelessWidget {
  final String buttonText;
  final String imagePath;
  final int buttonNum;

  const ButtonFieldWidget(
      {super.key,
      required this.buttonText,
      required this.imagePath,
      required this.buttonNum});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Widget page = InputIpPage(newPage: buttonNum);
            if (buttonNum == 6) {
              page = const ServerPage();
            }
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.black)),
          ),
          child: SizedBox(
            width: 250,
            height: 200,
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.all(5)),
                SizedBox(
                    width: 150, height: 150, child: Image.asset(imagePath)),
                Text(
                  buttonText,
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
