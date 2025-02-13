// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(home: SignInScreen()));
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isBiometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadBiometricStatus();
  }

  Future<void> _loadBiometricStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isBiometricEnabled = prefs.getBool('biometricEnabled') ?? false;
    });
  }

  // Hàm xác thực sinh trắc học
  Future<void> _handleBiometricAuthentication() async {
    if (!_isBiometricEnabled) {
      // Nếu chưa bật sinh trắc học, yêu cầu đăng nhập để thiết lập
      _showLoginPromptForBiometricSetup();
    } else {
      // Nếu đã bật sinh trắc học, tiến hành xác thực
      final bool isAuthenticated = await _authenticateWithBiometrics();
      if (isAuthenticated) {
        _navigateToHome();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Xác thực sinh trắc học thất bại')),
        );
      }
    }
  }

  Future<bool> _authenticateWithBiometrics() async {
    try {
      final bool isAuthenticated = await auth.authenticate(
        localizedReason: 'Xác thực sinh trắc học để đăng nhập',
      );
      return isAuthenticated;
    } catch (e) {
      print('Lỗi sinh trắc học: $e');
      return false;
    }
  }

  // Hiển thị pop-up yêu cầu đăng nhập khi chưa thiết lập sinh trắc học
  void _showLoginPromptForBiometricSetup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thiết lập sinh trắc học'),
        content:
            const Text('Bạn cần đăng nhập trước khi thiết lập sinh trắc học.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  // Xử lý đăng nhập
  void _onLoginPressed() async {
    if (_usernameController.text == "user" &&
        _passwordController.text == "password") {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      // Sau khi đăng nhập thành công, hỏi bật sinh trắc học
      final bool? enableBiometric = await _showBiometricSetupPrompt();
      if (enableBiometric == true) {
        await prefs.setBool('biometricEnabled', true);
        setState(() {
          _isBiometricEnabled = true; // Cập nhật trạng thái sinh trắc học
        });
      }

      _navigateToHome();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sai tài khoản hoặc mật khẩu')),
      );
    }
  }

  // Hiển thị pop-up hỏi có bật sinh trắc học sau khi đăng nhập
  Future<bool?> _showBiometricSetupPrompt() async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bật xác thực sinh trắc học?'),
        content: const Text(
            'Bạn có muốn sử dụng vân tay/khuôn mặt cho các lần đăng nhập sau không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Có'),
          ),
        ],
      ),
    );
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng Nhập')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Tên đăng nhập'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Mật khẩu'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onLoginPressed,
              child: const Text('Đăng nhập'),
            ),
            const SizedBox(height: 20),
            const Divider(),
            ElevatedButton.icon(
              onPressed: _handleBiometricAuthentication,
              icon: const Icon(Icons.fingerprint),
              label: const Text('Đăng nhập bằng Sinh trắc học'),
            ),
          ],
        ),
      ),
    );
  }
}

