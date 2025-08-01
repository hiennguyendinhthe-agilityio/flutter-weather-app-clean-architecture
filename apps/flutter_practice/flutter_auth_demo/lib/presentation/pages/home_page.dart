import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../widgets/loading_button.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final userProvider = context.read<UserProvider>();
    await userProvider.logout();

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: const Key('homePage'),
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        actions: [
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              return IconButton(
                icon: const Icon(Icons.logout),
                onPressed: userProvider.isLoading
                    ? null
                    : () => _handleLogout(context),
                tooltip: 'Logout',
              );
            },
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.currentUser;

          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // Welcome Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: theme.colorScheme.primary
                              .withOpacity(0.1),
                          backgroundImage: user.avatar.isNotEmpty
                              ? NetworkImage(user.avatar)
                              : null,
                          child: user.avatar.isEmpty
                              ? Icon(
                                  Icons.person,
                                  size: 40,
                                  color: theme.colorScheme.primary,
                                )
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // Welcome Message
                        Text(
                          'Welcome, ${user.name}!',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),

                        Text(
                          'You have successfully logged in',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // User Information Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account Information',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // User ID
                        _buildInfoRow(
                          context,
                          'User ID',
                          user.id,
                          Icons.badge_outlined,
                        ),
                        const SizedBox(height: 12),

                        // Name
                        _buildInfoRow(
                          context,
                          'Name',
                          user.name,
                          Icons.person_outline,
                        ),
                        const SizedBox(height: 12),

                        // Email
                        _buildInfoRow(
                          context,
                          'Email',
                          user.email,
                          Icons.email_outlined,
                        ),
                        const SizedBox(height: 12),

                        // Created At (since createdAt is now nullable, show current date)
                        _buildInfoRow(
                          context,
                          'Member Since',
                          _formatDate(user.createdAt ?? DateTime.now()),
                          Icons.calendar_today_outlined,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Logout Button
                LoadingButton(
                  text: 'Logout',
                  onPressed: () => _handleLogout(context),
                  isLoading: userProvider.isLoading,
                  icon: const Icon(Icons.logout),
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
