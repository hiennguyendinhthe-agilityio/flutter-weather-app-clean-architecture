import 'package:flutter/cupertino.dart';

/// Reusable error widget with retry functionality
class ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final EdgeInsets? padding;

  const ErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              CupertinoIcons.exclamationmark_triangle,
              color: CupertinoColors.systemRed,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                color: CupertinoColors.secondaryLabel,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              CupertinoButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}