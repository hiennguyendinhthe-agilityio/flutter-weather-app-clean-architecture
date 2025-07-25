# 📚 TICKET 1.1: DEPENDENCY INJECTION SETUP - GIẢI THÍCH CHI TIẾT

> **Mục tiêu:** Hiểu rõ từng bước setup Dependency Injection với get_it và injectable, và cách áp dụng vào dự án thực tế.

---

## 🎯 **TẠI SAO CẦN DEPENDENCY INJECTION?**

### **Vấn đề khi KHÔNG dùng DI:**

```dart
// ❌ BAD: Tightly coupled code
class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  // Tạo trực tiếp dependencies - KHÔNG TỐT!
  final ApiService _apiService = ApiService();
  final DatabaseService _dbService = DatabaseService();
  final LoggerService _logger = LoggerService();
  
  void _loadUser() async {
    _logger.log('Loading user...');
    final user = await _apiService.getUser('123');
    await _dbService.saveUser(user);
  }
}
```

**Vấn đề:**
- ❌ **Hard to test**: Không thể mock ApiService khi test
- ❌ **Tight coupling**: UserScreen phụ thuộc trực tiếp vào concrete classes
- ❌ **Code duplication**: Mỗi screen phải tự tạo services
- ❌ **Memory waste**: Tạo nhiều instance không cần thiết

### **Giải pháp với DI:**

```dart
// ✅ GOOD: Loosely coupled code
class _UserScreenState extends State<UserScreen> {
  // Inject dependencies từ DI container
  late final ApiService _apiService;
  late final DatabaseService _dbService;
  late final LoggerService _logger;
  
  @override
  void initState() {
    super.initState();
    // Lấy từ DI container thay vì tự tạo
    _apiService = getIt<ApiService>();
    _dbService = getIt<DatabaseService>();
    _logger = getIt<LoggerService>();
  }
}
```

**Lợi ích:**
- ✅ **Easy to test**: Có thể mock dependencies
- ✅ **Loose coupling**: Chỉ phụ thuộc vào interfaces
- ✅ **Centralized management**: Quản lý services tập trung
- ✅ **Memory efficient**: Singleton pattern cho shared services

---

## 🏗️ **TỪNG BƯỚC SETUP DI**

### **BƯỚC 1: Thêm Dependencies**

```yaml
# pubspec.yaml
dependencies:
  get_it: ^8.0.2        # Service locator
  injectable: ^2.5.0    # Code generation annotations

dev_dependencies:
  injectable_generator: ^2.6.2  # Code generator
  build_runner: ^2.4.13         # Build system
```

**Giải thích:**
- **`get_it`**: Service locator pattern - container chứa tất cả services
- **`injectable`**: Annotations để đánh dấu services (@injectable, @singleton)
- **`injectable_generator`**: Generate code registration tự động
- **`build_runner`**: Chạy code generation

### **BƯỚC 2: Tạo DI Container**

```dart
// lib/core/di/injection.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';  // File này sẽ được generate

// Global instance của GetIt container
final getIt = GetIt.instance;

// Annotation để generate code
@InjectableInit()
void configureDependencies() => getIt.init();
```

**Giải thích:**
- **`getIt`**: Global container chứa tất cả services
- **`@InjectableInit()`**: Báo cho generator biết đây là entry point
- **`injection.config.dart`**: File được generate tự động chứa registration code

### **BƯỚC 3: Tạo Services với Annotations**

#### **3.1. Factory Service (@injectable)**

```dart
// lib/services/user_service.dart
import 'package:injectable/injectable.dart';
import 'logger_service.dart';

@injectable  // Factory: tạo instance mới mỗi lần gọi
class UserService {
  final LoggerService _loggerService;
  final String _userId;
  
  // Constructor injection - DI tự động inject LoggerService
  UserService(this._loggerService) 
    : _userId = DateTime.now().millisecondsSinceEpoch.toString() {
    _loggerService.log('[UserService] New instance created with ID: $_userId');
  }
  
  String get userId => _userId;
  
  String getCurrentUser() {
    _loggerService.logInfo('Getting current user: $_userId');
    return 'User_$_userId';
  }
}
```

**Khi nào dùng @injectable:**
- ✅ Services có state riêng (như UserService với unique ID)
- ✅ Temporary objects
- ✅ Services cần fresh data mỗi lần gọi

**Ví dụ thực tế:**
- `PaymentService` - mỗi transaction cần instance riêng
- `FormValidatorService` - mỗi form cần validator riêng
- `ReportGeneratorService` - mỗi report cần instance riêng

#### **3.2. Singleton Service (@singleton)**

