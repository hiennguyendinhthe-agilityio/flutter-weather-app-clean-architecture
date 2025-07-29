# TUẦN 1-2: FOUNDATION LEARNING PLAN

## MỤC TIÊU
Nắm vững 3 pillars cơ bản nhất: Provider, Get_it, và Dio để có thể đọc hiểu và maintain code hiện tại.

## TUẦN 1: STATE MANAGEMENT & DEPENDENCY INJECTION

### Ngày 1-2: Provider Deep Dive
**Morning (2-3 hours)**
```dart
// Tạo project demo: provider_demo
// Implement basic counter với Provider
class CounterProvider extends ChangeNotifier {
  int _count = 0;
  int get count => _count;
  
  void increment() {
    _count++;
    notifyListeners();
  }
}
```

**Afternoon (2-3 hours)**
- Đọc và analyze `lib/providers/counter_provider.dart` trong project hiện tại
- So sánh implementation của team với demo của em
- Tạo thêm 1-2 providers khác (UserProvider, SettingsProvider)

**Evening (1 hour)**
- Đọc documentation: https://pub.dev/packages/provider
- Note lại những điểm chưa hiểu

### Ngày 3-4: Get_it Dependency Injection
**Morning**
```dart
// Setup Get_it basic
final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<ApiService>(ApiService());
  getIt.registerFactory<UserRepository>(() => UserRepository());
}
```

**Afternoon**
- Analyze `lib/services/` folder trong project
- Hiểu cách team setup DI
- Tạo demo service với Get_it

**Evening**
- Đọc về Injectable annotations
- Hiểu build_runner process

### Ngày 5-7: Dio HTTP Client
**Morning**
```dart
// Basic Dio setup
final dio = Dio();
dio.interceptors.add(LogInterceptor());

// API calls
Future<User> getUser(int id) async {
  final response = await dio.get('/users/$id');
  return User.fromJson(response.data);
}
```

**Afternoon**
- Analyze `lib/services/dio_service.dart`
- Hiểu interceptors được sử dụng
- Tạo demo API calls

**Evening**
- Error handling strategies
- Testing HTTP calls

## TUẦN 2: INTEGRATION & PRACTICE

### Ngày 8-10: Kết hợp Provider + Get_it + Dio
**Project**: Tạo mini app "User Management"
- UserProvider sử dụng UserApiService (từ Get_it)
- UserApiService sử dụng Dio
- UI consume UserProvider

### Ngày 11-12: Code Review & Refactoring
- Review code hiện tại với kiến thức mới
- Identify patterns được sử dụng
- Suggest improvements (nếu có)

### Ngày 13-14: Testing Foundation
- Unit test cho Providers
- Mock services với Mocktail
- Integration test cơ bản

## DAILY SCHEDULE TEMPLATE

### Morning Session (9:00-12:00)
- 30 phút: Review kiến thức ngày hôm trước
- 2 giờ: Hands-on coding/learning
- 30 phút: Note taking và planning

### Afternoon Session (14:00-17:00)
- 1 giờ: Analyze project code
- 1.5 giờ: Apply kiến thức vào project demo
- 30 phút: Compare với best practices

### Evening Session (19:00-20:00)
- Documentation reading
- Prepare questions cho ngày hôm sau
- Quick review

## CHECKPOINTS

### End of Week 1
- [ ] Có thể tạo Provider từ đầu
- [ ] Hiểu Get_it registration
- [ ] Có thể make basic API calls với Dio
- [ ] Đọc hiểu được code trong project

### End of Week 2
- [ ] Có thể integrate cả 3 concepts
- [ ] Viết được basic tests
- [ ] Confident để take on small tasks
- [ ] Có list câu hỏi cụ thể cho team

## RESOURCES CHO 2 TUẦN ĐẦU

### Must-read Documentation
1. Provider: https://pub.dev/packages/provider
2. Get_it: https://pub.dev/packages/get_it
3. Dio: https://pub.dev/packages/dio

### Video Resources
- Flutter Provider explained (YouTube)
- Dependency Injection in Flutter
- HTTP requests with Dio

### Practice Projects
1. Counter app với Provider
2. Todo app với Get_it
3. Weather app với Dio
4. Combined mini social app

## TIPS ĐỂ KHÔNG BỊ OVERWHELM

### Focus Rule
- Chỉ học 1 concept mỗi lần
- Practice trước khi move on
- Don't compare với senior developers

### Progress Tracking
- Daily checklist
- Code commits để track progress
- Weekly self-assessment

### When Stuck
1. Google the specific error
2. Check Stack Overflow
3. Read official docs again
4. Ask team/mentor
5. Take a break và come back fresh

## EXPECTED OUTCOMES

Sau 2 tuần, em sẽ:
- Confident với 3 core concepts
- Có thể đọc hiểu 80% code trong project
- Ready để take on beginner-friendly tasks
- Có foundation vững để học advanced topics