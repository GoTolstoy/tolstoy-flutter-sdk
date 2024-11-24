import 'package:flutter/material.dart';
import 'feed_screen_main_menu.dart';
import 'feed_screen_report_menu.dart';

class FeedScreenMenu extends StatefulWidget {
  const FeedScreenMenu({super.key});

  @override
  State<FeedScreenMenu> createState() => _FeedScreenMenuState();
}

class _FeedScreenMenuState extends State<FeedScreenMenu> {
  bool _showReportMenu = false;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 300),
        crossFadeState: _showReportMenu
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        firstChild: FeedScreenMainMenu(
          onReport: () => setState(() => _showReportMenu = true),
        ),
        secondChild: FeedScreenReportMenu(
          onCancel: () => setState(() => _showReportMenu = false),
          onReport: () => setState(() => _showReportMenu = false),
        ),
      ),
    );
  }
}
