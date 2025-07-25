# 🚀 PROJECT PREPARATION GUIDE / HƯỚNG DẪN CHUẨN BỊ DỰ ÁN
## Flutter Enterprise Development - Complete Learning Path / Phát triển Flutter Doanh nghiệp - Lộ trình Học tập Hoàn chỉnh

> **Objective / Mục tiêu:** Prepare comprehensive knowledge for Flutter enterprise project with tech stack: DI (get_it/injectable), State Management (Provider), API (Dio), Testing (mocktail/patrol)
> 
> **Chuẩn bị đầy đủ kiến thức cho dự án Flutter enterprise với tech stack: DI (get_it/injectable), State Management (Provider), API (Dio), Testing (mocktail/patrol)**

---

## 📋 **TECH STACK OVERVIEW / TỔNG QUAN TECH STACK**

### **🏗️ Architecture & Dependencies / Kiến trúc & Phụ thuộc**
- **Dependency Injection / Tiêm phụ thuộc:** `get_it` + `injectable`
- **State Management / Quản lý trạng thái:** `provider` + `change_notifier`
- **API Integration / Tích hợp API:** `dio` + `json_serializable` + `json_annotation`
- **Testing / Kiểm thử:** `mocktail` + `patrol`

### **🎯 Learning Objectives / Mục tiêu Học tập**
- **Master enterprise Flutter architecture patterns** / Thành thạo các mẫu kiến trúc Flutter doanh nghiệp
- **Implement scalable state management** / Triển khai quản lý trạng thái có thể mở rộng
- **Build robust API integration** / Xây dựng tích hợp API mạnh mẽ
- **Write comprehensive tests** / Viết các bài kiểm thử toàn diện
- **Apply best practices for production apps** / Áp dụng best practices cho ứng dụng production

---

## 📅 **14-DAY LEARNING ROADMAP / LỘ TRÌNH HỌC TẬP 14 NGÀY**

### **WEEK 1: FOUNDATION (Days 1-7) / TUẦN 1: NỀN TẢNG (Ngày 1-7)**

#### **Day 1-2: Dependency Injection Mastery / Ngày 1-2: Thành thạo Dependency Injection** 🔥 CRITICAL
**Priority / Ưu tiên:** Must learn before project start / Phải học trước khi bắt đầu dự án
**Time / Thời gian:** 4-6 hours total / Tổng cộng 4-6 giờ

**Learning Goals / Mục tiêu Học tập:**
- [ ] **Understand DI principles and benefits** / Hiểu nguyên lý và lợi ích của DI
- [ ] **Setup get_it service locator** / Thiết lập get_it service locator
- [ ] **Use injectable for code generation** / Sử dụng injectable để tạo code
- [ ] **Implement different registration types (singleton, factory, lazy)** / Triển khai các loại đăng ký khác nhau

**Tickets to Complete / Tickets cần Hoàn thành:**
- **Ticket 1.1:** Basic DI Setup / Thiết lập DI cơ bản
- **Ticket 1.2:** Service Registration / Đăng ký Services
- **Ticket 1.3:** Injectable Integration / Tích hợp Injectable

#### **Day 3-4: State Management with Provider / Ngày 3-4: Quản lý Trạng thái với Provider** 🔥 CRITICAL
**Priority / Ưu tiên:** Essential for UI state handling / Thiết yếu cho xử lý trạng thái UI
**Time / Thời gian:** 4-6 hours total / Tổng cộng 4-6 giờ

**Learning Goals / Mục tiêu Học tập:**
- [ ] **Master Provider pattern** / Thành thạo mẫu Provider
- [ ] **Implement ChangeNotifier** / Triển khai ChangeNotifier
- [ ] **Use Consumer, Selector, and context.read/watch** / Sử dụng Consumer, Selector, và context.read/watch
- [ ] **Handle loading states and errors** / Xử lý trạng thái loading và lỗi

**Tickets to Complete / Tickets cần Hoàn thành:**
- **Ticket 2.1:** Provider Setup / Thiết lập Provider
- **Ticket 2.2:** ChangeNotifier Implementation / Triển khai ChangeNotifier
- **Ticket 2.3:** UI Integration / Tích hợp UI

#### **Day 5-6: API Integration / Ngày 5-6: Tích hợp API** ⚡ HIGH
**Priority / Ưu tiên:** Core for data fetching / Cốt lõi cho việc lấy dữ liệu
**Time / Thời gian:** 4-6 hours total / Tổng cộng 4-6 giờ

**Learning Goals / Mục tiêu Học tập:**
- [ ] **Setup Dio HTTP client** / Thiết lập Dio HTTP client
- [ ] **Implement JSON serialization** / Triển khai JSON serialization
- [ ] **Handle API errors and exceptions** / Xử lý lỗi và ngoại lệ API
- [ ] **Create repository pattern** / Tạo mẫu repository

**Tickets to Complete / Tickets cần Hoàn thành:**
- **Ticket 3.1:** Dio Configuration / Cấu hình Dio
- **Ticket 3.2:** JSON Models / Mô hình JSON
- **Ticket 3.3:** API Services / Dịch vụ API

