# Async Widgets Summary

## 📚 Tổng quan về Async Widgets

Async Widgets là những widget đặc biệt được thiết kế để xử lý các operations bất đồng bộ (asynchronous) trong Flutter. Chúng giúp quản lý loading states, error handling, và data presentation một cách elegant và user-friendly.

## 🎯 Tại sao cần Async Widgets?

### **Vấn đề với Sync Operations:**
- Block UI thread → App lag/freeze
- Không thể handle network calls
- Poor user experience
- No loading indicators

### **Giải pháp với Async Widgets:**
- ✅ Non-blocking operations
- ✅ Automatic state management
- ✅ Built-in error handling
- ✅ Loading state indicators
- ✅ Better user experience

## 🔧 Core Async Widgets

### **1. FutureBuilder (Week 15)**
```dart
FutureBuilder<String>(
  future: fetchData(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    return Text('Data: ${snapshot.data}');
  },
)
```

**Đặc điểm:**
- Handle Future objects
- ConnectionState management
- One-time async operations
- Perfect cho API calls

### **2. StreamBuilder (Coming Soon)**
```dart
StreamBuilder<int>(
  stream: counterStream,
  builder: (context, snapshot) {
    return Text('Count: ${snapshot.data ?? 0}');
  },
)
```

**Đặc điểm:**
- Handle Stream objects
- Continuous data updates
- Real-time applications
- Perfect cho live data

## 📊 ConnectionState trong Async Widgets

| State | Description | Use Case |
|-------|-------------|----------|
| `none` | Chưa có Future/Stream | Initial state |
| `waiting` | Đang chờ data | Show loading |
| `active` | Stream đang active | Receiving data |
| `done` | Future completed | Show result |

## 🎨 Common Patterns

### **1. Loading Pattern**
```dart
if (snapshot.connectionState == ConnectionState.waiting) {
  return Column(
    children: [
      CircularProgressIndicator(),
      SizedBox(height: 16),
      Text('Loading...'),
    ],
  );
}
```

### **2. Error Pattern**
```dart
if (snapshot.hasError) {
  return Column(
    children: [
      Icon(Icons.error, color: Colors.red),
      Text('Error: ${snapshot.error}'),
      ElevatedButton(
        onPressed: retry,
        child: Text('Retry'),
      ),
    ],
  );
}
```

### **3. Success Pattern**
```dart
if (snapshot.hasData) {
  return ListView.builder(
    itemCount: snapshot.data!.length,
    itemBuilder: (context, index) {
      return ListTile(
        title: Text(snapshot.data![index].title),
      );
    },
  );
}
```

## 🚀 Performance Best Practices

### **DO's:**
- ✅ Cache Future trong initState()
- ✅ Use AnimatedSwitcher cho smooth transitions
- ✅ Implement proper error handling
- ✅ Add timeout cho network calls
- ✅ Use const constructors khi có thể

### **DON'Ts:**
- ❌ Tạo Future trong build method
- ❌ Ignore error states
- ❌ Forget về memory leaks
- ❌ Block UI thread
- ❌ Skip loading indicators

## 🔄 Dart Async Fundamentals

### **Future<T>**
```dart
Future<String> fetchData() async {
  await Future.delayed(Duration(seconds: 2));
  return "Data loaded!";
}
```

### **async/await**
```dart
void loadData() async {
  try {
    final data = await fetchData();
    print('Success: $data');
  } catch (error) {
    print('Error: $error');
  }
}
```

### **Stream<T>**
```dart
Stream<int> countStream() async* {
  for (int i = 0; i < 10; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}
```

## 🛡️ Error Handling Strategies

### **1. Try-Catch Pattern**
```dart
Future<String> safeApiCall() async {
  try {
    final response = await http.get(url);
    return response.body;
  } catch (e) {
    throw Exception('Network error: $e');
  }
}
```

### **2. Retry Mechanism**
```dart
Future<T> retryOperation<T>(
  Future<T> Function() operation,
  {int maxRetries = 3}
) async {
  for (int i = 0; i < maxRetries; i++) {
    try {
      return await operation();
    } catch (e) {
      if (i == maxRetries - 1) rethrow;
      await Future.delayed(Duration(seconds: i + 1));
    }
  }
  throw Exception('Max retries exceeded');
}
```

### **3. Timeout Handling**
```dart
Future<String> fetchWithTimeout() async {
  return await fetchData().timeout(
    Duration(seconds: 10),
    onTimeout: () => throw TimeoutException('Request timed out'),
  );
}
```

## 🎯 Real-World Use Cases

### **API Integration**
- REST API calls
- GraphQL queries
- Authentication flows
- Data synchronization

### **File Operations**
- File reading/writing
- Image processing
- Document parsing
- Cache management

### **Database Operations**
- SQLite queries
- Firebase operations
- Local storage
- Data migration

### **Real-time Features**
- Chat applications
- Live notifications
- Stock price updates
- IoT sensor data

## 📱 UI/UX Considerations

### **Loading States**
- Show progress indicators
- Provide estimated time
- Allow cancellation
- Maintain context

### **Error States**
- Clear error messages
- Retry mechanisms
- Fallback content
- User guidance

### **Success States**
- Smooth transitions
- Data validation
- Update notifications
- State persistence

## 🔮 Advanced Techniques

### **Future Caching**
```dart
class DataService {
  static Future<List<User>>? _usersFuture;
  
  static Future<List<User>> getUsers() {
    _usersFuture ??= _fetchUsers();
    return _usersFuture!;
  }
}
```

### **Debouncing**
```dart
Timer? _debounceTimer;

void onSearchChanged(String query) {
  _debounceTimer?.cancel();
  _debounceTimer = Timer(Duration(milliseconds: 500), () {
    performSearch(query);
  });
}
```

### **Pagination**
```dart
class PaginatedList extends StatefulWidget {
  @override
  _PaginatedListState createState() => _PaginatedListState();
}

class _PaginatedListState extends State<PaginatedList> {
  final List<Item> _items = [];
  bool _isLoading = false;
  int _currentPage = 1;
  
  Future<void> _loadMore() async {
    if (_isLoading) return;
    
    setState(() => _isLoading = true);
    
    try {
      final newItems = await fetchItems(page: _currentPage);
      setState(() {
        _items.addAll(newItems);
        _currentPage++;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
```

## 📚 Learning Path

### **Beginner Level:**
1. Hiểu Future và async/await
2. Basic FutureBuilder usage
3. Simple error handling
4. Loading states

### **Intermediate Level:**
1. StreamBuilder patterns
2. Complex error handling
3. Performance optimization
4. State management integration

### **Advanced Level:**
1. Custom async widgets
2. Advanced error recovery
3. Memory management
4. Testing async code

## 🎓 Next Steps

Sau khi học xong Async Widgets, em nên:

1. **Practice với real APIs** - JSONPlaceholder, Firebase
2. **Build async-heavy apps** - Chat, News, Weather
3. **Learn state management** - Provider, Riverpod, Bloc
4. **Explore advanced patterns** - Repository pattern, Clean Architecture
5. **Master testing** - Unit tests, Widget tests, Integration tests

---

**Remember:** Async programming là foundation của modern mobile apps. Master nó sẽ giúp em build better, more responsive applications! 🚀