import 'package:flutter/material.dart';

import '../../components/code_examples_manager.dart';
import '../../components/floating_code_button.dart';

/// Week 16: NavigationBar Widget - Comprehensive Learning Module
///
/// Learn about the NavigationBar widget in Flutter:
/// - Material 3 navigation patterns
/// - NavigationDestination and routing
/// - State management for navigation
/// - Custom styling and theming
/// - Responsive navigation patterns
class Week16NavigationBar extends StatefulWidget {
  const Week16NavigationBar({super.key});

  @override
  State<Week16NavigationBar> createState() => _Week16NavigationBarState();
}

class _Week16NavigationBarState extends State<Week16NavigationBar> {
  int _currentIndex = 0;
  bool _showAdvanced = false;
  String _selectedStyle = 'default';

  // Demo pages
  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const FavoritesPage(),
    const ProfilePage(),
  ];

  // Navigation destinations
  final List<NavigationDestination> _destinations = [
    const NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    const NavigationDestination(
      icon: Icon(Icons.search_outlined),
      selectedIcon: Icon(Icons.search),
      label: 'Search',
    ),
    const NavigationDestination(
      icon: Icon(Icons.favorite_outline),
      selectedIcon: Icon(Icons.favorite),
      label: 'Favorites',
    ),
    const NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Week 16: NavigationBar Widget'),
        backgroundColor: Colors.blue,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_showAdvanced ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _showAdvanced = !_showAdvanced),
            tooltip: _showAdvanced ? 'Hide Advanced' : 'Show Advanced',
          ),
        ],
      ),
      floatingActionButton: FloatingCodeButton(
        examples: _getNavigationBarExamples(),
        lessonTitle: 'NavigationBar Widget - Week 16',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTheorySection(),
            const SizedBox(height: 20),
            _buildStyleSelector(),
            const SizedBox(height: 20),
            _buildInteractiveDemo(),
            const SizedBox(height: 20),
            _buildNavigationPatterns(),
            const SizedBox(height: 20),
            if (_showAdvanced) ...[
              _buildAdvancedSection(),
              const SizedBox(height: 20),
            ],
            _buildResponsiveNavigation(),
            const SizedBox(height: 20),
            _buildBestPractices(),
            const SizedBox(height: 20),
            _buildExercises(),
          ],
        ),
      ),
    );
  }

  Widget _buildTheorySection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.navigation, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'NavigationBar - Material 3 Navigation',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Text(
                '🎯 The NavigationBar is the official navigation widget for Material 3, '
                'replacing the BottomNavigationBar. It provides a modern navigation pattern '
                'with better accessibility and theming support.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ),

            const SizedBox(height: 20),

            _buildNavigationTypesGrid(),

            const SizedBox(height: 20),

            _buildMaterial3Features(),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationTypesGrid() {
    final navTypes = [
      {
        'icon': Icons.navigation,
        'title': 'NavigationBar',
        'desc': 'Bottom navigation (3-5 items)',
        'color': Colors.blue,
      },
      {
        'icon': Icons.menu,
        'title': 'NavigationDrawer',
        'desc': 'Side navigation (many items)',
        'color': Colors.green,
      },
      {
        'icon': Icons.tab,
        'title': 'TabBar',
        'desc': 'Top navigation (swipeable)',
        'color': Colors.orange,
      },
      {
        'icon': Icons.train,
        'title': 'NavigationRail',
        'desc': 'Vertical navigation (desktop)',
        'color': Colors.purple,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🧭 Navigation Patterns in Flutter:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: navTypes.length,
          itemBuilder: (context, index) {
            final type = navTypes[index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (type['color'] as Color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: (type['color'] as Color).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    type['icon'] as IconData,
                    color: type['color'] as Color,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          type['title'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: type['color'] as Color,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          type['desc'] as String,
                          style: const TextStyle(fontSize: 11),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMaterial3Features() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Text(
                'Material 3 Features',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('✨ Dynamic Color theming support'),
          const SizedBox(height: 6),
          const Text('🎨 Better visual hierarchy with elevation'),
          const SizedBox(height: 6),
          const Text('♿ Enhanced accessibility features'),
          const SizedBox(height: 6),
          const Text('📱 Responsive design patterns'),
          const SizedBox(height: 6),
          const Text('🔄 Smooth animations and transitions'),
        ],
      ),
    );
  }

  Widget _buildStyleSelector() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.palette, color: Colors.purple),
                const SizedBox(width: 8),
                Text(
                  'Navigation Styles',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _buildStyleChip(
                  'default',
                  'Default',
                  Icons.navigation,
                  Colors.blue,
                ),
                _buildStyleChip(
                  'elevated',
                  'Elevated',
                  Icons.layers,
                  Colors.green,
                ),
                _buildStyleChip(
                  'custom',
                  'Custom Colors',
                  Icons.color_lens,
                  Colors.purple,
                ),
                _buildStyleChip(
                  'badges',
                  'With Badges',
                  Icons.notifications,
                  Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyleChip(
    String type,
    String label,
    IconData icon,
    Color color,
  ) {
    final isSelected = _selectedStyle == type;
    return FilterChip(
      selected: isSelected,
      avatar: Icon(icon, size: 18, color: isSelected ? color : Colors.grey),
      label: Text(label),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedStyle = type;
          });
        }
      },
      selectedColor: color.withValues(alpha: 0.2),
      backgroundColor: Colors.white,
      side: BorderSide(
        color: isSelected ? color : Colors.grey.shade300,
        width: isSelected ? 2 : 1,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildInteractiveDemo() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.play_arrow, color: Colors.indigo),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Live NavigationBar Demo',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Demo container
            Container(
              height: 400,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Scaffold(
                  body: _pages[_currentIndex],
                  bottomNavigationBar: _buildStyledNavigationBar(),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Current state info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.indigo.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.indigo.shade700, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Current: ${_destinations[_currentIndex].label} (Index: $_currentIndex)',
                    style: TextStyle(
                      color: Colors.indigo.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledNavigationBar() {
    switch (_selectedStyle) {
      case 'elevated':
        return NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) =>
              setState(() => _currentIndex = index),
          destinations: _destinations,
          elevation: 8,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.blue,
        );

      case 'custom':
        return NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) =>
              setState(() => _currentIndex = index),
          destinations: _destinations,
          backgroundColor: Colors.purple.shade50,
          indicatorColor: Colors.purple.shade200,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        );

      case 'badges':
        return NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) =>
              setState(() => _currentIndex = index),
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Badge(
                label: const Text('3'),
                child: const Icon(Icons.search_outlined),
              ),
              selectedIcon: Badge(
                label: const Text('3'),
                child: const Icon(Icons.search),
              ),
              label: 'Search',
            ),
            NavigationDestination(
              icon: Badge(
                smallSize: 8,
                child: const Icon(Icons.favorite_outline),
              ),
              selectedIcon: Badge(
                smallSize: 8,
                child: const Icon(Icons.favorite),
              ),
              label: 'Favorites',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        );

      default:
        return NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) =>
              setState(() => _currentIndex = index),
          destinations: _destinations,
        );
    }
  }

  Widget _buildNavigationPatterns() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.route, color: Colors.orange),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Navigation Patterns & State Management',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildPatternExample(
              '🏠 Simple State Management',
              'Basic index-based navigation',
              _buildSimplePatternDemo(),
            ),

            const SizedBox(height: 16),

            _buildPatternExample(
              '🗺️ Named Routes Integration',
              'Navigation with Flutter routing',
              _buildRoutingPatternDemo(),
            ),

            const SizedBox(height: 16),

            _buildPatternExample(
              '📱 Persistent State',
              'Maintain state across navigation',
              _buildPersistentStateDemo(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatternExample(String title, String description, Widget demo) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const SizedBox(height: 12),
          demo,
        ],
      ),
    );
  }

  Widget _buildSimplePatternDemo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✅ Pros:',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
          ),
          Text('• Simple implementation'),
          Text('• Fast navigation'),
          Text('• Good for small apps'),
          SizedBox(height: 8),
          Text(
            '⚠️ Cons:',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
          ),
          Text('• No deep linking'),
          Text('• State resets on navigation'),
          Text('• Limited scalability'),
        ],
      ),
    );
  }

  Widget _buildRoutingPatternDemo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✅ Pros:',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
          ),
          Text('• Deep linking support'),
          Text('• URL-based navigation'),
          Text('• Better for web apps'),
          SizedBox(height: 8),
          Text(
            '⚠️ Cons:',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
          ),
          Text('• More complex setup'),
          Text('• Requires route management'),
          Text('• Learning curve'),
        ],
      ),
    );
  }

  Widget _buildPersistentStateDemo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✅ Pros:',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
          ),
          Text('• State preservation'),
          Text('• Better UX'),
          Text('• Efficient memory usage'),
          SizedBox(height: 8),
          Text(
            '⚠️ Cons:',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
          ),
          Text('• Memory overhead'),
          Text('• Complex state management'),
          Text('• Potential memory leaks'),
        ],
      ),
    );
  }

  Widget _buildAdvancedSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.science, color: Colors.purple),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Advanced NavigationBar Techniques',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildAdvancedTopic(
              'Custom NavigationDestination',
              'Create custom destinations with animations',
              '''
class AnimatedNavigationDestination extends NavigationDestination {
  const AnimatedNavigationDestination({
    required Widget icon,
    required Widget selectedIcon,
    required String label,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : super(icon: icon, selectedIcon: selectedIcon, label: label);
  
  final Duration animationDuration;
  
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: animationDuration,
      child: super.build(context),
    );
  }
}
''',
            ),

            const SizedBox(height: 16),

            _buildAdvancedTopic(
              'Dynamic Navigation Items',
              'Change navigation items at runtime',
              '''
class DynamicNavigationBar extends StatefulWidget {
  @override
  _DynamicNavigationBarState createState() => _DynamicNavigationBarState();
}

class _DynamicNavigationBarState extends State<DynamicNavigationBar> {
  List<NavigationDestination> _destinations = [];
  
  @override
  void initState() {
    super.initState();
    _loadNavigationItems();
  }
  
  void _loadNavigationItems() async {
    // Load from API, user preferences, etc.
    final items = await fetchUserNavigationPreferences();
    setState(() {
      _destinations = items.map((item) => NavigationDestination(
        icon: Icon(item.icon),
        label: item.label,
      )).toList();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: _destinations,
      onDestinationSelected: _handleNavigation,
    );
  }
}
''',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedTopic(String title, String description, String code) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              code,
              style: const TextStyle(
                color: Colors.green,
                fontFamily: 'monospace',
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveNavigation() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.devices, color: Colors.teal),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Responsive Navigation Patterns',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📱 Mobile (< 600px): NavigationBar',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('• Bottom navigation với 3-5 items'),
                  const Text('• Touch-friendly targets'),
                  const Text('• Compact layout'),

                  const SizedBox(height: 16),

                  const Text(
                    '💻 Desktop (> 1200px): NavigationRail',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('• Vertical navigation rail'),
                  const Text('• More space for labels'),
                  const Text('• Mouse-optimized interactions'),

                  const SizedBox(height: 16),

                  const Text(
                    '📟 Tablet (600-1200px): Adaptive',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('• NavigationBar in portrait'),
                  const Text('• NavigationRail in landscape'),
                  const Text('• Context-aware switching'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBestPractices() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.tips_and_updates,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Best Practices & Guidelines',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildTipItem(
              Icons.check_circle,
              'DO: Limit to 3-5 destinations',
              'Too many items make navigation difficult to use',
              Colors.green,
            ),

            _buildTipItem(
              Icons.check_circle,
              'DO: Use clear, concise labels',
              'Short, easy-to-understand labels for users',
              Colors.green,
            ),

            _buildTipItem(
              Icons.warning,
              'AVOID: Changing destinations dynamically',
              'The navigation structure should be consistent',
              Colors.orange,
            ),

            _buildTipItem(
              Icons.error,
              'DON\'T: Use for complex hierarchies',
              'NavigationBar is for top-level navigation only',
              Colors.red,
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'UX Guidelines',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Maintain navigation state across app lifecycle',
                  ),
                  const Text('• Provide visual feedback for selected state'),
                  const Text('• Consider accessibility (screen readers, etc.)'),
                  const Text('• Test on different screen sizes'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExercises() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.assignment, color: Colors.red),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Practice Exercises',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildExerciseItem(
              '📱 Social Media App',
              'Beginner',
              Colors.green,
              [
                'NavigationBar with Home, Search, Post, Profile',
                'Badge notifications for messages',
                'State persistence across navigation',
                'Custom icons and styling',
              ],
            ),

            const SizedBox(height: 16),

            _buildExerciseItem(
              '🛒 E-commerce App',
              'Intermediate',
              Colors.orange,
              [
                'Adaptive navigation (mobile/tablet/desktop)',
                'Shopping cart badge with item count',
                'Deep linking integration',
                'User role-based navigation items',
              ],
            ),

            const SizedBox(height: 16),

            _buildExerciseItem(
              '🏢 Enterprise Dashboard',
              'Advanced',
              Colors.red,
              [
                'Dynamic navigation based on permissions',
                'Multi-level navigation hierarchy',
                'Custom NavigationDestination widgets',
                'Analytics tracking for navigation usage',
              ],
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.blue.shade100],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.school, color: Colors.blue),
                      const SizedBox(width: 8),
                      const Text(
                        'You have finished learning the NavigationBar Widget!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'You have mastered: Material 3 navigation, State management, '
                    'Responsive patterns, Custom styling, and UX best practices!',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(Icons.celebration, color: Colors.white),
                              SizedBox(width: 8),
                              Text('🎉 Navigation mastered!'),
                            ],
                          ),
                          backgroundColor: Colors.blue,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Complete Lesson'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseItem(
    String title,
    String difficulty,
    Color color,
    List<String> tasks,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: color,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  difficulty,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...tasks.map(
            (task) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ',
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(task, style: const TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<CodeExample> _getNavigationBarExamples() {
    return [
      const CodeExample(
        title: 'Basic NavigationBar Setup',
        code: '''
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
          setState(() {
            _currentIndex = index;
          });
        },
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
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}''',
      ),

      const CodeExample(
        title: 'NavigationBar với Badges',
        code: '''
NavigationBar(
  selectedIndex: _currentIndex,
  onDestinationSelected: (index) => setState(() => _currentIndex = index),
  destinations: [
    const NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Badge(
        label: Text('5'),
        child: Icon(Icons.message_outlined),
      ),
      selectedIcon: Badge(
        label: Text('5'),
        child: Icon(Icons.message),
      ),
      label: 'Messages',
    ),
    NavigationDestination(
      icon: Badge(
        smallSize: 8,
        child: Icon(Icons.notifications_outlined),
      ),
      selectedIcon: Badge(
        smallSize: 8,
        child: Icon(Icons.notifications),
      ),
      label: 'Notifications',
    ),
  ],
)''',
      ),

      const CodeExample(
        title: 'Custom Styled NavigationBar',
        code: '''
NavigationBar(
  selectedIndex: _currentIndex,
  onDestinationSelected: (index) => setState(() => _currentIndex = index),
  destinations: _destinations,
  
  // Styling options
  backgroundColor: Colors.blue.shade50,
  indicatorColor: Colors.blue.shade200,
  elevation: 8,
  surfaceTintColor: Colors.blue,
  
  // Label behavior
  labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
  
  // Animation duration
  animationDuration: Duration(milliseconds: 300),
)''',
      ),

      const CodeExample(
        title: 'Responsive Navigation Pattern',
        code: '''
class ResponsiveNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<NavigationDestination> destinations;
  
  const ResponsiveNavigation({
    Key? key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Mobile: NavigationBar
        if (constraints.maxWidth < 600) {
          return NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            destinations: destinations,
          );
        }
        
        // Desktop: NavigationRail
        return NavigationRail(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          labelType: NavigationRailLabelType.all,
          destinations: destinations.map((dest) => 
            NavigationRailDestination(
              icon: dest.icon,
              selectedIcon: dest.selectedIcon,
              label: Text(dest.label),
            ),
          ).toList(),
        );
      },
    );
  }
}''',
      ),

      const CodeExample(
        title: 'NavigationBar với State Persistence',
        code: '''
class PersistentNavigationBar extends StatefulWidget {
  @override
  _PersistentNavigationBarState createState() => _PersistentNavigationBarState();
}

class _PersistentNavigationBarState extends State<PersistentNavigationBar> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  
  // Keep pages alive to preserve state
  final List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    FavoritesPage(),
    ProfilePage(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
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
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}''',
      ),

      const CodeExample(
        title: 'NavigationBar với Named Routes',
        code: '''
class RoutedNavigationBar extends StatefulWidget {
  @override
  _RoutedNavigationBarState createState() => _RoutedNavigationBarState();
}

class _RoutedNavigationBarState extends State<RoutedNavigationBar> {
  int _currentIndex = 0;
  
  final List<String> _routes = [
    '/home',
    '/search',
    '/favorites',
    '/profile',
  ];
  
  void _onDestinationSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    // Navigate using named routes
    Navigator.pushReplacementNamed(context, _routes[index]);
  }
  
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: _currentIndex,
      onDestinationSelected: _onDestinationSelected,
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
        NavigationDestination(
          icon: Icon(Icons.favorite_outline),
          selectedIcon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}

// Route configuration
final routes = {
  '/home': (context) => HomePage(),
  '/search': (context) => SearchPage(),
  '/favorites': (context) => FavoritesPage(),
  '/profile': (context) => ProfilePage(),
};''',
      ),
    ];
  }
}

// Demo pages
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home, size: 64, color: Colors.blue),
          SizedBox(height: 16),
          Text(
            'Home Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Welcome to the home screen!'),
        ],
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: Colors.green),
          SizedBox(height: 16),
          Text(
            'Search Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Find what you\'re looking for!'),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text(
            'Favorites Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Your favorite items are here!'),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 64, color: Colors.purple),
          SizedBox(height: 16),
          Text(
            'Profile Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Manage your profile settings!'),
        ],
      ),
    );
  }
}