#### **Day 7: Integration & Practice / Ngày 7: Tích hợp & Thực hành**
**Priority / Ưu tiên:** Consolidate knowledge / Củng cố kiến thức
**Time / Thời gian:** 3-4 hours / 3-4 giờ

**Learning Goals / Mục tiêu Học tập:**
- [ ] **Combine all concepts in one app** / Kết hợp tất cả concepts trong một app
- [ ] **Build complete CRUD flow** / Xây dựng luồng CRUD hoàn chỉnh
- [ ] **Handle real-world scenarios** / Xử lý các tình huống thực tế

**Tickets to Complete / Tickets cần Hoàn thành:**
- **Ticket 4.1:** Complete User Management App / Ứng dụng Quản lý User hoàn chỉnh

### **WEEK 2: TESTING & ADVANCED (Days 8-14) / TUẦN 2: KIỂM THỬ & NÂNG CAO (Ngày 8-14)**

#### **Day 8-10: Testing Foundation / Ngày 8-10: Nền tảng Kiểm thử** 📚 MEDIUM
**Priority / Ưu tiên:** Important for code quality / Quan trọng cho chất lượng code
**Time / Thời gian:** 4-6 hours total / Tổng cộng 4-6 giờ

**Learning Goals / Mục tiêu Học tập:**
- [ ] **Write unit tests with mocktail** / Viết unit tests với mocktail
- [ ] **Test providers and services** / Kiểm thử providers và services
- [ ] **Mock dependencies effectively** / Mock dependencies hiệu quả
- [ ] **Test error scenarios** / Kiểm thử các tình huống lỗi

**Tickets to Complete / Tickets cần Hoàn thành:**
- **Ticket 5.1:** Unit Test Setup / Thiết lập Unit Test
- **Ticket 5.2:** Provider Testing / Kiểm thử Provider
- **Ticket 5.3:** Service Testing / Kiểm thử Service

#### **Day 11-12: Integration Testing / Ngày 11-12: Kiểm thử Tích hợp** 📚 MEDIUM
**Priority / Ưu tiên:** E2E testing skills / Kỹ năng kiểm thử E2E
**Time / Thời gian:** 3-4 hours total / Tổng cộng 3-4 giờ

**Learning Goals / Mục tiêu Học tập:**
- [ ] **Setup Patrol for integration tests** / Thiết lập Patrol cho integration tests
- [ ] **Test complete user flows** / Kiểm thử luồng user hoàn chỉnh
- [ ] **Handle async operations in tests** / Xử lý async operations trong tests

**Tickets to Complete / Tickets cần Hoàn thành:**
- **Ticket 6.1:** Patrol Setup / Thiết lập Patrol
- **Ticket 6.2:** E2E Test Scenarios / Các tình huống E2E Test

#### **Day 13-14: Advanced Patterns / Ngày 13-14: Mẫu Nâng cao** 📚 MEDIUM
**Priority / Ưu tiên:** Production-ready patterns / Mẫu sẵn sàng cho production
**Time / Thời gian:** 3-4 hours total / Tổng cộng 3-4 giờ

**Learning Goals / Mục tiêu Học tập:**
- [ ] **Implement error handling strategies** / Triển khai chiến lược xử lý lỗi
- [ ] **Apply repository pattern** / Áp dụng mẫu repository
- [ ] **Use advanced DI features** / Sử dụng tính năng DI nâng cao
- [ ] **Optimize performance** / Tối ưu hiệu suất

**Tickets to Complete / Tickets cần Hoàn thành:**
- **Ticket 7.1:** Error Handling / Xử lý Lỗi
- **Ticket 7.2:** Advanced Architecture / Kiến trúc Nâng cao

#### **Day 1-2: Dependency Injection Mastery / Ngày 1-2: Thành thạo Dependency Injection** 🔥 CRITICAL
**Priority / Ưu tiên:** Must learn before project start / Phải học trước khi bắt đầu dự án
**Time / Thời gian:** 4-6 hours total / Tổng cộng 4-6 giờ

**Learning Goals / Mục tiêu Học tập:**
- [ ] **Understand DI principles and benefits** / Hiểu nguyên tắc và lợi ích của DI
- [ ] **Setup get_it service locator** / Thiết lập service locator get_it
- [ ] **Use injectable for code generation** / Sử dụng injectable để tạo code tự động
- [ ] **Implement different registration types (singleton, factory, lazy)** / Triển khai các loại đăng ký khác nhau (singleton, factory, lazy)

**Tickets to Complete / Tickets cần Hoàn thành:**
- **Ticket 1.1:** Basic DI Setup / Thiết lập DI cơ bản
- **Ticket 1.2:** Service Registration / Đăng ký Service
- **Ticket 1.3:** Injectable Integration / Tích hợp Injectable

#### **Day 3-4: State Management with Provider / Ngày 3-4: Quản lý Trạng thái với Provider** 🔥 CRITICAL
**Priority / Ưu tiên:** Essential for UI state handling / Thiết yếu cho việc xử lý trạng thái UI
**Time / Thời gian:** 4-6 hours total / Tổng cộng 4-6 giờ

