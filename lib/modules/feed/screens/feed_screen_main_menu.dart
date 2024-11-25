import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FeedScreenMainMenu extends StatelessWidget {
  static const _padding = EdgeInsets.fromLTRB(25, 25, 25, 35);
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
  final String? customMenuTitle;
  final String? customMenuSubtitle;
  final String? customMenuLogoUrl;

  const FeedScreenMainMenu({
    super.key,
    required this.onReport,
    this.hideReportButton = false,
    this.hideShareButton = false,
    this.customMenuTitle,
    this.customMenuSubtitle,
    this.customMenuLogoUrl,
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
                        imageUrl: customMenuLogoUrl ??
                            'https://tolstoy-mobile-assets.s3.us-east-1.amazonaws.com/TolstoyLogo.png',
                        width: 40,
                        height: 40,
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
                        customMenuTitle ?? _lang['title'],
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 16,
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
          const SizedBox(height: 15),
          Text(
            customMenuSubtitle ?? _lang['subtitle'],
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _subtitleColor,
            ),
          ),
          const SizedBox(height: 30),
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
              child: Text(
                _lang['report'],
                style: TextStyle(
                  color: _errorColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (!hideReportButton) const SizedBox(height: 30),
          Text(
            _lang['notice'],
            style: TextStyle(
              fontSize: 12,
              color: _noticeColor,
            ),
          ),
        ],
      ),
    );
  }
}
