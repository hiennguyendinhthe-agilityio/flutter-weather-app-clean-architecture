# Navigation Widgets Summary

## 📚 Tổng quan về Navigation Widgets

Navigation Widgets là những widget chuyên dụng để tạo ra các navigation patterns trong Flutter apps. Chúng giúp users di chuyển giữa các screens, sections, và features một cách intuitive và consistent.

## 🎯 Tại sao Navigation quan trọng?

### **UX Impact:**
- 🧭 **Wayfinding**: Users biết họ đang ở đâu
- 🔄 **Flow**: Smooth transitions giữa screens
- 📱 **Accessibility**: Screen reader friendly
- 🎨 **Consistency**: Familiar patterns across app

### **Technical Benefits:**
- ✅ State management
- ✅ Deep linking support
- ✅ Back button handling
- ✅ Memory efficiency
- ✅ Platform consistency

## 🔧 Core Navigation Widgets

### **1. NavigationBar (Week 16) - Material 3**
```dart
NavigationBar(
  selectedIndex: _currentIndex,
  onDestinationSelected: (index) => setState(() => _currentIndex = index),
  destinations: const [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.search_outlined),
      selectedIcon: Icon(Icons.search),
      label: 'Search',
    ),
  ],
)
```

**Đặc điểm:**
- Material 3 design
- 3-5 destinations
- Bottom placement
- Modern styling

### **2. BottomNavigationBar (Legacy)**
```dart
BottomNavigationBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: 'Search',
    ),
  ],
)
```

**Đặc điểm:**
- Material 2 design
- Legacy support
- Limited styling
- Being replaced by NavigationBar

### **3. NavigationRail (Desktop/Tablet)**
```dart
NavigationRail(
  selectedIndex: _selectedIndex,
  onDestinationSelected: (index) => setState(() => _selectedIndex = index),
  labelType: NavigationRailLabelType.all,
  destinations: const [
    NavigationRailDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: Text('Home'),
    ),
  ],
)
```

**Đặc điểm:**
- Vertical navigation
- Desktop/tablet optimized
- Expandable labels
- Left/right placement

### **4. NavigationDrawer (Side Menu)**
```dart
NavigationDrawer(
  children: [
    NavigationDrawerDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: Text('Home'),
    ),
  ],
)
```

**Đặc điểm:**
- Side navigation
- Many destinations
- Hierarchical structure
- Collapsible

## 📊 Navigation Patterns Comparison

| Pattern | Use Case | Screen Size | Items | Hierarchy |
|---------|----------|-------------|-------|-----------|
| NavigationBar | Primary navigation | Mobile | 3-5 | Flat |
| NavigationRail | Primary navigation | Desktop/Tablet | 3-7 | Flat |
| NavigationDrawer | Secondary navigation | All | Many | Hierarchical |
| TabBar | Content switching | All | 2-6 | Flat |

## 🎨 Material 3 Features

### **Dynamic Color**
```dart
NavigationBar(
  backgroundColor: Theme.of(context).colorScheme.surface,
  indicatorColor: Theme.of(context).colorScheme.secondaryContainer,
  // Automatically adapts to system theme
)
```

### **Enhanced Accessibility**
- Screen reader support
- High contrast mode
- Large text support
- Keyboard navigation

### **Modern Visual Hierarchy**
- Subtle elevation
- Rounded indicators
- Better spacing
- Consistent typography

## 🔄 State Management Patterns

### **1. Simple Index-Based**
```dart
class SimpleNavigation extends StatefulWidget {
  @override
  _SimpleNavigationState createState() => _SimpleNavigationState();
}

class _SimpleNavigationState extends State<SimpleNavigation> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    ProfilePage(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: _destinations,
      ),
    );
  }
}
```

**Pros:**
- ✅ Simple implementation
- ✅ Fast navigation
- ✅ Good for small apps

**Cons:**
- ❌ State resets on navigation
- ❌ No deep linking
- ❌ Limited scalability

### **2. PageView with State Persistence**
```dart
class PersistentNavigation extends StatefulWidget {
  @override
  _PersistentNavigationState createState() => _PersistentNavigationState();
}

class _PersistentNavigationState extends State<PersistentNavigation> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        destinations: _destinations,
      ),
    );
  }
}
```

**Pros:**
- ✅ State preservation
- ✅ Smooth animations
- ✅ Better UX

**Cons:**
- ❌ Memory overhead
- ❌ Complex state management

