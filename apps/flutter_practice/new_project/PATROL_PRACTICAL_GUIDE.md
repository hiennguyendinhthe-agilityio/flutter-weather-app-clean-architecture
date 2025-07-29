# 🚁 PATROL PRACTICAL GUIDE - HƯỚNG DẪN THỰC HÀNH PATROL

> **Mục tiêu:** Hướng dẫn từng bước viết một bài test hoàn chỉnh cho luồng đăng nhập bằng Patrol.

---

## 🎯 BƯỚC 1: CHUẨN BỊ MÔI TRƯỜNG

### 1.1. Thêm Dependencies

Đảm bảo `pubspec.yaml` của em có đủ các gói cần thiết:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  patrol: ^3.18.0 # Hoặc phiên bản mới nhất
```

### 1.2. Cấu trúc thư mục

Tất cả các file test của Patrol sẽ nằm trong thư mục `integration_test`.

```
project_root/
└── integration_test/
    └── login_flow_test.dart  # File test chúng ta sẽ tạo
```

---

## 🎯 BƯỚC 2: VIẾT TEST CASE ĐẦU TIÊN (LOGIN THÀNH CÔNG)

Chúng ta sẽ áp dụng **Pattern AAA (Arrange - Act - Assert)**, một tiêu chuẩn vàng trong testing.

### 2.1. Tạo file test và template cơ bản

Tạo file `integration_test/login_flow_test.dart` với nội dung sau:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
// QUAN TRỌNG: Import file main.dart của app em
import 'package:new_project/main.dart' as app; 

void main() {
  // Dùng patrolTest thay vì testWidgets
  patrolTest(
    'Đăng nhập thành công với thông tin hợp lệ',
    // Ký tự $ là PatrolTester, công cụ chính của chúng ta
    ($) async {
      // Code test sẽ được viết ở đây
    },
  );
}
```

### 2.2. ARRANGE - Dàn dựng kịch bản

Mục tiêu của bước này là chuẩn bị mọi thứ trước khi thực hiện hành động chính.

```dart
// Bên trong patrolTest

// --- ARRANGE ---
// 1. Khởi động ứng dụng
app.main();

// 2. Chờ cho đến khi app build xong và tất cả animation hoàn tất.
// pumpAndSettle() là lệnh cực kỳ quan trọng và mạnh mẽ của Patrol.
await $.pumpAndSettle();

// 3. (Giả sử) Điều hướng đến màn hình đăng nhập
// Ta tìm một Widget có text là 'Go to Login' và nhấn vào nó.
await $.tap($('Go to Login'));
await $.pumpAndSettle(); // Chờ màn hình mới load xong

// 4. Kiểm tra xem đã đến đúng màn hình đăng nhập chưa
expect($('Login Page'), findsOneWidget);
```

### 2.3. ACT - Thực hiện hành động

Đây là lúc chúng ta mô phỏng hành động của người dùng.

```dart
// Tiếp theo...

// --- ACT ---
// 1. Tìm TextField có nhãn 'Email' và nhập text
await $.enterText($('Email'), 'test@example.com');

// 2. Tìm TextField có nhãn 'Password' và nhập text
await $.enterText($('Password'), 'password123');

// 3. Tìm nút 'Login' và nhấn vào
await $.tap($('Login'));

// 4. Chờ cho hành động (ví dụ: call API) hoàn tất
await $.pumpAndSettle(timeout: const Duration(seconds: 10)); // Cho phép chờ lâu hơn cho API
```

### 2.4. ASSERT - Xác minh kết quả

Sau khi hành động, chúng ta kiểm tra xem kết quả có đúng như mong đợi không.

```dart
// Tiếp theo...

// --- ASSERT ---
// 1. Kiểm tra xem có thông báo chào mừng hay không
expect($('Welcome, test@example.com!'), findsOneWidget);

// 2. Kiểm tra xem màn hình đăng nhập đã biến mất chưa
expect($('Login Page'), findsNothing);
```

---

## 🎯 BƯỚC 3: VIẾT TEST CASE CHO KỊCH BẢN LỖI

Một test suite tốt phải kiểm tra cả trường hợp thành công và thất bại.

```dart
patrolTest(
  'Hiển thị lỗi khi bỏ trống email và password',
  ($) async {
    // --- ARRANGE ---
    app.main();
    await $.pumpAndSettle();
    await $.tap($('Go to Login'));
    await $.pumpAndSettle();

    // --- ACT ---
    // Bỏ qua bước nhập liệu, nhấn Login luôn
    await $.tap($('Login'));
    await $.pumpAndSettle();

    // --- ASSERT ---
    // Kiểm tra xem các thông báo lỗi có hiển thị không
    expect($('Email không được để trống'), findsOneWidget);
    expect($('Password không được để trống'), findsOneWidget);
  },
);
```

---

## 🏆 KẾT LUẬN

Em đã học được công thức cốt lõi để viết test với Patrol:
1.  **`patrolTest('description', ($) async { ... })`**: Khung sườn của một bài test.
2.  **`$`**: "Cây đũa thần" để tìm và tương tác với widget.
3.  **`$('Text')`**, `$(#key)`, `$(Icons.icon)`: Các cách để tìm widget (selector).
4.  **`$.tap()`**, **`$.enterText()`**: Các hành động phổ biến.
5.  **`$.pumpAndSettle()`**: Lệnh chờ "thông minh" để UI ổn định.
6.  **`expect(finder, matcher)`**: Công cụ để xác minh kết quả.

Khi em đã có môi trường, hãy chạy lệnh sau trong terminal:
`flutter test integration_test/login_flow_test.dart`

Chúc mừng em! Em đã nắm được nền tảng vững chắc nhất để chinh phục Patrol.