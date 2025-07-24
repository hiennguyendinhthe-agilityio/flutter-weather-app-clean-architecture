import 'package:flutter/material.dart';

import '../../components/code_examples_manager.dart';
import '../../components/floating_code_button.dart';

class Week11Hero extends StatefulWidget {
  const Week11Hero({super.key});

  @override
  State<Week11Hero> createState() => _Week11HeroState();
}

class _Week11HeroState extends State<Week11Hero> {
  final List<PhotoItem> _photos = [
    PhotoItem(
      id: 1,
      title: 'Sunset Beach',
      color: Colors.orange,
      icon: Icons.beach_access,
    ),
    PhotoItem(
      id: 2,
      title: 'Mountain View',
      color: Colors.green,
      icon: Icons.landscape,
    ),
    PhotoItem(
      id: 3,
      title: 'City Lights',
      color: Colors.blue,
      icon: Icons.location_city,
    ),
    PhotoItem(
      id: 4,
      title: 'Forest Path',
      color: Colors.brown,
      icon: Icons.park,
    ),
    PhotoItem(
      id: 5,
      title: 'Ocean Wave',
      color: Colors.cyan,
      icon: Icons.waves,
    ),
    PhotoItem(
      id: 6,
      title: 'Desert Dune',
      color: Colors.amber,
      icon: Icons.terrain,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Week 11: Hero Widget'),
        backgroundColor: Colors.deepOrange,
      ),
      floatingActionButton: FloatingCodeButton(
        examples: _getHeroExamples(),
        lessonTitle: 'Hero Widget',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTheorySection(),
            const SizedBox(height: 24),
            _buildInteractiveDemo(),
            const SizedBox(height: 24),
            _buildExamples(),
            const SizedBox(height: 24),
            _buildExercises(),
          ],
        ),
      ),
    );
  }

  Widget _buildTheorySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📚 Theory: Hero Widget',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'The Hero widget creates a smooth animation when transitioning between screens. '
              'The widget "flies" from its old position to its new one, creating a '
              'sense of continuity and natural flow.',
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🧠 How it works:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('1. Flutter finds two Hero widgets with the same tag.'),
                  Text('2. It calculates the position and size of both.'),
                  Text(
                    '3. An animation is created from the old position to the new one.',
                  ),
                  Text(
                    '4. During the animation, the widget "flies" on an overlay.',
                  ),
                  Text(
                    '5. When the animation ends, the widget appears in its new position.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            const Text(
              '🔑 Important Properties:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• tag: A unique ID to pair two Hero widgets.'),
            const Text('• child: The widget to be animated.'),
            const Text(
              '• flightShuttleBuilder: A builder for a custom animation widget.',
            ),
            const Text(
              '• placeholderBuilder: A widget to display while the hero is in flight.',
            ),
            const Text('• transitionOnUserGestures: Animate on user gestures.'),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🎨 UI Design Principles:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Continuity: Creates a seamless flow between screens.',
                  ),
                  Text('• Focus: Draws attention to important elements.'),
                  Text(
                    '• Context: Maintains context during screen transitions.',
                  ),
                  Text('• Delight: Creates an enjoyable user experience.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveDemo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🎮 Interactive Demo - Photo Gallery with Hero Animation',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 UI Pattern: Gallery → Detail View',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('• A grid view displays thumbnails.'),
                  Text(
                    '• Tapping an image triggers a Hero animation to the detail view.',
                  ),
                  Text(
                    '• The detail view shows the larger image and information.',
                  ),
                  Text('• The back button reverses the Hero animation.'),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              'Tap on any photo to see the Hero animation:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemCount: _photos.length,
              itemBuilder: (context, index) {
                final photo = _photos[index];
                return _buildPhotoCard(photo);
              },
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purple.shade200),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '⚙️ Code Logic Breakdown:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('1. Each photo is wrapped in a Hero widget.'),
                  Text(
                    '2. The tag is set to "photo_\${photo.id}" (a unique identifier).',
                  ),
                  Text(
                    '3. onTap triggers Navigator.push() to the detail screen.',
                  ),
                  Text(
                    '4. The detail screen also has a Hero with the same tag.',
                  ),
                  Text('5. Flutter automatically creates the animation.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoCard(PhotoItem photo) {
    return Hero(
      tag: 'photo_${photo.id}',
      child: Material(
        borderRadius: BorderRadius.circular(12),
        elevation: 4,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _navigateToDetail(photo),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  photo.color.withValues(alpha: 0.7),
                  photo.color.withValues(alpha: 0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(photo.icon, size: 48, color: Colors.white),
                const SizedBox(height: 8),
                Text(
                  photo.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Tap to view',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(PhotoItem photo) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PhotoDetailScreen(photo: photo)),
    );
  }

  Widget _buildExamples() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '💡 Real-world Examples and UI Patterns',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '1. Profile Avatar → Profile Page:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Hero(
                  tag: 'profile_avatar',
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue,
                    child: const Text(
                      'JD',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'John Doe',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text('Flutter Developer'),
                      const SizedBox(height: 4),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ProfileDetailScreen(),
                          ),
                        ),
                        child: const Text('View Profile'),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              '2. Product Card → Product Detail:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Hero(
              tag: 'product_1',
              child: Material(
                borderRadius: BorderRadius.circular(8),
                elevation: 2,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => _showProductDetail(),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        colors: [Colors.purple, Colors.pink],
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.phone_android,
                          color: Colors.white,
                          size: 32,
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'iPhone 15 Pro',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$999',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.indigo.shade200),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🎨 UI Design Tips for Hero Animations:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Maintain a consistent aspect ratio between the two screens.',
                  ),
                  Text('• Use a Material widget to avoid visual glitches.'),
                  Text(
                    '• Aim for an animation duration of 300-500ms (not too fast or slow).',
                  ),
                  Text('• Ensure that colors and shapes are compatible.'),
                  Text('• Test on various screen sizes.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProductDetail() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Product Detail')),
          body: Column(
            children: [
              Hero(
                tag: 'product_1',
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple, Colors.pink],
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone_android, color: Colors.white, size: 80),
                      SizedBox(height: 16),
                      Text(
                        'iPhone 15 Pro',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$999',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Latest iPhone with advanced features...'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExercises() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📝 Practice Exercises',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '1. Create a News App with Hero Animations:\n'
              '   • Display news thumbnails in a list view.\n'
              '   • Use a Hero animation to transition from a thumbnail to the full article.\n'
              '   • Implement a custom flightShuttleBuilder.\n\n'
              '2. Build an E-commerce Product Gallery:\n'
              '   • Display products in a grid view.\n'
              '   • Use a Hero animation to transition to the product detail page.\n'
              '   • Add loading states.\n\n'
              '3. Design a Social Media Profile:\n'
              '   • Transition from an avatar in the feed to the profile page.\n'
              '   • Implement multiple simultaneous Hero animations.\n'
              '   • Use custom animation curves.',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Great! You now understand the Hero Widget and its UI patterns!',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Complete Lesson'),
            ),
          ],
        ),
      ),
    );
  }

  List<CodeExample> _getHeroExamples() {
    return [
      const CodeExample(
        title: 'Basic Hero Animation',
        code: r'''

Hero(
  tag: 'image_1', 
  child: Material(
    child: InkWell(
      onTap: () => Navigator.push(context, 
        MaterialPageRoute(builder: (context) => DetailScreen())),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.image, color: Colors.white),
      ),
    ),
  ),
)


Hero(
  tag: 'image_1', 
  child: Container(
    width: double.infinity,
    height: 300,
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Icon(Icons.image, color: Colors.white, size: 100),
  ),
)''',
      ),
      const CodeExample(
        title: 'Custom Flight Shuttle',
        code: r'''
Hero(
  tag: 'custom_hero',
  flightShuttleBuilder: (
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.rotate(
          angle: animation.value * 2 * 3.14159, 
          child: Material(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(50 * animation.value),
              ),
            ),
          ),
        );
      },
    );
  },
  child: YourWidget(),
)''',
      ),
      const CodeExample(
        title: 'Photo Gallery Pattern',
        code: r'''
class PhotoGallery extends StatelessWidget {
  final List<Photo> photos;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: photos.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final photo = photos[index];
        return Hero(
          tag: 'photo_\${photo.id}',
          child: Material(
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhotoDetail(photo: photo),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(photo.thumbnailUrl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}''',
      ),
    ];
  }
}

class ProfileDetailScreen extends StatelessWidget {
  const ProfileDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Detail')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Hero(
              tag: 'profile_avatar',
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.blue,
                child: Text(
                  'JD',
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'John Doe',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text('Flutter Developer'),
            const Text('San Francisco, CA'),
          ],
        ),
      ),
    );
  }
}

class PhotoDetailScreen extends StatelessWidget {
  final PhotoItem photo;

  const PhotoDetailScreen({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'photo_${photo.id}',
              child: Container(
                width: double.infinity,
                height: 300,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [photo.color.withValues(alpha: 0.8), photo.color],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(photo.icon, size: 120, color: Colors.white),
                    const SizedBox(height: 20),
                    Text(
                      photo.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'This is a detailed view of the photo. The Hero widget creates a smooth transition from the grid view to this detailed view.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Gallery'),
              style: ElevatedButton.styleFrom(
                backgroundColor: photo.color,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhotoItem {
  final int id;
  final String title;
  final Color color;
  final IconData icon;

  PhotoItem({
    required this.id,
    required this.title,
    required this.color,
    required this.icon,
  });
}
