import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class MockApiDemoPage extends StatefulWidget {
  const MockApiDemoPage({super.key});

  @override
  State<MockApiDemoPage> createState() => _MockApiDemoPageState();
}

class _MockApiDemoPageState extends State<MockApiDemoPage> {
  final _emailController = TextEditingController(text: 'test@example.com');
  final _passwordController = TextEditingController(text: 'password123');
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
        title: const Text('MockAPI Demo'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildApiInfoCard(),
            const SizedBox(height: 20),
            _buildLoginSection(),
            const SizedBox(height: 20),
            _buildUserManagementSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildApiInfoCard() {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.api, color: Colors.green.shade700, size: 24),
                const SizedBox(width: 8),
                Text(
                  'MockAPI Integration',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'API Endpoint:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  SelectableText(
                    'https://66e29593494df9a478e23cab.mockapi.io/api/v1/user',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text('✅ Real HTTP calls với Dio'),
            const Text('✅ CRUD operations (Create, Read, Update, Delete)'),
            const Text('✅ JSON serialization tự động'),
            const Text('✅ Error handling comprehensive'),
            const Text('✅ Loading states & UI feedback'),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🔐 Authentication Demo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                if (userProvider.isLoggedIn) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green.shade700,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Đăng nhập thành công!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        if (userProvider.mockApiUser != null) ...[
                          _buildUserInfoRow('ID', userProvider.mockApiUser!.id),
                          _buildUserInfoRow(
                            'Name',
                            userProvider.mockApiUser!.name,
                          ),
                          _buildUserInfoRow(
                            'Email',
                            userProvider.mockApiUser!.email,
                          ),
                          if (userProvider.mockApiUser!.avatar != null)
                            _buildUserInfoRow(
                              'Avatar',
                              userProvider.mockApiUser!.avatar!,
                            ),
                          if (userProvider.mockApiUser!.phone != null)
                            _buildUserInfoRow(
                              'Phone',
                              userProvider.mockApiUser!.phone!,
                            ),
                          if (userProvider.mockApiUser!.createdAt != null)
                            _buildUserInfoRow(
                              'Created',
                              userProvider.mockApiUser!.createdAt!,
                            ),
                        ],

                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => userProvider.logout(),
                            icon: const Icon(Icons.logout),
                            label: const Text('Logout'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
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
                        hintText: 'Nhập email để login/register',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: 'Nhập password (ít nhất 6 ký tự)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (userProvider.hasError)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          border: Border.all(color: Colors.red.shade200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error,
                              color: Colors.red.shade700,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                userProvider.errorMessage!,
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                            ),
                            IconButton(
                              onPressed: userProvider.clearError,
                              icon: const Icon(Icons.close, size: 18),
                              color: Colors.red.shade700,
                            ),
                          ],
                        ),
                      ),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: userProvider.isLoading
                            ? null
                            : _performLogin,
                        icon: userProvider.isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.login),
                        label: Text(
                          userProvider.isLoading
                              ? 'Đang xử lý...'
                              : 'Login / Register',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
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

  Widget _buildUserManagementSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '👥 User Management (CRUD Operations)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

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
                ElevatedButton.icon(
                  onPressed: _addUser,
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Load users section
            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                return Column(
                  children: [
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: userProvider.isLoadingUsers
                              ? null
                              : () {
                                  userProvider.loadUsers();
                                },
                          icon: userProvider.isLoadingUsers
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.refresh),
                          label: Text(
                            userProvider.isLoadingUsers
                                ? 'Loading...'
                                : 'Load Users',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Total: ${userProvider.userCount} users',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Users list
                    if (userProvider.apiUsers.isNotEmpty)
                      ...userProvider.apiUsers.map(
                        (user) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: user.avatar != null
                                  ? NetworkImage(user.avatar!)
                                  : null,
                              backgroundColor: Colors.green.shade200,
                              child: user.avatar == null
                                  ? Text(
                                      user.name.isNotEmpty
                                          ? user.name[0].toUpperCase()
                                          : '?',
                                    )
                                  : null,
                            ),
                            title: Text(user.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user.email),
                                if (user.phone != null)
                                  Text(
                                    '📞 ${user.phone}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                if (user.address != null)
                                  Text(
                                    '📍 ${user.address}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                              ],
                            ),
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
                                    user.name.contains('(Inactive)')
                                        ? Icons.play_arrow
                                        : Icons.pause,
                                    color: user.name.contains('(Inactive)')
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                  tooltip: user.name.contains('(Inactive)')
                                      ? 'Activate'
                                      : 'Deactivate',
                                ),
                                IconButton(
                                  onPressed: () async {
                                    final confirm =
                                        await _showDeleteConfirmation(
                                          user.name,
                                        );
                                    if (confirm) {
                                      await userProvider.removeUser(user.id);
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  tooltip: 'Delete',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    if (userProvider.apiUsers.isEmpty &&
                        !userProvider.isLoadingUsers)
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: const Text(
                          'Chưa có users. Nhấn "Load Users" để tải từ API.',
                          style: TextStyle(fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
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

  Widget _buildUserInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontFamily: 'monospace')),
          ),
        ],
      ),
    );
  }

  void _performLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    context.read<UserProvider>().login(email, password);
  }

  void _addUser() async {
    final name = _nameController.text.trim();
    final email = _userEmailController.text.trim();

    if (name.isNotEmpty && email.isNotEmpty) {
      await context.read<UserProvider>().addUser(name, email);
      _nameController.clear();
      _userEmailController.clear();
    }
  }

  Future<bool> _showDeleteConfirmation(String userName) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Xác nhận xóa'),
            content: Text('Bạn có chắc muốn xóa user "$userName"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Xóa'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