```dart
// lib/services/logger_service.dart
import 'package:injectable/injectable.dart';

@singleton  // Singleton: chỉ có 1 instance trong toàn app
class LoggerService {
  void log(String message) {
    print('[LOG] ${DateTime.now()}: $message');
  }
  
  void logInfo(String message) {
    print('[INFO] ${DateTime.now()}: $message');
  }
  
  void logError(String message) {
    print('[ERROR] ${DateTime.now()}: $message');
  }
}
```

**Khi nào dùng @singleton:**
- ✅ Services chia sẻ state (như Logger, Analytics)
- ✅ Expensive initialization (Database connection)
- ✅ Global configuration services

**Ví dụ thực tế:**
- `DatabaseService` - connection pool
- `AnalyticsService` - track events globally
- `AuthService` - user session state
- `CacheService` - shared cache

#### **3.3. Lazy Singleton Service (@lazySingleton)**

```dart
// lib/services/config_service.dart
import 'package:injectable/injectable.dart';

@lazySingleton  // Lazy Singleton: tạo khi lần đầu được gọi
class ConfigService {
  late final String _appName;
  late final String _version;
  late final bool _isDebugMode;
  
  ConfigService() {
    print('[ConfigService] Constructor called - Lazy Singleton initialized');
    // Expensive initialization chỉ chạy khi cần
    _appName = 'DI Learning App';
    _version = '1.0.0';
    _isDebugMode = true;
  }
  
  String get appName => _appName;
  String get version => _version;
  bool get isDebugMode => _isDebugMode;
}
```

**Khi nào dùng @lazySingleton:**
- ✅ Services ít được sử dụng
- ✅ Expensive initialization
- ✅ Optional features

**Ví dụ thực tế:**
- `ConfigService` - load config từ file
- `LocalizationService` - load translations
- `ThemeService` - load custom themes
- `FeatureFlagService` - remote config

#### **3.4. Service với Multiple Dependencies**

```dart
// lib/services/analytics_service.dart
import 'package:injectable/injectable.dart';
import 'logger_service.dart';
import 'config_service.dart';

@singleton
class AnalyticsService {
  final LoggerService _loggerService;
  final ConfigService _configService;
  int _eventCount = 0;
  
  // Constructor với multiple dependencies
  // DI sẽ tự động inject cả 2 dependencies
  AnalyticsService(this._loggerService, this._configService) {
    _loggerService.log('[AnalyticsService] Singleton initialized');
    _loggerService.logInfo('Analytics enabled for ${_configService.appName}');
  }
  
  void trackEvent(String eventName) {
    _eventCount++;
    _loggerService.log('📊 Event tracked: $eventName (Total: $_eventCount)');
    
    if (_configService.isDebugMode) {
      _loggerService.logInfo('Debug mode: Event details logged');
    }
  }
}
```

### **BƯỚC 4: Code Generation**

```yaml
# build.yaml
targets:
  $default:
    builders:
      injectable_generator:injectable_builder:
        enabled: true
```

```bash
# Chạy code generation
dart run build_runner build
```

**File được generate: `lib/core/di/injection.config.dart`**

```dart
// injection.config.dart (AUTO-GENERATED)
GetIt _$init(GetIt get) {
  get.registerFactory<UserService>(() => UserService(get<LoggerService>()));
  get.registerSingleton<LoggerService>(LoggerService());
  get.registerLazySingleton<ConfigService>(() => ConfigService());
  get.registerSingleton<AnalyticsService>(
    AnalyticsService(get<LoggerService>(), get<ConfigService>())
  );
  return get;
}
```

**Giải thích:**
- **`registerFactory`**: Tạo instance mới mỗi lần gọi
- **`registerSingleton`**: Tạo 1 instance ngay lập tức
- **`registerLazySingleton`**: Tạo 1 instance khi lần đầu gọi
- **Dependencies tự động resolve**: `get<LoggerService>()` tự động inject

### **BƯỚC 5: Khởi tạo DI trong App**

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'core/di/injection.dart';

void main() {
  // QUAN TRỌNG: Khởi tạo DI container trước khi chạy app
  configureDependencies();
  runApp(const MyApp());
}
```

### **BƯỚC 6: Sử dụng Services trong UI**

```dart
class _MyHomePageState extends State<MyHomePage> {
  // Khai báo services
  late final CounterService _counterService;
  late final LoggerService _loggerService;

  @override
  void initState() {
    super.initState();
    // Lấy services từ DI container
    _counterService = getIt<CounterService>();
    _loggerService = getIt<LoggerService>();
    
    _loggerService.logInfo('MyHomePage initialized');
  }

