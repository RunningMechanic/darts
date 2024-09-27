import 'package:flutter/material.dart';

class LaneScoreboardManagementListWidget extends StatefulWidget {
  final List<Widget> widgets;

  const LaneScoreboardManagementListWidget({super.key, required this.widgets});

  @override
  State<StatefulWidget> createState() {
    return LaneScoreboardManagementListWidgetState();
  }
}

class LaneScoreboardManagementListWidgetState
    extends State<LaneScoreboardManagementListWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            for (int i = 0; i < widget.widgets.length; i++) widget.widgets[i],
          ],
        ),
      ),
    );
  }
}