**Learning Goals / Mục tiêu Học tập:**
- [ ] **Master Provider pattern** / Thành thạo mẫu Provider
- [ ] **Implement ChangeNotifier** / Triển khai ChangeNotifier
- [ ] **Use Consumer, Selector, and context.read/watch** / Sử dụng Consumer, Selector, và context.read/watch
- [ ] **Handle loading states and errors** / Xử lý trạng thái loading và lỗi

**Tickets to Complete / Tickets cần Hoàn thành:**
- **Ticket 2.1:** Provider Setup / Thiết lập Provider
- **Ticket 2.2:** ChangeNotifier Implementation / Triển khai ChangeNotifier
- **Ticket 2.3:** UI Integration / Tích hợp UI

#### **Day 5-6: API Integration / Ngày 5-6: Tích hợp API** ⚡ HIGH
**Priority / Ưu tiên:** Core for data fetching / Cốt lõi cho việc lấy dữ liệu
**Time / Thời gian:** 4-6 hours total / Tổng cộng 4-6 giờ

**Learning Goals / Mục tiêu Học tập:**
- [ ] **Setup Dio HTTP client** / Thiết lập Dio HTTP client
- [ ] **Implement JSON serialization** / Triển khai JSON serialization
- [ ] **Handle API errors and exceptions** / Xử lý lỗi API và exceptions
- [ ] **Create repository pattern** / Tạo repository pattern

**Tickets to Complete / Tickets cần Hoàn thành:**
- **Ticket 3.1:** Dio Configuration / Cấu hình Dio
- **Ticket 3.2:** JSON Models / Mô hình JSON
- **Ticket 3.3:** API Services / Dịch vụ API

#### **Day 7: Integration & Practice**
**Priority:** Consolidate knowledge
**Time:** 3-4 hours

**Learning Goals:**
- [ ] Combine all concepts in one app
- [ ] Build complete CRUD flow
- [ ] Handle real-world scenarios

**Tickets to Complete:**
- **Ticket 4.1:** Complete User Management App

### **WEEK 2: TESTING & ADVANCED (Days 8-14)**

#### **Day 8-10: Testing Foundation** 📚 MEDIUM
**Priority:** Important for code quality
**Time:** 4-6 hours total

**Learning Goals:**
- [ ] Write unit tests with mocktail
- [ ] Test providers and services
- [ ] Mock dependencies effectively
- [ ] Test error scenarios

**Tickets to Complete:**
- **Ticket 5.1:** Unit Test Setup
- **Ticket 5.2:** Provider Testing
- **Ticket 5.3:** Service Testing

#### **Day 11-12: Integration Testing** 📚 MEDIUM
**Priority:** E2E testing skills
**Time:** 3-4 hours total

**Learning Goals:**
- [ ] Setup Patrol for integration tests
- [ ] Test complete user flows
- [ ] Handle async operations in tests

**Tickets to Complete:**
- **Ticket 6.1:** Patrol Setup
- **Ticket 6.2:** E2E Test Scenarios

#### **Day 13-14: Advanced Patterns** 📚 MEDIUM
**Priority:** Production-ready patterns
**Time:** 3-4 hours total

**Learning Goals:**
- [ ] Implement error handling strategies
- [ ] Apply repository pattern
- [ ] Use advanced DI features
- [ ] Optimize performance

**Tickets to Complete:**
- **Ticket 7.1:** Error Handling
- **Ticket 7.2:** Advanced Architecture

---

## 🎫 **DETAILED TICKETS / CHI TIẾT CÁC TICKETS**

### **TICKET 1.1: Basic DI Setup / Thiết lập DI Cơ bản** 
**Estimated Time / Thời gian Ước tính:** 2 hours / 2 giờ
**Difficulty / Độ khó:** Beginner / Người mới bắt đầu

**Objectives / Mục tiêu:**
- **Setup get_it and injectable packages** / Thiết lập các packages get_it và injectable
- **Create DI container** / Tạo DI container
- **Register first service** / Đăng ký service đầu tiên

**AI Learning Prompt / Prompt Học tập AI:**
```
I'm learning Flutter Dependency Injection with get_it and injectable. 
Tôi đang học Flutter Dependency Injection với get_it và injectable.

Please help me / Hãy giúp tôi:
1. Explain what Dependency Injection is and why it's important in Flutter
   Giải thích Dependency Injection là gì và tại sao nó quan trọng trong Flutter
2. Show me how to setup get_it and injectable packages
   Chỉ cho tôi cách thiết lập các packages get_it và injectable
3. Create a simple example with a service registration
   Tạo một ví dụ đơn giản với việc đăng ký service
4. Explain the difference between singleton, factory, and lazy singleton
   Giải thích sự khác biệt giữa singleton, factory, và lazy singleton

Please provide complete code examples with explanations for each concept.
Hãy cung cấp các ví dụ code hoàn chỉnh với giải thích cho từng concept.
```

**Success Criteria / Tiêu chí Thành công:**
- [ ] **DI container is configured** / DI container được cấu hình
- [ ] **Can register and resolve services** / Có thể đăng ký và resolve services
- [ ] **Understand different registration types** / Hiểu các loại đăng ký khác nhau