  void _incrementCounter() {
    setState(() {
      _counterService.increment();
      _loggerService.log('Counter incremented to ${_counterService.count}');
    });
  }
}
```

---

## 🚀 **ÁP DỤNG VÀO DỰ ÁN THỰC TẾ**

### **Scenario 1: E-commerce App**

```dart
// Services cho e-commerce app
@singleton
class AuthService {
  String? _currentUserId;
  
  bool get isLoggedIn => _currentUserId != null;
  String? get currentUserId => _currentUserId;
  
  Future<void> login(String email, String password) async {
    // Login logic
    _currentUserId = 'user_123';
  }
}

@singleton
class CartService {
  final AuthService _authService;
  final List<CartItem> _items = [];
  
  CartService(this._authService);
  
  void addItem(Product product) {
    if (!_authService.isLoggedIn) {
      throw Exception('User must be logged in');
    }
    _items.add(CartItem(product: product, userId: _authService.currentUserId!));
  }
  
  List<CartItem> get items => List.unmodifiable(_items);
}

@injectable
class OrderService {
  final CartService _cartService;
  final PaymentService _paymentService;
  final LoggerService _logger;
  
  OrderService(this._cartService, this._paymentService, this._logger);
  
  Future<Order> createOrder() async {
    _logger.log('Creating order...');
    
    final items = _cartService.items;
    if (items.isEmpty) {
      throw Exception('Cart is empty');
    }
    
    final payment = await _paymentService.processPayment(items);
    final order = Order(items: items, payment: payment);
    
    _logger.log('Order created: ${order.id}');
    return order;
  }
}
```

**Sử dụng trong UI:**

```dart
class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late final OrderService _orderService;
  late final CartService _cartService;
  
  @override
  void initState() {
    super.initState();
    _orderService = getIt<OrderService>();
    _cartService = getIt<CartService>();
  }
  
  void _checkout() async {
    try {
      final order = await _orderService.createOrder();
      // Navigate to success screen
    } catch (e) {
      // Show error
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Cart items display
          Expanded(
            child: ListView.builder(
              itemCount: _cartService.items.length,
              itemBuilder: (context, index) {
                final item = _cartService.items[index];
                return ListTile(
                  title: Text(item.product.name),
                  subtitle: Text('\$${item.product.price}'),
                );
              },
            ),
          ),
          
          // Checkout button
          ElevatedButton(
            onPressed: _checkout,
            child: Text('Checkout'),
          ),
        ],
      ),
    );
  }
}
```

### **Scenario 2: Social Media App**

```dart
@singleton
class UserProfileService {
  final ApiService _apiService;
  final CacheService _cacheService;
  UserProfile? _currentProfile;
  
  UserProfileService(this._apiService, this._cacheService);
  
  Future<UserProfile> getCurrentProfile() async {
    if (_currentProfile != null) return _currentProfile!;
    
    // Try cache first
    final cached = _cacheService.get<UserProfile>('current_profile');
    if (cached != null) {
      _currentProfile = cached;
      return cached;
    }
    
    // Fetch from API
    final profile = await _apiService.get<UserProfile>('/profile');
    _cacheService.set('current_profile', profile);
    _currentProfile = profile;
    
    return profile;
  }
}

@injectable
class PostService {
  final ApiService _apiService;
  final UserProfileService _userService;
  final AnalyticsService _analytics;
  
  PostService(this._apiService, this._userService, this._analytics);
  
  Future<void> createPost(String content) async {
    final user = await _userService.getCurrentProfile();
    
    final post = Post(
      content: content,
      authorId: user.id,
      createdAt: DateTime.now(),
    );
    
    await _apiService.post('/posts', post.toJson());
    _analytics.trackEvent('post_created');
  }
}
```

### **Scenario 3: Testing với DI**

```dart
// test/services/order_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCartService extends Mock implements CartService {}
class MockPaymentService extends Mock implements PaymentService {}
class MockLoggerService extends Mock implements LoggerService {}

