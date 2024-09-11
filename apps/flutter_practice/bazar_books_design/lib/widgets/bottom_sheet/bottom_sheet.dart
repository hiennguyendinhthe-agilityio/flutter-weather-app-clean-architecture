import 'package:flutter/material.dart';

class BazUiBottomSheet {
  /// Shows a [showModalBottomSheet] with a close button.
  ///
  /// The [child] is the main content of the bottom sheet.
  static void showModal<T>(
    BuildContext context, {
    required Widget child,
  }) =>
      showModalBottomSheet<T>(
        isScrollControlled: true,
        useRootNavigator: true,
        context: context,
        builder: (context) => child,
      );
}
