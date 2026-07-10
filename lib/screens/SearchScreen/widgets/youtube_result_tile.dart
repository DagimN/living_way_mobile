import 'package:flutter/material.dart';
import 'package:living_way/core/core.dart';

class YoutubeResultTile extends StatelessWidget {
  final YoutubeSearchResult result;
  final Axis scrollDirection;
  final VoidCallback? onTap;

  const YoutubeResultTile(
      {super.key,
      required this.result,
      required this.scrollDirection,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
        onTap: onTap,
        child: Container(
          margin: scrollDirection == Axis.horizontal
              ? const EdgeInsets.only(right: 8)
              : const EdgeInsets.only(bottom: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: result.thumbnailUrl != null
                ? Image.network(
                    result.thumbnailUrl!,
                    width: screenWidth * 0.4,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _fallbackIcon(
                      size: 44,
                      icon: Icons.play_circle_fill_rounded,
                    ),
                  )
                : _fallbackIcon(
                    size: 44, width: 64, icon: Icons.play_circle_fill_rounded),
          ),
        ));
  }
}

Widget _fallbackIcon(
    {required double size, double? width, required IconData icon}) {
  return Container(
    width: width ?? size,
    height: size,
    color: Colors.white.withAlpha(25),
    child: Icon(icon, color: AppTheme(Brightness.light).primaryColor),
  );
}