---

### **TICKET 1.2: Service Registration / Đăng ký Services**
**Estimated Time / Thời gian Ước tính:** 2 hours / 2 giờ
**Difficulty / Độ khó:** Beginner / Người mới bắt đầu

**Objectives / Mục tiêu:**
- **Create multiple services with dependencies** / Tạo nhiều services có phụ thuộc
- **Use @injectable annotation** / Sử dụng @injectable annotation
- **Generate registration code** / Tạo code đăng ký

**AI Learning Prompt / Prompt Học tập AI:**
```
I need to learn advanced service registration with injectable in Flutter.
Tôi cần học đăng ký service nâng cao với injectable trong Flutter.

Please show me / Hãy chỉ cho tôi:
1. How to create services that depend on other services
   Cách tạo services phụ thuộc vào services khác
2. How to use @injectable, @singleton, @lazySingleton annotations
   Cách sử dụng các annotations @injectable, @singleton, @lazySingleton
3. How to run build_runner to generate code
   Cách chạy build_runner để tạo code
4. How to handle different environments (dev, prod)
   Cách xử lý các môi trường khác nhau (dev, prod)

Include practical examples of / Bao gồm các ví dụ thực tế về:
- ApiService depending on Dio / ApiService phụ thuộc vào Dio
- Repository depending on ApiService / Repository phụ thuộc vào ApiService
- Provider depending on Repository / Provider phụ thuộc vào Repository

Provide complete working code with build.yaml configuration.
Cung cấp code hoạt động hoàn chỉnh với cấu hình build.yaml.
```

**Success Criteria / Tiêu chí Thành công:**
- [ ] **Multiple services with dependencies** / Nhiều services có phụ thuộc
- [ ] **Code generation working** / Code generation hoạt động
- [ ] **Environment-specific configurations** / Cấu hình theo môi trường cụ thể

---

### **TICKET 2.1: Provider Setup / Thiết lập Provider**
**Estimated Time / Thời gian Ước tính:** 2 hours / 2 giờ
**Difficulty / Độ khó:** Beginner / Người mới bắt đầu

**Objectives / Mục tiêu:**
- **Setup Provider package** / Thiết lập package Provider
- **Create ChangeNotifier classes** / Tạo các classes ChangeNotifier
- **Integrate with widget tree** / Tích hợp với widget tree

**AI Learning Prompt / Prompt Học tập AI:**
```
I'm learning Flutter state management with Provider and ChangeNotifier.
Tôi đang học quản lý trạng thái Flutter với Provider và ChangeNotifier.

Please teach me / Hãy dạy tôi:
1. How Provider pattern works in Flutter
   Cách mẫu Provider hoạt động trong Flutter
2. How to create ChangeNotifier classes for state management
   Cách tạo các classes ChangeNotifier để quản lý trạng thái
3. How to setup MultiProvider in main.dart
   Cách thiết lập MultiProvider trong main.dart
4. The difference between Consumer, Selector, and context.read/watch
   Sự khác biệt giữa Consumer, Selector, và context.read/watch

Show me a complete example of / Chỉ cho tôi ví dụ hoàn chỉnh về:
- User authentication state / Trạng thái xác thực người dùng
- Loading states and error handling / Trạng thái loading và xử lý lỗi
- UI that reacts to state changes / UI phản ứng với thay đổi trạng thái

Include best practices for performance optimization.
Bao gồm các best practices để tối ưu hiệu suất.
```

**Success Criteria / Tiêu chí Thành công:**
- [ ] **Provider is setup in app** / Provider được thiết lập trong app
- [ ] **ChangeNotifier classes created** / Các classes ChangeNotifier được tạo
- [ ] **UI responds to state changes** / UI phản ứng với thay đổi trạng thái

---

### **TICKET 2.2: ChangeNotifier Implementation**
**Estimated Time:** 2 hours
**Difficulty:** Intermediate

**Objectives:**
- Implement complex state logic
- Handle async operations
- Manage loading and error states

**AI Learning Prompt:**
```
I need to implement advanced ChangeNotifier patterns in Flutter.

Please show me:
1. How to handle async operations in ChangeNotifier
2. Best practices for loading states, error handling, and success states
3. How to prevent memory leaks and dispose resources properly
4. How to structure complex state with multiple properties

Create a complete example of UserProvider that:
- Fetches user data from API
- Handles loading, success, and error states
- Supports CRUD operations
- Integrates with dependency injection

Include error handling strategies and performance considerations.
```

**Success Criteria:**
- [ ] Complex state management implemented
- [ ] Async operations handled properly
- [ ] Error states managed effectively

---

### **TICKET 3.1: Dio Configuration**
**Estimated Time:** 2 hours
**Difficulty:** Intermediate

**Objectives:**
- Setup Dio HTTP client
- Configure interceptors
- Handle authentication

**AI Learning Prompt:**
```
I'm learning API integration in Flutter using Dio.

Please help me understand:
1. How to setup and configure Dio for production apps
2. How to create interceptors for logging, authentication, and error handling
3. How to handle different base URLs for different environments
4. How to implement retry logic and timeout handling

Show me a complete example including:
- Dio configuration with BaseOptions
- Authentication interceptor
- Logging interceptor
- Error handling interceptor
- Integration with dependency injection

Include best practices for security and performance.
```