### **3. Named Routes Integration**
```dart
class RoutedNavigation extends StatefulWidget {
  @override
  _RoutedNavigationState createState() => _RoutedNavigationState();
}

class _RoutedNavigationState extends State<RoutedNavigation> {
  int _currentIndex = 0;
  
  final List<String> _routes = ['/home', '/search', '/profile'];
  
  void _onDestinationSelected(int index) {
    setState(() => _currentIndex = index);
    Navigator.pushReplacementNamed(context, _routes[index]);
  }
  
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: _currentIndex,
      onDestinationSelected: _onDestinationSelected,
      destinations: _destinations,
    );
  }
}
```

**Pros:**
- ✅ Deep linking support
- ✅ URL-based navigation
- ✅ Web compatibility

**Cons:**
- ❌ Complex setup
- ❌ Route management overhead

## 📱 Responsive Navigation Patterns

### **Adaptive Navigation**
```dart
class AdaptiveNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile: NavigationBar
          return Scaffold(
            body: _currentPage,
            bottomNavigationBar: NavigationBar(
              destinations: _destinations,
            ),
          );
        } else if (constraints.maxWidth < 1200) {
          // Tablet: NavigationRail
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  destinations: _railDestinations,
                ),
                Expanded(child: _currentPage),
              ],
            ),
          );
        } else {
          // Desktop: NavigationDrawer
          return Scaffold(
            drawer: NavigationDrawer(
              children: _drawerDestinations,
            ),
            body: _currentPage,
          );
        }
      },
    );
  }
}
```

### **Breakpoint Guidelines**
- **Mobile (< 600px)**: NavigationBar
- **Tablet (600-1200px)**: NavigationRail hoặc adaptive
- **Desktop (> 1200px)**: NavigationDrawer hoặc NavigationRail

## 🎯 Advanced Features

### **Badges và Notifications**
```dart
NavigationDestination(
  icon: Badge(
    label: Text('3'),
    child: Icon(Icons.message_outlined),
  ),
  selectedIcon: Badge(
    label: Text('3'),
    child: Icon(Icons.message),
  ),
  label: 'Messages',
)
```

### **Custom Styling**
```dart
NavigationBar(
  backgroundColor: Colors.blue.shade50,
  indicatorColor: Colors.blue.shade200,
  elevation: 8,
  surfaceTintColor: Colors.blue,
  labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
  animationDuration: Duration(milliseconds: 300),
)
```

### **Dynamic Navigation Items**
```dart
class DynamicNavigation extends StatefulWidget {
  @override
  _DynamicNavigationState createState() => _DynamicNavigationState();
}

class _DynamicNavigationState extends State<DynamicNavigation> {
  List<NavigationDestination> _destinations = [];
  
  @override
  void initState() {
    super.initState();
    _loadNavigationItems();
  }
  
  void _loadNavigationItems() async {
    final userRole = await getUserRole();
    final items = await getNavigationItemsForRole(userRole);
    
    setState(() {
      _destinations = items.map((item) => NavigationDestination(
        icon: Icon(item.icon),
        label: item.label,
      )).toList();
    });
  }
}
```

## 🛡️ Best Practices

### **DO's:**
- ✅ **Limit destinations**: 3-5 items cho NavigationBar
- ✅ **Clear labels**: Concise, descriptive text
- ✅ **Consistent icons**: Use familiar iconography
- ✅ **Visual feedback**: Clear selected state
- ✅ **Accessibility**: Screen reader support

### **DON'Ts:**
- ❌ **Too many items**: Overcrowded navigation
- ❌ **Inconsistent behavior**: Different patterns in same app
- ❌ **Poor hierarchy**: Complex nested navigation
- ❌ **Missing states**: No selected/disabled states
- ❌ **Platform inconsistency**: Ignore platform conventions

### **UX Guidelines:**
- **Maintain context**: Users should know where they are
- **Provide feedback**: Visual/haptic feedback on selection
- **Consider accessibility**: Support screen readers, high contrast
- **Test on devices**: Different screen sizes and orientations

## 🔮 Advanced Patterns

