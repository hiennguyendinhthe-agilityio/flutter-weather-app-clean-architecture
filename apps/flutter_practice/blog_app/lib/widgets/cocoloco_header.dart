import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_colors.dart';

class CocolocoHeader extends StatelessWidget {
  final VoidCallback onSearchTap;

  const CocolocoHeader({
    super.key,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Authentic Figma COCO LOCO Logo (Width: 94px, Height: 64px per Figma spec)
          SizedBox(
            width: 94,
            height: 64,
            child: Image.asset(
              'assets/images/cocoloco_logo.png',
              width: 94,
              height: 64,
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
              errorBuilder: (_, _, _) => _buildFigmaTextLogo(),
            ),
          ),

          // Search Action Icon
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: onSearchTap,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.search_rounded,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Exact fallback typography according to Figma inspect:
  // Font: Chap, Weight: 900, Size: 32px, Line height: 32px, Color: #5B1921, Border: 1px #000000 outer
  Widget _buildFigmaTextLogo() {
    return Stack(
      children: [
        // 1px Outer Black Border/Stroke (#000000)
        Text(
          'COCO\nLOCO',
          style: GoogleFonts.lilitaOne(
            fontSize: 32,
            height: 1.0,
            letterSpacing: 0,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2.0
              ..strokeJoin = StrokeJoin.round
              ..strokeCap = StrokeCap.round
              ..color = Colors.black,
          ),
        ),
        // Primary Burgundy Fill (#5B1921)
        Text(
          'COCO\nLOCO',
          style: GoogleFonts.lilitaOne(
            fontSize: 32,
            height: 1.0,
            letterSpacing: 0,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