// Màn hình Trang Chính
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trang Chính')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.clear(); // Đăng xuất và reset trạng thái
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignInScreen()),
            );
          },
          child: const Text('Đăng xuất'),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   runApp(MaterialApp(
//     home: LoginScreen(),
//   ));
// }

// class LoginScreen extends StatelessWidget {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => AuthBloc()..add(CheckBiometricStatus()),
//       child: Scaffold(
//         appBar: AppBar(title: const Text('Đăng Nhập')),
//         body: BlocConsumer<AuthBloc, AuthState>(
//           listener: (context, state) {
//             if (state is Authenticated) {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const HomeScreen()),
//               );
//             } else if (state is BiometricNotSetup) {
//               _showSetupBiometricPrompt(context);
//             } else if (state is BiometricFailed) {
//               _showSnackBar(context, 'Xác thực sinh trắc học thất bại.');
//             } else if (state is Unauthenticated && state.message.isNotEmpty) {
//               _showSnackBar(context, state.message);
//             }
//           },
//           builder: (context, state) {
//             if (state is AuthLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   TextField(
//                     controller: _usernameController,
//                     decoration:
//                         const InputDecoration(labelText: 'Tên đăng nhập'),
//                   ),
//                   TextField(
//                     controller: _passwordController,
//                     obscureText: true,
//                     decoration: const InputDecoration(labelText: 'Mật khẩu'),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {
//                       context.read<AuthBloc>().add(
//                             LoginRequested(
//                               _usernameController.text,
//                               _passwordController.text,
//                             ),
//                           );
//                     },
//                     child: const Text('Đăng nhập'),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       context.read<AuthBloc>().add(BiometricAuthRequested());
//                     },
//                     icon: const Icon(Icons.fingerprint),
//                     label: const Text('Đăng nhập bằng Sinh trắc học'),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   void _showSetupBiometricPrompt(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Thiết lập sinh trắc học'),
//         content:
//             const Text('Bạn cần đăng nhập trước khi thiết lập sinh trắc học.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Đóng'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showSnackBar(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
// }

// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final LocalAuthentication auth = LocalAuthentication();

//   AuthBloc() : super(AuthInitial()) {
//     on<CheckBiometricStatus>(_onCheckBiometricStatus);
//     on<LoginRequested>(_onLoginRequested);
//     on<BiometricAuthRequested>(_onBiometricAuthRequested);
//     on<LogoutRequested>(_onLogoutRequested);
//   }

//   // Kiểm tra trạng thái sinh trắc học khi app khởi động
//   Future<void> _onCheckBiometricStatus(
//       CheckBiometricStatus event, Emitter<AuthState> emit) async {
//     final prefs = await SharedPreferences.getInstance();
//     final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
//     final bool biometricEnabled = prefs.getBool('biometricEnabled') ?? false;

//     if (isLoggedIn && biometricEnabled) {
//       emit(BiometricAuthenticated());
//     } else if (isLoggedIn && !biometricEnabled) {
//       emit(Unauthenticated(
//           'Bạn đã đăng nhập. Hãy bật sinh trắc học để sử dụng lần sau.'));
//     } else {
//       emit(Unauthenticated('Vui lòng đăng nhập và thiết lập sinh trắc học.'));
//     }
//   }

//   // Xử lý đăng nhập
//   Future<void> _onLoginRequested(
//       LoginRequested event, Emitter<AuthState> emit) async {
//     emit(AuthLoading());

//     if (event.username == 'user' && event.password == 'password') {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('isLoggedIn', true);

//       final bool? enableBiometric = await _promptEnableBiometric();
//       if (enableBiometric == true) {
//         await prefs.setBool('biometricEnabled', true);
//       }
//       emit(Authenticated());
//     } else {
//       emit(Unauthenticated('Sai tài khoản hoặc mật khẩu'));
//     }
//   }

//   // Xử lý xác thực sinh trắc học
//   Future<void> _onBiometricAuthRequested(
//       BiometricAuthRequested event, Emitter<AuthState> emit) async {
//     final prefs = await SharedPreferences.getInstance();
//     final bool biometricEnabled = prefs.getBool('biometricEnabled') ?? false;

//     if (!biometricEnabled) {
//       emit(BiometricNotSetup());
//       return;
//     }

//     try {
//       final bool isAuthenticated = await auth.authenticate(
//         localizedReason: 'Xác thực sinh trắc học để đăng nhập',
//         options: const AuthenticationOptions(biometricOnly: true),
//       );

//       if (isAuthenticated) {
//         emit(Authenticated());
//       } else {
//         emit(BiometricFailed());
//       }
//     } catch (e) {
//       emit(BiometricFailed());
//     }
//   }

//   Future<void> _onLogoutRequested(
//       LogoutRequested event, Emitter<AuthState> emit) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//     emit(Unauthenticated('Bạn đã đăng xuất.'));
//   }

//   Future<bool?> _promptEnableBiometric() async {

//     return true;
//   }
// }

// abstract class AuthEvent {}

// class CheckBiometricStatus extends AuthEvent {}

// class LoginRequested extends AuthEvent {
//   final String username;
//   final String password;

//   LoginRequested(this.username, this.password);
// }

// class BiometricAuthRequested extends AuthEvent {}

// class LogoutRequested extends AuthEvent {}

// abstract class AuthState {}

// class AuthInitial extends AuthState {}

// class AuthLoading extends AuthState {}

// class Authenticated extends AuthState {}

// class Unauthenticated extends AuthState {
//   final String message;

//   Unauthenticated(this.message);
// }

// class BiometricNotSetup extends AuthState {}

// class BiometricAuthenticated extends AuthState {}

// class BiometricFailed extends AuthState {}

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Trang Chính')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             context.read<AuthBloc>().add(LogoutRequested());
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => LoginScreen()),
//             );
//           },
//           child: const Text('Đăng xuất'),
//         ),
//       ),
//     );
//   }
// }
