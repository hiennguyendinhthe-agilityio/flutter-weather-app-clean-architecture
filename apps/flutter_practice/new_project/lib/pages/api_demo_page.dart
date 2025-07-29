import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../providers/user_provider.dart';

class ApiDemoPage extends StatefulWidget {
  const ApiDemoPage({super.key});

  @override
  State<ApiDemoPage> createState() => _ApiDemoPageState();
}

class _ApiDemoPageState extends State<ApiDemoPage> {
  final _usernameController = TextEditingController(text: 'user@example.com');
  final _passwordController = TextEditingController(text: 'password123');

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Integration Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(),
            const SizedBox(height: 20),
            _buildLoginSection(),
            const SizedBox(height: 20),
            _buildApiResponseSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  'API Integration Demo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Đây là demo tích hợp API thật sự với:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Text('• Dio HTTP Client với interceptors'),
            const Text('• Custom Exception handling'),
            const Text('• JSON Serialization'),
            const Text('• Loading states & Error handling'),
            const Text('• Authentication token management'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '✅ Sử dụng MockAPI thật sự từ mockapi.io',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ),
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
              'API Login Test',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Nhập email (e.g., user@example.com)',
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
            
            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                return Column(
                  children: [
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
                            Icon(Icons.error, color: Colors.red.shade700, size: 20),
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
                    
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: userProvider.isLoading ? null : _performLogin,
                            icon: userProvider.isLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.login),
                            label: Text(userProvider.isLoading ? 'Đang đăng nhập...' : 'Login với API'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: _testErrorScenarios,
                          icon: const Icon(Icons.bug_report),
                          label: const Text('Test Errors'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
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

  Widget _buildApiResponseSection() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (!userProvider.isLoggedIn) {
          return const SizedBox.shrink();
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade700),
                    const SizedBox(width: 8),
                    Text(
                      'API Response Success',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                _buildResponseItem('User ID', userProvider.mockApiUser?.id ?? 'N/A'),
                _buildResponseItem('Name', userProvider.mockApiUser?.name ?? 'N/A'),
                _buildResponseItem('Email', userProvider.mockApiUser?.email ?? 'N/A'),
                _buildResponseItem('Avatar', userProvider.mockApiUser?.avatar ?? 'N/A'),
                _buildResponseItem('Phone', userProvider.mockApiUser?.phone ?? 'N/A'),
                _buildResponseItem('Address', userProvider.mockApiUser?.address ?? 'N/A'),
                _buildResponseItem('Created At', userProvider.mockApiUser?.createdAt ?? 'N/A'),
                
                const Divider(),
                
                _buildResponseItem('Auth Token', '${userProvider.authToken?.substring(0, 30)}...'),
                
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
          ),
        );
      },
    );
  }

  Widget _buildResponseItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }

  void _performLogin() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    
    context.read<UserProvider>().login(username, password);
  }

  void _testErrorScenarios() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Test Error Scenarios'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.warning, color: Colors.orange),
              title: const Text('Empty Fields'),
              subtitle: const Text('Test validation errors'),
              onTap: () {
                Navigator.pop(context);
                context.read<UserProvider>().login('', '');
              },
            ),
            ListTile(
              leading: const Icon(Icons.error, color: Colors.red),
              title: const Text('Short Password'),
              subtitle: const Text('Test password validation'),
              onTap: () {
                Navigator.pop(context);
                context.read<UserProvider>().login('test', '123');
              },
            ),
            ListTile(
              leading: const Icon(Icons.network_check, color: Colors.blue),
              title: const Text('Valid Input'),
              subtitle: const Text('Test successful API call'),
              onTap: () {
                Navigator.pop(context);
                context.read<UserProvider>().login('user@example.com', 'password123');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}