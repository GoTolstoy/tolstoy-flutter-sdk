import "package:flutter/material.dart";

// ignore: camel_case_types
class _lang {
  static const title = "Tolstoy: Shoppable Videos";
  static const report = "Report";
  static const notice =
      "The individuals featured may have received an incentive in connection with this content, which may have been created or curated by the brand";
}

class FeedScreenMainMenu extends StatelessWidget {
  const FeedScreenMainMenu({
    required this.onReport,
    super.key,
  });

  static const _errorColor = Color.fromARGB(255, 226, 80, 109);
  static const _noticeColor = Color.fromRGBO(120, 120, 120, 1);

  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        "assets/images/TolstoyLogo.png",
                        package: "tolstoy_flutter_sdk",
                        width: 36,
                        height: 36,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        _lang.title,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Transform.translate(
                offset: const Offset(6, -10),
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          GestureDetector(
            onTap: onReport,
            child: const Text(
              _lang.report,
              style: TextStyle(
                color: _errorColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            _lang.notice,
            style: TextStyle(
              fontSize: 12,
              color: _noticeColor,
            ),
          ),
        ],
      );
}
