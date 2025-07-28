import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/counter_provider.dart';
import '../providers/user_provider.dart';

class ProviderDemoPage extends StatefulWidget {
  const ProviderDemoPage({super.key});

  @override
  State<ProviderDemoPage> createState() => _ProviderDemoPageState();
}

class _ProviderDemoPageState extends State<ProviderDemoPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _userEmailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _userEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Patterns Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('1. Consumer Pattern'),
            _buildConsumerDemo(),

            const SizedBox(height: 30),
            _buildSectionTitle('2. Selector Pattern (Optimized)'),
            _buildSelectorDemo(),

            const SizedBox(height: 30),
            _buildSectionTitle('3. Context.watch vs Context.read'),
            _buildContextDemo(),

            const SizedBox(height: 30),
            _buildSectionTitle('4. User Authentication Demo'),
            _buildUserAuthDemo(),

            const SizedBox(height: 30),
            _buildSectionTitle('5. User Management Demo'),
            _buildUserManagementDemo(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildConsumerDemo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Consumer rebuilds all widgets when state changes:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Consumer<CounterProvider>(
              builder: (context, counterProvider, child) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text('Counter: ${counterProvider.count}'),
                      Text('Loading: ${counterProvider.isLoading}'),
                      Text('Has Error: ${counterProvider.hasError}'),
                      const Text('🔄 Widget rebuilds when state changes'),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectorDemo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selector rebuilds only when selected value changes:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Selector<CounterProvider, int>(
                    selector: (context, provider) => provider.count,
                    builder: (context, count, child) {
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text('Count: $count'),
                            const Text('👀 Only rebuilds when count changes'),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Selector<CounterProvider, bool>(
                    selector: (context, provider) => provider.isLoading,
                    builder: (context, isLoading, child) {
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text('Loading: $isLoading'),
                            const Text(
                              '👀 Only rebuilds when isLoading changes',
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Demo context.watch vs context.read
  Widget _buildContextDemo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Context.watch vs Context.read:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),

            // Widget using context.watch
            Builder(
              builder: (context) {
                // Using context.watch to rebuild when CounterProvider changes
                final counterProvider = context.watch<CounterProvider>();
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text('context.watch() - Count: ${counterProvider.count}'),
                      const Text('🔄 Rebuilds when state changes'),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // Widget using context.read
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Using context.read to access provider without rebuilding
                    context.read<CounterProvider>().increment();
                  },
                  child: const Text('context.read().increment()'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterProvider>().reset();
                  },
                  child: const Text('context.read().reset()'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Demo User Authentication
  Widget _buildUserAuthDemo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Authentication with Provider:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),

            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                if (userProvider.isLoggedIn) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '✅ Logged in as: ${userProvider.currentUser!.name}',
                        ),
                        Text('Email: ${userProvider.currentUser!.email}'),
                        if (userProvider.mockApiUser != null) ...[
                          const SizedBox(height: 8),
                          const Text(
                            'MockAPI Data:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('ID: ${userProvider.mockApiUser!.id}'),
                          Text('Name: ${userProvider.mockApiUser!.name}'),
                          Text('Email: ${userProvider.mockApiUser!.email}'),
                          if (userProvider.mockApiUser!.avatar != null)
                            Text('Avatar: ${userProvider.mockApiUser!.avatar}'),
                          if (userProvider.mockApiUser!.phone != null)
                            Text('Phone: ${userProvider.mockApiUser!.phone}'),
                          if (userProvider.mockApiUser!.createdAt != null)
                            Text(
                              'Created: ${userProvider.mockApiUser!.createdAt}',
                            ),
                        ],
                        if (userProvider.authToken != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Token: ${userProvider.authToken!.substring(0, 20)}...',
                          ),
                        ],
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => userProvider.logout(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter email (e.g., user@example.com)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (userProvider.hasError)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                userProvider.errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                            IconButton(
                              onPressed: userProvider.clearError,
                              icon: const Icon(Icons.close, size: 16),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: userProvider.isLoading
                            ? null
                            : () {
                                userProvider.login(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                              },
                        child: userProvider.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Login'),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Demo User Management
  Widget _buildUserManagementDemo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Management với Provider:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),

            // Add user form
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _userEmailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    await context.read<UserProvider>().addUser(
                      _nameController.text,
                      _userEmailController.text,
                    );
                    _nameController.clear();
                    _userEmailController.clear();
                  },
                  child: const Text('Add'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Load users button
            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                return Column(
                  children: [
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: userProvider.isLoadingUsers
                              ? null
                              : () {
                                  userProvider.loadUsers();
                                },
                          child: userProvider.isLoadingUsers
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Load Users'),
                        ),
                        const SizedBox(width: 16),
                        Text('Total: ${userProvider.userCount} users'),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Users list
                    if (userProvider.users.isNotEmpty)
                      ...userProvider.users.map(
                        (user) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: user.isActive
                                  ? Colors.green
                                  : Colors.grey,
                              child: Text(user.name[0]),
                            ),
                            title: Text(user.name),
                            subtitle: Text(user.email),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    await userProvider.toggleUserStatus(
                                      user.id,
                                    );
                                  },
                                  icon: Icon(
                                    user.isActive
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: user.isActive
                                        ? Colors.orange
                                        : Colors.green,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await userProvider.removeUser(user.id);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