**Success Criteria:**
- [ ] Dio is properly configured
- [ ] Interceptors are working
- [ ] Authentication is handled

---

### **TICKET 3.2: JSON Models**
**Estimated Time:** 2 hours
**Difficulty:** Intermediate

**Objectives:**
- Create JSON serializable models
- Handle complex nested objects
- Generate serialization code

**AI Learning Prompt:**
```
I need to learn JSON serialization in Flutter with json_serializable.

Please teach me:
1. How to create models with json_serializable and json_annotation
2. How to handle different JSON field names with @JsonKey
3. How to work with nested objects and lists
4. How to handle DateTime, enums, and custom types
5. How to run build_runner for code generation

Create complete examples for:
- User model with nested Address
- API response models with metadata
- Request models for POST/PUT operations
- Error response models

Include handling of null safety and optional fields.
```

**Success Criteria:**
- [ ] JSON models are created
- [ ] Code generation works
- [ ] Complex nested objects handled

---

### **TICKET 3.3: API Services**
**Estimated Time:** 2 hours
**Difficulty:** Intermediate

**Objectives:**
- Create API service classes
- Implement CRUD operations
- Handle API errors

**AI Learning Prompt:**
```
I'm building API services in Flutter with Dio and proper error handling.

Please show me:
1. How to create API service classes with CRUD operations
2. How to handle different types of API errors (network, server, parsing)
3. How to implement custom exceptions and error models
4. How to use generic types for reusable API methods
5. How to integrate API services with dependency injection

Create a complete example including:
- BaseApiService with common methods
- UserApiService with specific operations
- Custom exception classes
- Error handling strategies
- Repository pattern implementation

Include best practices for API design and error recovery.
```

**Success Criteria:**
- [ ] API services implemented
- [ ] Error handling robust
- [ ] Repository pattern applied

---

### **TICKET 5.1: Unit Test Setup**
**Estimated Time:** 2 hours
**Difficulty:** Intermediate

**Objectives:**
- Setup testing environment
- Learn mocktail basics
- Write first unit tests

**AI Learning Prompt:**
```
I'm learning unit testing in Flutter with mocktail.

Please teach me:
1. How to setup testing environment with mocktail
2. How to create mocks for services and repositories
3. How to write unit tests for ChangeNotifier classes
4. How to test async operations and error scenarios
5. How to organize test files and use test groups

Show me complete examples of testing:
- UserProvider with mocked UserRepository
- ApiService with mocked Dio responses
- Error scenarios and edge cases
- Async operations with proper verification

Include best practices for test organization and maintainability.
```

**Success Criteria:**
- [ ] Testing environment setup
- [ ] Mock objects created
- [ ] Unit tests passing

---

### **TICKET 6.1: Patrol Setup**
**Estimated Time:** 2 hours
**Difficulty:** Advanced

**Objectives:**
- Setup Patrol for integration testing
- Write E2E test scenarios
- Test complete user flows

**AI Learning Prompt:**
```
I need to learn integration testing in Flutter with Patrol.

Please help me:
1. Setup Patrol for integration testing
2. Understand the difference between widget tests and integration tests
3. Write E2E tests for complete user flows
4. Handle async operations and network calls in tests
5. Test navigation and state persistence

Create examples for testing:
- User login flow
- CRUD operations with API calls
- Navigation between screens
- Error scenarios and recovery
- Form validation and submission

Include setup for CI/CD and best practices for reliable tests.
```

**Success Criteria:**
- [ ] Patrol is configured
- [ ] E2E tests written
- [ ] User flows tested

---

## 🤖 **AI LEARNING PROMPTS LIBRARY**

### **General Learning Prompt Template**
```
I'm a Flutter developer preparing for an enterprise project. I need to learn [TOPIC] with focus on production-ready code.

Context:
- Tech stack: get_it, injectable, provider, dio, mocktail, patrol
- Target: Enterprise Flutter application
- Level: [Beginner/Intermediate/Advanced]

Please help me:
1. [Specific learning objective 1]
2. [Specific learning objective 2]
3. [Specific learning objective 3]

Requirements:
- Provide complete, runnable code examples
- Explain best practices and common pitfalls
- Include error handling and edge cases
- Show integration with other parts of the tech stack
- Suggest testing strategies

Please structure your response with:
- Concept explanation
- Step-by-step implementation
- Complete code examples
- Best practices
- Common mistakes to avoid
```

### **Debugging Prompt Template**
```
I'm having an issue with [SPECIFIC PROBLEM] in my Flutter project.

Tech Stack:
- Dependency Injection: get_it + injectable
- State Management: Provider
- API: Dio + json_serializable
- Testing: mocktail + patrol

Error/Issue:
[Paste error message or describe the problem]

Current Code:
[Paste relevant code]

Expected Behavior:
[Describe what should happen]

Please help me:
1. Identify the root cause
2. Provide a solution with explanation
3. Suggest best practices to prevent similar issues
4. Show how to test the fix

Include complete corrected code and explanation of changes.
```