void main() {
  group('OrderService', () {
    late OrderService orderService;
    late MockCartService mockCartService;
    late MockPaymentService mockPaymentService;
    late MockLoggerService mockLogger;
    
    setUp(() {
      mockCartService = MockCartService();
      mockPaymentService = MockPaymentService();
      mockLogger = MockLoggerService();
      
      // Inject mocks vào OrderService
      orderService = OrderService(
        mockCartService,
        mockPaymentService,
        mockLogger,
      );
    });
    
    test('should create order successfully', () async {
      // Arrange
      final cartItems = [CartItem(product: Product(name: 'Test'))];
      when(() => mockCartService.items).thenReturn(cartItems);
      when(() => mockPaymentService.processPayment(any()))
          .thenAnswer((_) async => Payment(amount: 100));
      
      // Act
      final order = await orderService.createOrder();
      
      // Assert
      expect(order.items, equals(cartItems));
      verify(() => mockLogger.log('Creating order...')).called(1);
      verify(() => mockLogger.log(any(that: contains('Order created')))).called(1);
    });
    
    test('should throw exception when cart is empty', () async {
      // Arrange
      when(() => mockCartService.items).thenReturn([]);
      
      // Act & Assert
      expect(
        () => orderService.createOrder(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
```

---

## 🎯 **BEST PRACTICES**

### **1. Service Organization**

```
lib/
├── core/
│   └── di/
│       ├── injection.dart
│       └── injection.config.dart (generated)
├── services/
│   ├── auth/
│   │   ├── auth_service.dart
│   │   └── token_service.dart
│   ├── api/
│   │   ├── api_service.dart
│   │   └── api_client.dart
│   ├── storage/
│   │   ├── cache_service.dart
│   │   └── database_service.dart
│   └── analytics/
│       └── analytics_service.dart
└── features/
    ├── auth/
    ├── home/
    └── profile/
```

### **2. Naming Conventions**

```dart
// ✅ GOOD
@singleton
class UserAuthenticationService { }

@injectable
class PaymentProcessingService { }

@lazySingleton
class ApplicationConfigurationService { }

// ❌ BAD
@singleton
class UserAuth { }  // Too short

@injectable
class PaymentProcessingServiceImpl { }  // Unnecessary suffix
```

### **3. Error Handling**

```dart
@injectable
class ApiService {
  final LoggerService _logger;
  final Dio _dio;
  
  ApiService(this._logger, this._dio);
  
  Future<T> get<T>(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return response.data as T;
    } catch (e) {
      _logger.logError('API Error: $e');
      rethrow;
    }
  }
}
```

### **4. Environment-specific Services**

```dart
// Development
@Environment('dev')
@singleton
class DevApiService implements ApiService {
  @override
  String get baseUrl => 'https://dev-api.example.com';
}

// Production
@Environment('prod')
@singleton
class ProdApiService implements ApiService {
  @override
  String get baseUrl => 'https://api.example.com';
}
```

---

## 🔍 **DEBUGGING & TROUBLESHOOTING**

### **Common Issues:**

**1. Service not found**
```dart
// Error: Object/factory with type ApiService is not registered inside GetIt
final api = getIt<ApiService>(); // ❌

// Solution: Check if service is annotated and build_runner was run
@injectable  // ✅ Make sure annotation exists
class ApiService { }

// Run: dart run build_runner build
```

**2. Circular dependencies**
```dart
// ❌ BAD: Circular dependency
@singleton
class ServiceA {
  ServiceA(ServiceB serviceB);
}

@singleton
class ServiceB {
  ServiceB(ServiceA serviceA);  // Circular!
}

// ✅ GOOD: Use interfaces or lazy injection
@singleton
class ServiceA {
  ServiceA(@lazy ServiceB serviceB);
}
```

**3. Missing dependencies**
```dart
// ❌ BAD: Forgot to add dependency
@injectable
class UserService {
  UserService(ApiService apiService);  // ApiService not registered
}

// ✅ GOOD: Make sure all dependencies are registered
@injectable
class ApiService { }  // Register this first

@injectable
class UserService {
  UserService(ApiService apiService);  // Now it works
}
```

---

## 📝 **CHECKLIST HOÀN THÀNH TICKET 1.1**

- [ ] ✅ Hiểu được tại sao cần DI
- [ ] ✅ Setup được get_it và injectable packages
- [ ] ✅ Tạo được DI container
- [ ] ✅ Biết cách dùng @injectable, @singleton, @lazySingleton
- [ ] ✅ Hiểu dependency injection giữa services
- [ ] ✅ Chạy được code generation
- [ ] ✅ Sử dụng services trong UI
- [ ] ✅ Biết cách test với DI
- [ ] ✅ Áp dụng được vào dự án thực tế

---

## 🎓 **KẾT LUẬN**

**Dependency Injection là nền tảng quan trọng nhất** cho Flutter enterprise development. Nó giúp:

1. **Code dễ test** - Mock dependencies dễ dàng
2. **Loose coupling** - Services không phụ thuộc trực tiếp
3. **Centralized management** - Quản lý services tập trung
4. **Scalability** - Dễ mở rộng và maintain

**Trong dự án thực tế**, em sẽ dùng DI để:
- Quản lý API services
- Handle authentication state
- Cache và database operations
- Analytics và logging
- Feature flags và configuration

**Next steps**: Sau khi master DI, em sẽ học State Management (Provider) để kết hợp với DI tạo thành architecture hoàn chỉnh.

---

*"Dependency Injection is not just a pattern, it's a mindset for writing maintainable, testable, and scalable code."* 🚀