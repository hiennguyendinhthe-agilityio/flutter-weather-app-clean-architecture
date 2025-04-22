import 'package:flutter/material.dart';

class ServiceOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const ServiceOption({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color borderColor =
        isSelected ? theme.colorScheme.primary : theme.colorScheme.outline;

    final Color backgroundColor = isSelected
        ? theme.colorScheme.primary.withValues(alpha: 0.05)
        : theme.colorScheme.surface;

    final Color contentColor = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withValues(alpha: 0.7);

    final TextStyle? baseTextStyle = theme.textTheme.labelMedium;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 90,
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: backgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: contentColor,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: baseTextStyle?.copyWith(
                fontWeight: FontWeight.w500,
                color: contentColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