### **Code Review Prompt Template**
```
Please review my Flutter code for enterprise project standards.

Tech Stack: get_it, injectable, provider, dio, mocktail, patrol

Code to Review:
[Paste your code]

Please check for:
1. Architecture and design patterns
2. Error handling and edge cases
3. Performance considerations
4. Testing coverage
5. Code organization and maintainability
6. Security best practices
7. Memory leaks and resource management

Provide:
- Specific feedback with line references
- Improved code examples
- Best practice recommendations
- Testing suggestions
```

---

## 📚 **QUICK REFERENCE GUIDES / HƯỚNG DẪN THAM KHẢO NHANH**

### **Dependency Injection Cheat Sheet / Bảng Tóm tắt Dependency Injection**
```dart
// Basic Setup / Thiết lập Cơ bản
final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();

// Registration Types / Các Loại Đăng ký
@injectable // Factory - new instance each time / Tạo instance mới mỗi lần
@singleton // Single instance for app lifetime / Instance duy nhất cho vòng đời app
@lazySingleton // Created when first requested / Tạo khi được yêu cầu lần đầu

// Usage / Sử dụng
final service = getIt<ApiService>();
```

### **Provider Cheat Sheet / Bảng Tóm tắt Provider**
```dart
// Provider Setup / Thiết lập Provider
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()),
  ],
  child: MyApp(),
)

// Usage in Widgets / Sử dụng trong Widgets
Consumer<UserProvider>(
  builder: (context, provider, child) => Text(provider.data),
)

// Direct access / Truy cập trực tiếp
context.read<UserProvider>().method(); // Đọc và gọi method
context.watch<UserProvider>().data;    // Theo dõi thay đổi data
```

### **Dio Cheat Sheet / Bảng Tóm tắt Dio**
```dart
// Basic Configuration / Cấu hình Cơ bản
final dio = Dio(BaseOptions(
  baseUrl: 'https://api.example.com',
  connectTimeout: Duration(seconds: 5), // Timeout kết nối
));

// Interceptors / Bộ chặn
dio.interceptors.add(LogInterceptor());  // Ghi log requests
dio.interceptors.add(AuthInterceptor()); // Xử lý authentication

// Usage / Sử dụng
final response = await dio.get('/users');
final users = (response.data as List)
    .map((json) => User.fromJson(json))
    .toList();
```

### **Testing Cheat Sheet / Bảng Tóm tắt Testing**
```dart
// Mock Creation / Tạo Mock
class MockApiService extends Mock implements ApiService {}

// Test Setup / Thiết lập Test
setUp(() {
  mockApiService = MockApiService();
  provider = UserProvider(mockApiService);
});

// Stubbing / Giả lập hành vi
when(() => mockApiService.getUsers())
    .thenAnswer((_) async => [User(id: 1, name: 'Test')]);

// Verification / Xác minh
verify(() => mockApiService.getUsers()).called(1); // Kiểm tra được gọi 1 lần
```

---

## ✅ **DAILY PROGRESS TRACKER / THEO DÕI TIẾN ĐỘ HÀNG NGÀY**

### **Day 1-2: Dependency Injection / Ngày 1-2: Dependency Injection**
- [ ] **Understand DI concepts** / Hiểu các khái niệm DI
- [ ] **Setup get_it package** / Thiết lập package get_it
- [ ] **Configure injectable** / Cấu hình injectable
- [ ] **Create first services** / Tạo các services đầu tiên
- [ ] **Test service resolution** / Kiểm thử việc resolve services

**Daily Reflection Questions / Câu hỏi Suy ngẫm Hàng ngày:**
- **What is the main benefit of DI in Flutter?** / Lợi ích chính của DI trong Flutter là gì?
- **How does injectable simplify service registration?** / Injectable đơn giản hóa việc đăng ký service như thế nào?
- **What's the difference between singleton and factory?** / Sự khác biệt giữa singleton và factory là gì?

### **Day 3-4: State Management / Ngày 3-4: Quản lý Trạng thái**
- [ ] **Setup Provider package** / Thiết lập package Provider
- [ ] **Create ChangeNotifier classes** / Tạo các classes ChangeNotifier
- [ ] **Implement UI integration** / Triển khai tích hợp UI
- [ ] **Handle async operations** / Xử lý các operations bất đồng bộ
- [ ] **Manage error states** / Quản lý trạng thái lỗi

**Daily Reflection Questions / Câu hỏi Suy ngẫm Hàng ngày:**
- **When should I use Consumer vs Selector?** / Khi nào nên dùng Consumer vs Selector?
- **How do I prevent unnecessary rebuilds?** / Làm thế nào để ngăn chặn rebuilds không cần thiết?
- **What's the best way to handle loading states?** / Cách tốt nhất để xử lý loading states là gì?

### **Day 5-6: API Integration / Ngày 5-6: Tích hợp API**
- [ ] **Configure Dio client** / Cấu hình Dio client
- [ ] **Create JSON models** / Tạo các JSON models
- [ ] **Implement API services** / Triển khai API services
- [ ] **Handle errors properly** / Xử lý lỗi đúng cách
- [ ] **Test API integration** / Kiểm thử tích hợp API

