# HƯỚNG DẪN TIẾP CẬN TASK CHUYÊN NGHIỆP

## 🎯 MINDSET CỦA DEVELOPER CHUYÊN NGHIỆP

### Không phải chỉ là "Code Monkey"
```
❌ Junior mindset: "Nhận task → Code ngay → Submit"
✅ Professional mindset: "Hiểu → Phân tích → Thiết kế → Code → Test → Review → Deploy"
```

### Tư duy như một Problem Solver
- **Không chỉ implement** mà **solve business problems**
- **Không chỉ làm theo yêu cầu** mà **suggest improvements**
- **Không chỉ code** mà **think about maintainability**

## 📋 QUY TRÌNH 7 BƯỚC TIẾP CẬN TASK

### BƯỚC 1: UNDERSTAND & CLARIFY (30-60 phút)
```markdown
## Questions to ask yourself:
1. **Business Context**: Tại sao cần feature này?
2. **User Impact**: Ai sẽ sử dụng? Như thế nào?
3. **Technical Context**: Fit vào architecture hiện tại ra sao?
4. **Success Criteria**: Làm sao biết task hoàn thành?
5. **Edge Cases**: Những trường hợp đặc biệt nào?
```

**Ví dụ Task**: "Implement user profile page"

❌ **Junior approach**: Bắt đầu code ngay
✅ **Professional approach**:
```dart
// Questions to clarify:
// 1. Profile của ai? Current user hay any user?
// 2. Những fields nào cần hiển thị?
// 3. User có thể edit không?
// 4. Cần authentication không?
// 5. Data từ đâu? API nào?
// 6. Offline support cần không?
// 7. Loading states như thế nào?
// 8. Error handling ra sao?
```

### BƯỚC 2: RESEARCH & ANALYSIS (60-90 phút)
```markdown
## Technical Research Checklist:
- [ ] Đọc existing codebase patterns
- [ ] Check có similar features không
- [ ] Research packages cần thiết
- [ ] Analyze API documentation
- [ ] Review design mockups/wireframes
- [ ] Check performance requirements
```

**Practical Example**:
```bash
# Research existing patterns
grep -r "Provider" lib/providers/
grep -r "ApiService" lib/services/
grep -r "UserModel" lib/models/

# Check routing patterns
grep -r "Navigator" lib/pages/

# Analyze similar pages
find lib/pages -name "*profile*" -o -name "*user*"
```

### BƯỚC 3: DESIGN & ARCHITECTURE (45-60 phút)
```markdown
## Architecture Planning:
1. **Data Flow**: API → Service → Provider → UI
2. **State Management**: Cần Provider nào?
3. **Error Handling**: Try-catch ở đâu?
4. **Loading States**: Spinner, skeleton, shimmer?
5. **Navigation**: Route structure ra sao?
6. **Testing Strategy**: Unit, Widget, Integration tests
```

**Design Document Template**:
```markdown
# User Profile Feature Design

## Overview
Display and edit user profile information

## Architecture
```
UserProfilePage
├── UserProfileProvider (State Management)
├── UserApiService (Data Layer)
├── UserModel (Data Model)
└── ProfileWidgets (UI Components)
```

## API Integration
- GET /api/users/{id} - Fetch user data
- PUT /api/users/{id} - Update user data

## State Management
- UserProfileProvider extends ChangeNotifier
- States: loading, loaded, error, updating

## Error Handling
- Network errors → Retry button
- Validation errors → Field-level messages
- Server errors → Generic error message

## Testing Plan
- Unit tests: UserApiService, UserProfileProvider
- Widget tests: UserProfilePage, form validation
- Integration tests: Full user flow
```

### BƯỚC 4: BREAK DOWN & ESTIMATE (30 phút)
```markdown
## Task Breakdown:
1. **Models & DTOs** (2 hours)
   - UserModel class
   - API response models
   - Validation logic

2. **API Service** (3 hours)
   - GET user profile
   - UPDATE user profile
   - Error handling

3. **Provider/State Management** (2 hours)
   - UserProfileProvider
   - Loading states
   - Error states

4. **UI Implementation** (4 hours)
   - Profile display screen
   - Edit profile screen
   - Form validation
   - Loading indicators

5. **Testing** (3 hours)
   - Unit tests
   - Widget tests
   - Integration tests

6. **Code Review & Refinement** (1 hour)

**Total Estimate: 15 hours**
```

### BƯỚC 5: IMPLEMENTATION (Theo breakdown)
```markdown
## Implementation Order:
1. **Bottom-up approach**: Models → Services → Providers → UI
2. **Test-driven**: Write tests first, then implementation
3. **Incremental**: Commit small, working pieces
4. **Documentation**: Comment complex logic
```