### **Multi-Level Navigation**
```dart
class HierarchicalNavigation extends StatefulWidget {
  @override
  _HierarchicalNavigationState createState() => _HierarchicalNavigationState();
}

class _HierarchicalNavigationState extends State<HierarchicalNavigation> {
  int _primaryIndex = 0;
  int _secondaryIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Secondary navigation
          if (_hasSecondaryNav(_primaryIndex))
            Container(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _getSecondaryItems(_primaryIndex).length,
                itemBuilder: (context, index) {
                  return _buildSecondaryTab(index);
                },
              ),
            ),
          
          // Primary navigation
          NavigationBar(
            selectedIndex: _primaryIndex,
            onDestinationSelected: (index) {
              setState(() {
                _primaryIndex = index;
                _secondaryIndex = 0; // Reset secondary
              });
            },
            destinations: _primaryDestinations,
          ),
        ],
      ),
    );
  }
}
```

### **Context-Aware Navigation**
```dart
class ContextAwareNavigation extends StatefulWidget {
  @override
  _ContextAwareNavigationState createState() => _ContextAwareNavigationState();
}

class _ContextAwareNavigationState extends State<ContextAwareNavigation> {
  List<NavigationDestination> _getDestinationsForContext() {
    final user = getCurrentUser();
    final context = getCurrentContext();
    
    List<NavigationDestination> destinations = [
      NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
    ];
    
    if (user.isLoggedIn) {
      destinations.add(
        NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
      );
    }
    
    if (user.hasPermission('admin')) {
      destinations.add(
        NavigationDestination(icon: Icon(Icons.admin_panel_settings), label: 'Admin'),
      );
    }
    
    return destinations;
  }
}
```

## 📊 Performance Considerations

### **Memory Management**
- Use `PageView` cho state persistence
- Implement lazy loading cho heavy pages
- Dispose controllers properly
- Avoid memory leaks

### **Animation Performance**
- Use `AnimatedSwitcher` cho smooth transitions
- Optimize custom animations
- Consider `Hero` widgets cho cross-screen animations
- Profile animation performance

### **State Management**
- Choose appropriate state solution
- Avoid unnecessary rebuilds
- Use `const` constructors
- Implement proper lifecycle management

## 🎓 Learning Path

### **Beginner Level:**
1. Basic NavigationBar setup
2. Simple state management
3. Static navigation items
4. Basic styling

### **Intermediate Level:**
1. Responsive navigation patterns
2. State persistence
3. Custom styling
4. Badge integration

### **Advanced Level:**
1. Dynamic navigation items
2. Multi-level navigation
3. Context-aware navigation
4. Performance optimization

## 🚀 Real-World Examples

### **Social Media App**
- Home, Search, Post, Messages, Profile
- Badge notifications
- Context-aware items (admin panel)

### **E-commerce App**
- Browse, Search, Cart, Orders, Account
- Shopping cart badge
- Guest vs logged-in states

### **Productivity App**
- Dashboard, Tasks, Calendar, Reports, Settings
- Role-based navigation
- Responsive design

## 🔗 Integration với State Management

### **Provider Pattern**
```dart
class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;
  
  int get currentIndex => _currentIndex;
  
  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}

// Usage
Consumer<NavigationProvider>(
  builder: (context, nav, child) {
    return NavigationBar(
      selectedIndex: nav.currentIndex,
      onDestinationSelected: nav.setIndex,
      destinations: _destinations,
    );
  },
)
```

### **Riverpod Pattern**
```dart
final navigationProvider = StateNotifierProvider<NavigationNotifier, int>((ref) {
  return NavigationNotifier();
});

class NavigationNotifier extends StateNotifier<int> {
  NavigationNotifier() : super(0);
  
  void setIndex(int index) => state = index;
}
```

## 📱 Platform-Specific Considerations

### **iOS Cupertino**
```dart
CupertinoTabScaffold(
  tabBar: CupertinoTabBar(
    items: [
      BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.home),
        label: 'Home',
      ),
    ],
  ),
  tabBuilder: (context, index) => _pages[index],
)
```

### **Web Considerations**
- URL synchronization
- Browser back button
- Keyboard navigation
- SEO implications

## 🎯 Next Steps

Sau khi học xong Navigation Widgets, em nên:

1. **Practice responsive patterns** - Test trên different screen sizes
2. **Integrate với state management** - Provider, Riverpod, Bloc
3. **Learn deep linking** - URL-based navigation
4. **Explore advanced routing** - GoRouter, AutoRoute
5. **Study platform guidelines** - Material Design, Human Interface Guidelines

---

**Remember:** Good navigation is invisible - users shouldn't think about it, they should just use it naturally! 🧭