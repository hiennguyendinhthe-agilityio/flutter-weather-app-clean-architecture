import 'package:bazar_books_design/bazar_books_design.dart';
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

  static void showLogoutModal(BuildContext context, VoidCallback onLogout) {
    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  context.bazS.logoutTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.bazS.logoutMeassage,
                textAlign: TextAlign.center,
                style: context.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
              // Logout Button
              SizedBox(
                width: double.infinity,
                child: BazUiElevatedButton(
                  onPressed: onLogout,
                  text: context.bazS.logoutTitle,
                ),
              ),
              const SizedBox(height: 16),
              // Cancel Button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.grey.shade100,
                  ),
                  child: Text(
                    context.bazS.cancelTitle,
                    style: TextStyle(
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
