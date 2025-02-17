import "package:flutter/material.dart";

// ignore: camel_case_types
class _lang {
  static const title = "Thanks for reporting";
  static const description =
      "We'll check this content to see if it goes against any of our policies and will take action if needed.";
  static const close = "Close";
}

class FeedScreenReportSubmittedMenu extends StatelessWidget {
  const FeedScreenReportSubmittedMenu({
    required this.onClose,
    super.key,
  });

  static const _subtitleColor = Color.fromRGBO(90, 90, 90, 1);

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            _lang.title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            _lang.description,
            style: TextStyle(
              fontSize: 14,
              color: _subtitleColor,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: TextButton(
              onPressed: onClose,
              child: const Text(_lang.close),
            ),
          ),
        ],
      );
}
