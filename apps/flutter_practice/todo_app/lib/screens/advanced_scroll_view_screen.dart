import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:todo_app/screens/photo_detail_screen.dart';

class AdvancedScrollViewScreen extends StatefulWidget {
  const AdvancedScrollViewScreen({super.key});

  @override
  State<AdvancedScrollViewScreen> createState() =>
      _AdvancedScrollViewScreenState();
}

class _AdvancedScrollViewScreenState extends State<AdvancedScrollViewScreen> {
  // State for lazy loading functionality.
  final ScrollController _scrollController = ScrollController();
  final List<String> _imageUrls = [];
  bool _isLoading = false;
  // In a real app, this would be determined by the API response.
  final bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    // Add a listener to the scroll controller to handle lazy loading.
    _scrollController.addListener(_onScroll);
    // Load the initial batch of data.
    _loadMoreImages();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // Callback for the scroll controller.
  void _onScroll() {
    // Trigger loading more images when the user scrolls near the end of the list.
    if (!_isLoading &&
        _hasMore &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.9) {
      _loadMoreImages();
    }
  }

  // Fetches more images, simulating a network request.
  Future<void> _loadMoreImages() async {
    // Prevent multiple simultaneous fetches.
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate network latency.
    await Future.delayed(const Duration(seconds: 2));

    const newImageCount = 9;
    final newImages = List.generate(newImageCount, (index) {
      final imageIndex = _imageUrls.length + index + 1;
      return 'https://picsum.photos/seed/$imageIndex/600/600';
    });

    setState(() {
      _imageUrls.addAll(newImages);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // CustomScrollView allows combining various scrollable elements (slivers).
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Sliver 1: A collapsible iOS-style navigation bar.
          const CupertinoSliverNavigationBar(
            largeTitle: Text('My Photos'),
            trailing: Icon(CupertinoIcons.settings),
          ),

          // Sliver 2: A non-scrolling header widget.
          // SliverToBoxAdapter is used to place a regular widget inside a CustomScrollView.
          SliverToBoxAdapter(child: _buildProfileHeader()),

          // Sliver 3: A sticky section header.
          SliverPersistentHeader(
            delegate: _SliverHeaderDelegate('My Photos'),
            pinned:
                true, // This makes the header stick to the top during scroll.
          ),

          // Sliver 4: The main content grid.
          // Shows a shimmer effect for the initial load, then the image grid.
          if (_isLoading && _imageUrls.isEmpty)
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: _buildShimmerGrid(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: _buildImageGrid(),
            ),

          // Sliver 5: A loading indicator at the bottom.
          // Displayed only when fetching subsequent pages.
          if (_isLoading && _imageUrls.isNotEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: Center(child: CupertinoActivityIndicator()),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      color: CupertinoTheme.of(context).scaffoldBackgroundColor,
      child: const Column(
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            // Use a reliable image URL for the avatar.
            backgroundImage: NetworkImage(
              'https://picsum.photos/seed/profile_avatar/200',
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Hien Nguyen',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.label,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Flutter Developer | 12+ Years of Experience',
            style: TextStyle(
              fontSize: 16,
              color: CupertinoColors.secondaryLabel,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildImageGrid() {
    // A sliver version of GridView for displaying images.
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 items per row.
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 1.0,
      ),
      // Builds grid items on demand as they scroll into view.
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final imageUrl = _imageUrls[index];
          final heroTag = 'photo-grid-$index';

          // Handle taps to navigate to the detail screen.
          return GestureDetector(
            onTap: () {
              // Use PageRouteBuilder for a custom transparent route transition.
              // This is required for the swipe-to-dismiss effect to work correctly.
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque:
                      false, // Important: Allows the underlying screen to be visible.
                  barrierColor:
                      Colors.transparent, // No default background color.
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return PhotoDetailScreen(
                      imageUrl: imageUrl,
                      heroTag: heroTag,
                    );
                  },
                  // Add a fade effect for a smoother page transition.
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                ),
              );
            },
            // The Hero widget enables the shared element transition between screens.
            child: Hero(
              tag: heroTag, // The tag must be unique for each Hero.
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  // Show a loading indicator for each individual image.
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CupertinoActivityIndicator());
                  },
                ),
              ),
            ),
          );
        },
        // Set the item count to the number of loaded images.
        childCount: _imageUrls.length,
      ),
    );
  }

  // Builds the shimmer loading placeholder grid.
  Widget _buildShimmerGrid() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 1.0,
      ),
      // Build 9 placeholder items.
      delegate: SliverChildBuilderDelegate((context, index) {
        // Apply the shimmer effect to a simple container.
        return Shimmer(
          child: Container(
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey4,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        );
      }, childCount: 9),
    );
  }
}

// A custom delegate for creating persistent (sticky) headers.
class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;

  _SliverHeaderDelegate(this.title);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: CupertinoTheme.of(
        context,
      ).scaffoldBackgroundColor.withOpacity(0.9),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: CupertinoColors.label,
        ),
      ),
    );
  }

  @override
  double get maxExtent => 60.0;

  @override
  double get minExtent => 60.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
