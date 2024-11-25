import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FeedScreenMainMenu extends StatelessWidget {
  static const _padding = EdgeInsets.fromLTRB(20, 30, 20, 40);
  static const _errorColor = Color.fromARGB(255, 226, 80, 109);
  static const _subtitleColor = Color.fromRGBO(90, 90, 90, 1);
  static const _noticeColor = Color.fromRGBO(120, 120, 120, 1);
  static final _lang = Map.unmodifiable({
    'title': 'Tolstoy: Shoppable Videos',
    'subtitle': 'See products in action with shoppable videos',
    'share': 'Share',
    'report': 'Report',
    'notice':
        'The individuals featured may have received an incentive in connection with this content, which may have been created or curated by the brand',
  });

  final VoidCallback onReport;
  final bool hideReportButton;
  final bool hideShareButton;

  const FeedScreenMainMenu({
    super.key,
    required this.onReport,
    this.hideReportButton = false,
    this.hideShareButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _padding,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://tolstoy-mobile-assets.s3.us-east-1.amazonaws.com/TolstoyLogo.png',
                        width: 64,
                        height: 64,
                        fit: BoxFit.contain,
                        placeholder: (context, url) =>
                            Container(color: Colors.transparent),
                        errorWidget: (context, url, error) => Icon(
                          Icons.broken_image_rounded,
                          size: 40,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        _lang['title'],
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Transform.translate(
                offset: const Offset(6, -10),
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            _lang['subtitle'],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: _subtitleColor,
            ),
          ),
          const SizedBox(height: 40),
          if (!hideShareButton)
            Text(
              _lang['share'],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          if (!hideShareButton) const SizedBox(height: 30),
          if (!hideReportButton)
            GestureDetector(
              onTap: onReport,
              child: Row(
                children: [
                  Icon(
                    Icons.report,
                    color: _errorColor,
                    size: 30,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _lang['report'],
                    style: TextStyle(
                      color: _errorColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          if (!hideReportButton) const SizedBox(height: 30),
          const SizedBox(height: 10),
          Text(
            _lang['notice'],
            style: TextStyle(
              fontSize: 16,
              color: _noticeColor,
            ),
          ),
        ],
      ),
    );
  }
}
