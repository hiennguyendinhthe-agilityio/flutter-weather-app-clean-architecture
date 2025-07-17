/// Mock data utilities for Widgetbook demos
class MockData {
  // Sample image URLs for photo components
  static List<String> get sampleImages => List.generate(
    12, 
    (index) => 'https://picsum.photos/seed/widgetbook_$index/300'
  );
  
  static List<String> get largeImageCollection => List.generate(
    30, 
    (index) => 'https://picsum.photos/seed/gallery_$index/400'
  );
  
  // Sample todo items
  static List<TodoItem> get sampleTodos => [
    TodoItem(
      id: '1',
      title: 'Complete Flutter Widgetbook setup',
      description: 'Set up comprehensive component showcase',
      isCompleted: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    TodoItem(
      id: '2', 
      title: 'Review UI components with design team',
      description: 'Go through all components in Widgetbook',
      isCompleted: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    TodoItem(
      id: '3',
      title: 'Update documentation',
      description: 'Add comprehensive docs for all widgets',
      isCompleted: false,
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    TodoItem(
      id: '4',
      title: 'Test responsive design',
      description: 'Check all components on different screen sizes',
      isCompleted: false,
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    TodoItem(
      id: '5',
      title: 'Prepare demo presentation',
      description: 'Create slides for Widgetbook showcase',
      isCompleted: false,
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];
  
  // Sample user profiles
  static List<UserProfile> get sampleProfiles => [
    UserProfile(
      name: 'Hien Nguyen',
      title: 'Flutter Developer',
      description: '12+ Years of Experience',
      avatarUrl: 'https://picsum.photos/seed/profile_hien/200',
    ),
    UserProfile(
      name: 'John Doe',
      title: 'UI/UX Designer', 
      description: 'Design System Specialist',
      avatarUrl: 'https://picsum.photos/seed/profile_john/200',
    ),
    UserProfile(
      name: 'Jane Smith',
      title: 'Product Manager',
      description: 'Mobile App Strategy',
      avatarUrl: 'https://picsum.photos/seed/profile_jane/200',
    ),
  ];
  
  // Sample activity items
  static List<ActivityItem> get sampleActivities => [
    ActivityItem(
      type: ActivityType.todoCreated,
      title: 'Created new todo',
      description: 'Added "Complete Flutter project" to your list',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    ActivityItem(
      type: ActivityType.todoCompleted,
      title: 'Completed task',
      description: 'Finished "Review code with team"',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    ActivityItem(
      type: ActivityType.profileUpdated,
      title: 'Updated profile',
      description: 'Changed profile picture and bio',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    ActivityItem(
      type: ActivityType.photoShared,
      title: 'Shared photo',
      description: 'Added new photo to gallery',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    ActivityItem(
      type: ActivityType.commentAdded,
      title: 'Added comment',
      description: 'Commented on team discussion',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
  ];
}

// Data models for mock data
class TodoItem {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  
  TodoItem({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
  });
}

class UserProfile {
  final String name;
  final String title;
  final String description;
  final String avatarUrl;
  
  UserProfile({
    required this.name,
    required this.title,
    required this.description,
    required this.avatarUrl,
  });
}

class ActivityItem {
  final ActivityType type;
  final String title;
  final String description;
  final DateTime timestamp;
  
  ActivityItem({
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
  });
}

enum ActivityType {
  todoCreated,
  todoCompleted,
  profileUpdated,
  photoShared,
  commentAdded,
}