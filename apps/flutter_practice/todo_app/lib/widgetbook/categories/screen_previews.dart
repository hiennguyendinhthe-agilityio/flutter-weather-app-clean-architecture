import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

/// Category showcase các screen previews
class ScreenPreviewsCategory {
  static WidgetbookCategory create() {
    return WidgetbookCategory(
      name: '📱 Screen Previews',
      children: [
        // Main Screens
        WidgetbookFolder(
          name: '🏠 Main Screens',
          children: [
            WidgetbookComponent(
              name: 'Todo Main Screen',
              useCases: [
                WidgetbookUseCase(
                  name: 'Empty State',
                  builder: (context) => _TodoMainScreenPreview(
                    state: TodoScreenState.empty,
                  ),
                ),
                WidgetbookUseCase(
                  name: 'With Todos',
                  builder: (context) => _TodoMainScreenPreview(
                    state: TodoScreenState.withData,
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Loading State',
                  builder: (context) => _TodoMainScreenPreview(
                    state: TodoScreenState.loading,
                  ),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Theme Demo Screen',
              useCases: [
                WidgetbookUseCase(
                  name: 'Theme Showcase',
                  builder: (context) => _ThemeDemoScreenPreview(),
                ),
              ],
            ),
          ],
        ),
        
        // Advanced Screens
        WidgetbookFolder(
          name: '🚀 Advanced Screens',
          children: [
            WidgetbookComponent(
              name: 'Advanced Scroll View',
              useCases: [
                WidgetbookUseCase(
                  name: 'Scroll Behaviors',
                  builder: (context) => _AdvancedScrollViewPreview(),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Painter Demo',
              useCases: [
                WidgetbookUseCase(
                  name: 'Custom Painting',
                  builder: (context) => _PainterDemoPreview(),
                ),
              ],
            ),
          ],
        ),
        
        // Activity & Detail Screens
        WidgetbookFolder(
          name: '📋 Activity Screens',
          children: [
            WidgetbookComponent(
              name: 'Activity Screen',
              useCases: [
                WidgetbookUseCase(
                  name: 'Recent Activities',
                  builder: (context) => _ActivityScreenPreview(),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Photo Detail Screen',
              useCases: [
                WidgetbookUseCase(
                  name: 'Photo Viewer',
                  builder: (context) => _PhotoDetailScreenPreview(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// Enum for different todo screen states
enum TodoScreenState { empty, withData, loading }

// Mock screen previews
class _TodoMainScreenPreview extends StatelessWidget {
  final TodoScreenState state;
  
  const _TodoMainScreenPreview({required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => _showSnackBar(context, 'Theme toggle pressed'),
          ),
        ],
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSnackBar(context, 'Add todo pressed'),
        child: const Icon(Icons.add),
      ),
    );
  }
  
  Widget _buildBody(BuildContext context) {
    switch (state) {
      case TodoScreenState.empty:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.task_alt,
                size: 64,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                'No todos yet',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Tap the + button to add your first todo',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
        
      case TodoScreenState.withData:
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: 5,
          itemBuilder: (context, index) => _buildTodoItem(context, index),
        );
        
      case TodoScreenState.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
    }
  }
  
  Widget _buildTodoItem(BuildContext context, int index) {
    final isCompleted = index % 3 == 0;
    final todos = [
      'Complete Flutter project',
      'Review code with team',
      'Update documentation',
      'Fix reported bugs',
      'Prepare for demo',
    ];
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: Checkbox(
          value: isCompleted,
          onChanged: (value) => _showSnackBar(context, 'Todo ${isCompleted ? 'unchecked' : 'checked'}'),
        ),
        title: Text(
          todos[index],
          style: isCompleted 
            ? TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              )
            : null,
        ),
        subtitle: Text('Created ${index + 1} hours ago'),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => _showSnackBar(context, 'Delete todo pressed'),
        ),
      ),
    );
  }
}

class _ThemeDemoScreenPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Demo'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Material 3 Components',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            
            // Cards
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Card Component',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This is a sample card with Material 3 styling',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Buttons
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                ElevatedButton(
                  onPressed: () => _showSnackBar(context, 'Elevated pressed'),
                  child: const Text('Elevated'),
                ),
                FilledButton(
                  onPressed: () => _showSnackBar(context, 'Filled pressed'),
                  child: const Text('Filled'),
                ),
                OutlinedButton(
                  onPressed: () => _showSnackBar(context, 'Outlined pressed'),
                  child: const Text('Outlined'),
                ),
                TextButton(
                  onPressed: () => _showSnackBar(context, 'Text pressed'),
                  child: const Text('Text'),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Chips
            Wrap(
              spacing: 8.0,
              children: [
                Chip(label: const Text('Chip')),
                ActionChip(
                  label: const Text('Action'),
                  onPressed: () => _showSnackBar(context, 'Action chip pressed'),
                ),
                FilterChip(
                  label: const Text('Filter'),
                  selected: true,
                  onSelected: (value) => _showSnackBar(context, 'Filter chip toggled'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AdvancedScrollViewPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Advanced Scroll'),
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
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text('Item ${index + 1}'),
                subtitle: Text('Subtitle for item ${index + 1}'),
                onTap: () => _showSnackBar(context, 'Item ${index + 1} tapped'),
              ),
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _PainterDemoPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Painter Demo'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.outline),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomPaint(
                painter: _SamplePainter(Theme.of(context).colorScheme.primary),
                size: const Size(200, 200),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Custom Painter Example',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'This shows custom drawing capabilities',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityScreenPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent Activity'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 10,
        itemBuilder: (context, index) {
          final activities = [
            'Created new todo',
            'Completed task',
            'Updated profile',
            'Shared photo',
            'Added comment',
          ];
          
          return Card(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  _getActivityIcon(index),
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              title: Text(activities[index % activities.length]),
              subtitle: Text('${index + 1} minutes ago'),
              onTap: () => _showSnackBar(context, 'Activity ${index + 1} tapped'),
            ),
          );
        },
      ),
    );
  }
  
  IconData _getActivityIcon(int index) {
    final icons = [
      Icons.add_task,
      Icons.check_circle,
      Icons.person,
      Icons.photo,
      Icons.comment,
    ];
    return icons[index % icons.length];
  }
}

class _PhotoDetailScreenPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _showSnackBar(context, 'Share pressed'),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () => _showSnackBar(context, 'Like pressed'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: NetworkImage('https://picsum.photos/300'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Sample Photo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Photo description goes here',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for demo
class _SamplePainter extends CustomPainter {
  final Color color;
  
  _SamplePainter(this.color);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    // Draw a simple pattern
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 4,
      paint,
    );
    
    paint.color = color.withValues(alpha: 0.5);
    canvas.drawRect(
      Rect.fromLTWH(size.width / 4, size.height / 4, size.width / 2, size.height / 2),
      paint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Helper function
void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    ),
  );
}