**Professional Implementation Example**:
```dart
// 1. Start with models
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
  });
  
  // Factory constructor with validation
  factory UserModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null || json['name'] == null) {
      throw ApiException('Invalid user data');
    }
    
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    if (avatar != null) 'avatar': avatar,
  };
  
  // CopyWith for immutability
  UserModel copyWith({
    String? name,
    String? email,
    String? avatar,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
    );
  }
}

// 2. API Service with proper error handling
class UserApiService {
  final Dio _dio;
  
  UserApiService(this._dio);
  
  Future<UserModel> getUserProfile(String userId) async {
    try {
      final response = await _dio.get('/api/users/$userId');
      
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw ApiException('Failed to fetch user profile');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw UserNotFoundException('User not found');
      } else if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Authentication required');
      } else {
        throw NetworkException('Network error occurred');
      }
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }
  
  Future<UserModel> updateUserProfile(String userId, UserModel user) async {
    try {
      final response = await _dio.put(
        '/api/users/$userId',
        data: user.toJson(),
      );
      
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw ApiException('Failed to update user profile');
      }
    } on DioException catch (e) {
      // Handle specific errors
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'] as Map<String, dynamic>?;
        throw ValidationException('Validation failed', errors);
      }
      throw NetworkException('Network error occurred');
    }
  }
}

// 3. Provider with proper state management
class UserProfileProvider extends ChangeNotifier {
  final UserApiService _userApiService;
  
  UserProfileProvider(this._userApiService);
  
  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  bool _isUpdating = false;
  
  // Getters
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isUpdating => _isUpdating;
  
  // Load user profile
  Future<void> loadUserProfile(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _user = await _userApiService.getUserProfile(userId);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Update user profile
  Future<bool> updateUserProfile(UserModel updatedUser) async {
    if (_user == null) return false;
    
    _isUpdating = true;
    _error = null;
    notifyListeners();
    
    try {
      _user = await _userApiService.updateUserProfile(_user!.id, updatedUser);
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }
  
  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

// 4. UI with proper error handling and loading states
class UserProfilePage extends StatefulWidget {
  final String userId;
  
  const UserProfilePage({Key? key, required this.userId}) : super(key: key);
  
  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  void initState() {
    super.initState();
    // Load user profile when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProfileProvider>().loadUserProfile(widget.userId);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEditProfile(),
          ),
        ],
      ),
      body: Consumer<UserProfileProvider>(
        builder: (context, provider, child) {
          // Loading state
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          // Error state
          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${provider.error}',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadUserProfile(widget.userId),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          // Success state
          final user = provider.user;
          if (user == null) {
            return const Center(
              child: Text('No user data available'),
            );
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar section
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: user.avatar != null
                        ? NetworkImage(user.avatar!)
                        : null,
                    child: user.avatar == null
                        ? Text(
                            user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                            style: const TextStyle(fontSize: 32),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 24),
                
                // User info
                _buildInfoCard('Name', user.name),
                const SizedBox(height: 12),
                _buildInfoCard('Email', user.email),
                const SizedBox(height: 12),
                _buildInfoCard('User ID', user.id),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildInfoCard(String label, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 80,
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _navigateToEditProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditUserProfilePage(userId: widget.userId),
      ),
    );
  }
}
```

### BƯỚC 6: TESTING (Không bỏ qua!)
```dart
// Unit test for UserApiService
class UserApiServiceTest {
  late MockDio mockDio;
  late UserApiService userApiService;
  
  setUp(() {
    mockDio = MockDio();
    userApiService = UserApiService(mockDio);
  });
  
  group('getUserProfile', () {
    test('should return UserModel when API call is successful', () async {
      // Arrange
      const userId = '123';
      final responseData = {
        'id': userId,
        'name': 'John Doe',
        'email': 'john@example.com',
      };
      
      when(() => mockDio.get('/api/users/$userId'))
          .thenAnswer((_) async => Response(
                data: responseData,
                statusCode: 200,
                requestOptions: RequestOptions(path: '/api/users/$userId'),
              ));
      
      // Act
      final result = await userApiService.getUserProfile(userId);
      
      // Assert
      expect(result.id, equals(userId));
      expect(result.name, equals('John Doe'));
      expect(result.email, equals('john@example.com'));
    });
    
    test('should throw UserNotFoundException when user not found', () async {
      // Arrange
      const userId = '123';
      
      when(() => mockDio.get('/api/users/$userId'))
          .thenThrow(DioException(
            response: Response(
              statusCode: 404,
              requestOptions: RequestOptions(path: '/api/users/$userId'),
            ),
            requestOptions: RequestOptions(path: '/api/users/$userId'),
          ));
      
      // Act & Assert
      expect(
        () => userApiService.getUserProfile(userId),
        throwsA(isA<UserNotFoundException>()),
      );
    });
  });
}

// Widget test for UserProfilePage
class UserProfilePageTest {
  testWidgets('should display loading indicator when loading', (tester) async {
    // Arrange
    final mockProvider = MockUserProfileProvider();
    when(() => mockProvider.isLoading).thenReturn(true);
    when(() => mockProvider.error).thenReturn(null);
    when(() => mockProvider.user).thenReturn(null);
    
    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<UserProfileProvider>.value(
          value: mockProvider,
          child: const UserProfilePage(userId: '123'),
        ),
      ),
    );
    
    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
  
  testWidgets('should display user info when loaded successfully', (tester) async {
    // Arrange
    final user = UserModel(
      id: '123',
      name: 'John Doe',
      email: 'john@example.com',
    );
    
    final mockProvider = MockUserProfileProvider();
    when(() => mockProvider.isLoading).thenReturn(false);
    when(() => mockProvider.error).thenReturn(null);
    when(() => mockProvider.user).thenReturn(user);
    
    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<UserProfileProvider>.value(
          value: mockProvider,
          child: const UserProfilePage(userId: '123'),
        ),
      ),
    );
    
    // Assert
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('john@example.com'), findsOneWidget);
  });
}
```

