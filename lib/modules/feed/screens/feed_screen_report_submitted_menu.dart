import 'package:flutter/material.dart';

class FeedScreenReportSubmittedMenu extends StatelessWidget {
  static const _subtitleColor = Color.fromRGBO(90, 90, 90, 1);

  static final _lang = Map.unmodifiable({
    'title': 'Thanks for reporting',
    'description':
        "We'll check this content to see if it goes against any of our policies and will take action if needed.",
    'close': 'Close',
  });

  final VoidCallback onClose;

  const FeedScreenReportSubmittedMenu({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _lang['title'],
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          _lang['description'],
          style: TextStyle(
            fontSize: 14,
            color: _subtitleColor,
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: TextButton(
            onPressed: onClose,
            child: Text(_lang['close']),
          ),
        ),
      ],
    );
  }
}
