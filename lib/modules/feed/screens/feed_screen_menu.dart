import 'package:flutter/material.dart';
import 'feed_screen_main_menu.dart';
import 'feed_screen_report_menu.dart';

class FeedScreenMenu extends StatefulWidget {
  final Future<void> Function({required String id, required String title})
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
              onReport: ({required String id, required String title}) async {
                await widget.onReport(id: id, title: title);
                if (mounted) Navigator.pop(this.context);
              },
            )
          : FeedScreenMainMenu(
              key: _reportMenuKey,
              onReport: () => setState(() => _showReportMenu = true),
              hideReportButton: widget.hideReportButton,
              hideShareButton: widget.hideShareButton,
              customMenuTitle: widget.customMenuTitle,
              customMenuSubtitle: widget.customMenuSubtitle,
              customMenuLogoUrl: widget.customMenuLogoUrl,
            ),
    );
  }
}