**Daily Reflection Questions / Câu hỏi Suy ngẫm Hàng ngày:**
- **How do I handle different types of API errors?** / Làm thế nào để xử lý các loại lỗi API khác nhau?
- **What's the best way to structure API responses?** / Cách tốt nhất để cấu trúc API responses là gì?
- **How do I implement retry logic?** / Làm thế nào để triển khai logic retry?

### **Day 7: Integration / Ngày 7: Tích hợp**
- [ ] **Combine all concepts** / Kết hợp tất cả các khái niệm
- [ ] **Build complete CRUD app** / Xây dựng ứng dụng CRUD hoàn chỉnh
- [ ] **Test user flows** / Kiểm thử các luồng người dùng
- [ ] **Handle edge cases** / Xử lý các trường hợp đặc biệt
- [ ] **Optimize performance** / Tối ưu hiệu suất

**Daily Reflection Questions / Câu hỏi Suy ngẫm Hàng ngày:**
- **How do all the pieces fit together?** / Tất cả các phần khớp với nhau như thế nào?
- **What are the potential bottlenecks?** / Các nút thắt cổ chai tiềm ẩn là gì?
- **How can I improve the architecture?** / Làm thế nào để cải thiện kiến trúc?

---

## 🎯 **PROJECT SIMULATION EXERCISES**

### **Exercise 1: User Management System**
**Objective:** Build a complete user management system

**Requirements:**
- User list with pagination
- User detail view
- Create/Edit user forms
- Delete confirmation
- Search and filtering
- Offline support

**Tech Implementation:**
- DI for service management
- Provider for state management
- Dio for API calls
- Comprehensive testing

### **Exercise 2: E-commerce Product Catalog**
**Objective:** Create a product browsing experience

**Requirements:**
- Product grid with images
- Category filtering
- Search functionality
- Product details
- Shopping cart
- Wishlist feature

**Tech Implementation:**
- Complex state management
- Image caching
- API optimization
- Performance testing

### **Exercise 3: Chat Application**
**Objective:** Real-time messaging system

**Requirements:**
- Message list
- Send messages
- Real-time updates
- User presence
- Message status
- File attachments

**Tech Implementation:**
- WebSocket integration
- Stream management
- Complex UI states
- Integration testing

---

## 🚨 **COMMON PITFALLS & SOLUTIONS**

### **Dependency Injection Issues**
**Problem:** Circular dependencies
**Solution:** Use interfaces and lazy initialization

**Problem:** Service not found
**Solution:** Check registration and import statements

### **State Management Issues**
**Problem:** Unnecessary rebuilds
**Solution:** Use Selector and const constructors

**Problem:** Memory leaks
**Solution:** Proper dispose in ChangeNotifier

### **API Integration Issues**
**Problem:** Network timeouts
**Solution:** Implement retry logic and proper timeouts

**Problem:** JSON parsing errors
**Solution:** Handle null values and use proper error handling

### **Testing Issues**
**Problem:** Flaky tests
**Solution:** Proper async handling and deterministic data

**Problem:** Hard to mock dependencies
**Solution:** Use interfaces and dependency injection

---

## 📞 **EMERGENCY HELP PROMPTS**

### **When Stuck on DI:**
```
I'm stuck with dependency injection in Flutter. Here's my current setup:

[Paste your DI configuration]

The issue is: [Describe the problem]

Please help me:
1. Identify what's wrong
2. Fix the configuration
3. Explain why it wasn't working
4. Show best practices for this scenario
```

### **When State Management Breaks:**
```
My Provider state management isn't working as expected.

Current Provider code:
[Paste your ChangeNotifier class]

UI code:
[Paste your Consumer/widget code]

Problem: [Describe what's happening vs what should happen]

Please help me debug and fix this issue with explanation.
```

### **When API Calls Fail:**
```
My API integration with Dio is failing.

Dio configuration:
[Paste your Dio setup]

API service:
[Paste your API service code]

Error:
[Paste error message]

Please help me fix this and implement proper error handling.
```

### **When Tests Don't Pass:**
```
My tests are failing and I can't figure out why.

Test code:
[Paste your test]

Error message:
[Paste error]

Code being tested:
[Paste the actual code]

Please help me fix the test and explain what was wrong.
```

---

## 🎓 **GRADUATION CRITERIA / TIÊU CHÍ TỐT NGHIỆP**

### **You're ready for the project when you can / Bạn sẵn sàng cho dự án khi có thể:**

#### **Dependency Injection (Must Have) / Dependency Injection (Bắt buộc)**
- [ ] **Setup DI container from scratch** / Thiết lập DI container từ đầu
- [ ] **Register services with different lifetimes** / Đăng ký services với các vòng đời khác nhau
- [ ] **Resolve dependencies in any part of the app** / Resolve dependencies ở bất kỳ phần nào của app
- [ ] **Handle circular dependencies** / Xử lý circular dependencies
- [ ] **Configure environment-specific services** / Cấu hình services theo môi trường cụ thể

