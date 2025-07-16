import 'package:flutter/cupertino.dart';

/// Reusable loading indicator widget
class LoadingIndicatorWidget extends StatelessWidget {
  final String? message;
  final EdgeInsets? padding;

  const LoadingIndicatorWidget({
    super.key,
    this.message,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(vertical: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(child: CupertinoActivityIndicator()),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                style: const TextStyle(
                  color: CupertinoColors.secondaryLabel,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}