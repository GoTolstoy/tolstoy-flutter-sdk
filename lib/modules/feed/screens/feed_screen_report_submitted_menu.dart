import "package:flutter/material.dart";

class FeedScreenReportSubmittedMenu extends StatelessWidget {
  const FeedScreenReportSubmittedMenu({
    required this.onClose,
    super.key,
  });

  static const _subtitleColor = Color.fromRGBO(90, 90, 90, 1);
  static const _lang = {
    "title": "Thanks for reporting",
    "description":
        "We'll check this content to see if it goes against any of our policies and will take action if needed.",
    "close": "Close",
  };

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _lang["title"]!,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            _lang["description"]!,
            style: const TextStyle(
              fontSize: 14,
              color: _subtitleColor,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: TextButton(
              onPressed: onClose,
              child: Text(_lang["close"]!),
            ),
          ),
        ],
      );
}
