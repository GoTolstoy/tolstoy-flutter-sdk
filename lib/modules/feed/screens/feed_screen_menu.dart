import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FeedScreenMenu extends StatefulWidget {
  const FeedScreenMenu({super.key});

  @override
  State<FeedScreenMenu> createState() => _FeedScreenMenuState();
}

class _FeedScreenMenuState extends State<FeedScreenMenu> {
  static const padding = EdgeInsets.fromLTRB(20, 30, 20, 40);
  static const errorColor = Color.fromARGB(255, 226, 80, 109);
  static const subtitleColor = Color.fromRGBO(90, 90, 90, 1);
  static const noticeColor = Color.fromRGBO(120, 120, 120, 1);
  static final lang = Map.unmodifiable({
    'title': 'Tolstoy: Shoppable Videos',
    'subtitle': 'See products in action with shoppable videos',
    'share': 'Share',
    'report': 'Report',
    'notice':
        'The individuals featured may have received an incentive in connection with this content, which may have been created or curated by the brand',
  });

  bool _showReportMenu = false;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 300),
        crossFadeState: _showReportMenu
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        firstChild: _buildMainContent(),
        secondChild: _buildReportContent(),
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      padding: padding,
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
                    CachedNetworkImage(
                      imageUrl:
                          'https://tolstoy-files-dev-output.s3.us-east-1.amazonaws.com/public/flutter-sdk/tolstoy_icon.png',
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
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        lang['title'],
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
            lang['subtitle'],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: subtitleColor,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            lang['share'],
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: () => setState(() => _showReportMenu = true),
            child: Row(
              children: [
                Icon(
                  Icons.report,
                  color: errorColor,
                  size: 30,
                ),
                const SizedBox(width: 12),
                Text(
                  lang['report'],
                  style: TextStyle(
                    color: errorColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Text(
            lang['notice'],
            style: TextStyle(
              fontSize: 16,
              color: noticeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportContent() {
    return Container(
      padding: padding,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Report Content',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 120),
          TextButton(
            onPressed: () => setState(() => _showReportMenu = false),
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }
}