### BƯỚC 7: CODE REVIEW & DOCUMENTATION
```markdown
## Self Code Review Checklist:
- [ ] Code follows project conventions
- [ ] Proper error handling implemented
- [ ] Loading states handled
- [ ] Edge cases covered
- [ ] Performance optimized
- [ ] Tests written and passing
- [ ] Documentation updated
- [ ] No hardcoded values
- [ ] Accessibility considered
- [ ] Security best practices followed

## Documentation to Update:
- [ ] README.md (if new features)
- [ ] API documentation
- [ ] Code comments for complex logic
- [ ] Changelog/Release notes
```

## 🚀 PROFESSIONAL HABITS

### 1. Communication Throughout Process
```markdown
## Daily Updates:
- Morning: "Starting work on user profile feature"
- Midday: "Completed API service, working on UI now"
- Evening: "UI 80% done, found edge case with validation, will handle tomorrow"

## Proactive Communication:
- "I found a potential security issue while implementing this"
- "This approach might be better for performance"
- "I need clarification on this requirement"
```

### 2. Documentation Mindset
```dart
// ❌ Bad comment
// Get user data
final user = await api.getUser(id);

// ✅ Good comment
// Fetch user profile with retry logic for network failures
// Throws UserNotFoundException if user doesn't exist
// Caches result for 5 minutes to reduce API calls
final user = await api.getUserWithRetry(id);
```

### 3. Think About Future Maintenance
```dart
// ❌ Hard to maintain
if (user.type == 1) {
  // Admin user
} else if (user.type == 2) {
  // Regular user
} else if (user.type == 3) {
  // Guest user
}

// ✅ Easy to maintain
enum UserType { admin, regular, guest }

switch (user.type) {
  case UserType.admin:
    // Admin user logic
    break;
  case UserType.regular:
    // Regular user logic
    break;
  case UserType.guest:
    // Guest user logic
    break;
}
```

## 🎯 SUCCESS METRICS

### Technical Quality
- [ ] Code coverage > 80%
- [ ] No critical bugs in production
- [ ] Performance meets requirements
- [ ] Follows architectural patterns

### Professional Growth
- [ ] Proactive communication
- [ ] Suggests improvements
- [ ] Helps team members
- [ ] Learns from feedback

### Business Impact
- [ ] Delivers on time
- [ ] Meets user requirements
- [ ] Scalable solution
- [ ] Maintainable code

## 💡 PRO TIPS

### 1. Always Ask "Why?"
- Tại sao cần feature này?
- Tại sao design như vậy?
- Tại sao không dùng approach khác?

### 2. Think Like a User
- User sẽ dùng feature này như thế nào?
- Điều gì có thể confuse user?
- Edge cases nào user có thể gặp?

### 3. Consider the Team
- Code này có dễ hiểu cho team member khác không?
- Có cần documentation thêm không?
- Có impact gì đến other features không?

### 4. Plan for Failure
- Điều gì có thể sai?
- Network fail thì sao?
- Server error thì sao?
- User input invalid thì sao?

## 🔄 CONTINUOUS IMPROVEMENT

### After Each Task:
1. **Retrospective**: Gì làm tốt? Gì cần improve?
2. **Learning**: Skill nào cần học thêm?
3. **Process**: Quy trình nào có thể optimize?
4. **Feedback**: Xin feedback từ team lead/senior

### Monthly Review:
- Review code quality metrics
- Analyze bug reports
- Identify learning opportunities
- Set goals for next month

---

**Remember**: Professional developer không chỉ viết code, mà solve problems, communicate effectively, và continuously improve. Quality > Speed!