#### **State Management (Must Have) / Quản lý Trạng thái (Bắt buộc)**
- [ ] **Create ChangeNotifier classes for complex state** / Tạo classes ChangeNotifier cho trạng thái phức tạp
- [ ] **Handle async operations with proper loading states** / Xử lý async operations với loading states phù hợp
- [ ] **Implement error handling and recovery** / Triển khai xử lý lỗi và phục hồi
- [ ] **Optimize performance with Selector** / Tối ưu hiệu suất với Selector
- [ ] **Integrate state with navigation** / Tích hợp state với navigation

#### **API Integration (Must Have) / Tích hợp API (Bắt buộc)**
- [ ] **Configure Dio for production use** / Cấu hình Dio cho sử dụng production
- [ ] **Create JSON serializable models** / Tạo các JSON serializable models
- [ ] **Implement CRUD operations** / Triển khai các operations CRUD
- [ ] **Handle all types of errors gracefully** / Xử lý tất cả các loại lỗi một cách graceful
- [ ] **Implement caching and offline support** / Triển khai caching và hỗ trợ offline

#### **Testing (Should Have) / Kiểm thử (Nên có)**
- [ ] **Write unit tests for all business logic** / Viết unit tests cho tất cả business logic
- [ ] **Mock dependencies effectively** / Mock dependencies hiệu quả
- [ ] **Test error scenarios** / Kiểm thử các tình huống lỗi
- [ ] **Write integration tests for user flows** / Viết integration tests cho user flows
- [ ] **Achieve >80% code coverage** / Đạt được >80% code coverage

#### **Architecture (Should Have) / Kiến trúc (Nên có)**
- [ ] **Apply repository pattern** / Áp dụng repository pattern
- [ ] **Separate concerns properly** / Tách biệt concerns đúng cách
- [ ] **Handle cross-cutting concerns** / Xử lý cross-cutting concerns
- [ ] **Implement proper error boundaries** / Triển khai error boundaries phù hợp
- [ ] **Design for scalability** / Thiết kế cho khả năng mở rộng

---

## 🌟 **FINAL TIPS FOR SUCCESS / MẸO CUỐI CÙNG ĐỂ THÀNH CÔNG**

### **Before Starting Each Day / Trước khi Bắt đầu Mỗi Ngày:**
1. **Review the previous day's learnings** / Ôn lại những gì đã học ngày hôm trước
2. **Set clear objectives for the day** / Đặt mục tiêu rõ ràng cho ngày hôm đó
3. **Prepare your development environment** / Chuẩn bị môi trường phát triển
4. **Have the AI prompts ready** / Chuẩn bị sẵn các AI prompts

### **During Learning / Trong quá trình Học:**
1. **Code along with examples** / Code theo các ví dụ
2. **Modify examples to test understanding** / Sửa đổi ví dụ để kiểm tra hiểu biết
3. **Ask "what if" questions** / Đặt câu hỏi "nếu như"
4. **Document your learnings** / Ghi chép lại những gì học được

### **After Each Session / Sau Mỗi Phiên học:**
1. **Summarize key learnings** / Tóm tắt những điểm học chính
2. **Identify areas that need more practice** / Xác định các lĩnh vực cần thực hành thêm
3. **Plan the next learning session** / Lên kế hoạch cho phiên học tiếp theo
4. **Update your progress tracker** / Cập nhật bảng theo dõi tiến độ

### **When You Get Stuck / Khi Bạn Gặp Khó khăn:**
1. **Use the emergency help prompts** / Sử dụng các emergency help prompts
2. **Break down the problem into smaller parts** / Chia nhỏ vấn đề thành các phần nhỏ hơn
3. **Search for similar issues online** / Tìm kiếm các vấn đề tương tự trực tuyến
4. **Don't spend more than 30 minutes stuck - ask for help** / Đừng mắc kẹt quá 30 phút - hãy nhờ giúp đỡ

### **Project Readiness Checklist / Danh sách Kiểm tra Sẵn sàng Dự án:**
- [ ] **Can build a complete CRUD app from scratch** / Có thể xây dựng ứng dụng CRUD hoàn chỉnh từ đầu
- [ ] **Understand how all pieces fit together** / Hiểu cách tất cả các phần khớp với nhau
- [ ] **Can debug common issues independently** / Có thể debug các vấn đề thường gặp một cách độc lập
- [ ] **Have tested your knowledge with practice projects** / Đã kiểm tra kiến thức với các dự án thực hành
- [ ] **Feel confident about the tech stack** / Cảm thấy tự tin về tech stack

---

## 📱 **CONTACT & SUPPORT**

### **When You Need Help:**
1. **Use the AI prompts** provided in this guide
2. **Check the common pitfalls** section
3. **Review the quick reference** guides
4. **Practice with the simulation exercises**

### **Remember:**
- **Learning is iterative** - don't expect to master everything immediately
- **Practice is key** - build real projects to solidify knowledge
- **Ask questions** - use AI assistants effectively with the provided prompts
- **Stay consistent** - follow the daily schedule
- **Be patient** - enterprise development skills take time to develop

---

**Good luck with your project preparation! You've got this! 🚀**

*"The expert in anything was once a beginner who refused to give up."*