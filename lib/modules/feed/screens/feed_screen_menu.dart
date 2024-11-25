import 'package:flutter/material.dart';
import 'feed_screen_main_menu.dart';
import 'feed_screen_report_menu.dart';
import 'feed_screen_report_submitted_menu.dart';

class FeedScreenMenu extends StatefulWidget {
  final Future<bool> Function({required String id, required String title})
      onReport;
  final bool hideReportButton;
  final bool hideShareButton;
  final String? customMenuTitle;
  final String? customMenuSubtitle;
  final String? customMenuLogoUrl;

  const FeedScreenMenu({
    super.key,
    required this.onReport,
    this.hideReportButton = false,
    this.hideShareButton = false,
    this.customMenuTitle,
    this.customMenuSubtitle,
    this.customMenuLogoUrl,
  });

  @override
  State<FeedScreenMenu> createState() => _FeedScreenMenuState();
}

enum Screen { main, report, reportSubmitted }

class _FeedScreenMenuState extends State<FeedScreenMenu> {
  final _mainMenuKey = UniqueKey();
  final _reportMenuKey = UniqueKey();

  var _selectedScreen = Screen.main;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: switch (_selectedScreen) {
          Screen.main => FeedScreenMainMenu(
              key: _reportMenuKey,
              onReport: () => setState(() => _selectedScreen = Screen.report),
              hideReportButton: widget.hideReportButton,
              hideShareButton: widget.hideShareButton,
              customMenuTitle: widget.customMenuTitle,
              customMenuSubtitle: widget.customMenuSubtitle,
              customMenuLogoUrl: widget.customMenuLogoUrl,
            ),
          Screen.report => FeedScreenReportMenu(
              key: _mainMenuKey,
              onCancel: () => setState(() => _selectedScreen = Screen.main),
              onReport: ({required String id, required String title}) async {
                final reported = await widget.onReport(id: id, title: title);

                if (reported && mounted) {
                  setState(() => _selectedScreen = Screen.reportSubmitted);
                }

                return reported;
              },
            ),
          Screen.reportSubmitted => FeedScreenReportSubmittedMenu(
              onClose: () => Navigator.pop(this.context),
            ),
        });
  }
}
