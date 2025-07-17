import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../widgets/profile_header_widget.dart';
import '../../widgets/photo_grid_widget.dart';
import '../../services/navigation_service.dart';

/// Category chứa các UI components phức tạp hơn
class UIComponentsCategory {
  static WidgetbookCategory create() {
    return WidgetbookCategory(
      name: '👤 User Interface Components',
      children: [
        // Profile Components
        WidgetbookFolder(
          name: '👤 Profile Components',
          children: [
            WidgetbookComponent(
              name: 'Profile Header',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default Profile Header',
                  builder: (context) => const Scaffold(
                    body: ProfileHeaderWidget(),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Profile in Scrollable View',
                  builder: (context) => Scaffold(
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          const ProfileHeaderWidget(),
                          Container(
                            height: 800,
                            color: Theme.of(context).colorScheme.surfaceContainer.withValues(alpha: 0.3),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.swipe_vertical,
                                    size: 48,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Scroll to see profile header behavior',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Profile header stays at the top',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Profile with Custom Background',
                  builder: (context) => Scaffold(
                    body: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Theme.of(context).colorScheme.primaryContainer,
                            Theme.of(context).colorScheme.surface,
                          ],
                        ),
                      ),
                      child: const ProfileHeaderWidget(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        
        // Photo Components
        WidgetbookFolder(
          name: '📸 Photo Components',
          children: [
            WidgetbookComponent(
              name: 'Photo Grid',
              useCases: [
                WidgetbookUseCase(
                  name: 'Sample Photo Grid',
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Photo Grid Demo'),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    body: CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.all(16.0),
                          sliver: PhotoGridWidget(
                            imageUrls: _getSampleImageUrls(),
                            navigationService: _MockNavigationService(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Photo Grid with Header',
                  builder: (context) => Scaffold(
                    body: CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          expandedHeight: 200,
                          pinned: true,
                          flexibleSpace: FlexibleSpaceBar(
                            title: const Text('My Photos'),
                            background: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Theme.of(context).colorScheme.primary,
                                    Theme.of(context).colorScheme.primaryContainer,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.all(16.0),
                          sliver: PhotoGridWidget(
                            imageUrls: _getSampleImageUrls(),
                            navigationService: _MockNavigationService(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Large Photo Collection',
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Large Collection'),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    body: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Photo Gallery',
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${_getLargeImageCollection().length} photos',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          sliver: PhotoGridWidget(
                            imageUrls: _getLargeImageCollection(),
                            navigationService: _MockNavigationService(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        
        // Interactive Components
        WidgetbookFolder(
          name: '🎮 Interactive Components',
          children: [
            WidgetbookComponent(
              name: 'Action Buttons',
              useCases: [
                WidgetbookUseCase(
                  name: 'Button Variations',
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Button Showcase'),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Elevated Button
                          ElevatedButton(
                            onPressed: () => _showSnackBar(context, 'Elevated Button Pressed'),
                            child: const Text('Elevated Button'),
                          ),
                          const SizedBox(height: 12),
                          
                          // Filled Button
                          FilledButton(
                            onPressed: () => _showSnackBar(context, 'Filled Button Pressed'),
                            child: const Text('Filled Button'),
                          ),
                          const SizedBox(height: 12),
                          
                          // Outlined Button
                          OutlinedButton(
                            onPressed: () => _showSnackBar(context, 'Outlined Button Pressed'),
                            child: const Text('Outlined Button'),
                          ),
                          const SizedBox(height: 12),
                          
                          // Text Button
                          TextButton(
                            onPressed: () => _showSnackBar(context, 'Text Button Pressed'),
                            child: const Text('Text Button'),
                          ),
                          const SizedBox(height: 24),
                          
                          // Icon Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () => _showSnackBar(context, 'Like pressed'),
                                icon: const Icon(Icons.favorite_border),
                              ),
                              IconButton(
                                onPressed: () => _showSnackBar(context, 'Share pressed'),
                                icon: const Icon(Icons.share),
                              ),
                              IconButton(
                                onPressed: () => _showSnackBar(context, 'More pressed'),
                                icon: const Icon(Icons.more_vert),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
  
  // Helper methods
  static List<String> _getSampleImageUrls() {
    return List.generate(9, (index) => 'https://picsum.photos/seed/photo_$index/300');
  }
  
  static List<String> _getLargeImageCollection() {
    return List.generate(24, (index) => 'https://picsum.photos/seed/gallery_$index/300');
  }
  
  static void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// Mock Navigation Service for demo purposes
class _MockNavigationService implements NavigationService {
  @override
  void navigateToPhotoDetail(
    BuildContext context, {
    required List<String> imageUrls,
    required int initialIndex,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Would navigate to photo ${initialIndex + 1}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  @override
  void pop(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
  
  @override
  bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }
}