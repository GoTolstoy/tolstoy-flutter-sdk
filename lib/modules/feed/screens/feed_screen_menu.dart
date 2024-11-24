import 'package:flutter/material.dart';
import 'feed_screen_main_menu.dart';
import 'feed_screen_report_menu.dart';
// import 'package:tolstoy_flutter_sdk/modules/api/services/api.dart';

class FeedScreenMenu extends StatefulWidget {
  const FeedScreenMenu({super.key});

  @override
  State<FeedScreenMenu> createState() => _FeedScreenMenuState();
}

class _FeedScreenMenuState extends State<FeedScreenMenu> {
  final _mainMenuKey = UniqueKey();
  final _reportMenuKey = UniqueKey();

  bool _showReportMenu = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: _showReportMenu
          ? FeedScreenReportMenu(
              key: _mainMenuKey,
              onCancel: () => setState(() => _showReportMenu = false),
              onReport: ({required String id, required String title}) async => {
                // await ApiService.sendEvent({}),
                await Future.delayed(const Duration(seconds: 2)),
                print('id: $id, title: $title'),
                if (mounted) Navigator.pop(this.context),
              },
            )
          : FeedScreenMainMenu(
              key: _reportMenuKey,
              onReport: () => setState(() => _showReportMenu = true)),
    );
  }
}
