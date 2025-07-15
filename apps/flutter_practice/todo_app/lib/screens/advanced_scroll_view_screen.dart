import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:todo_app/providers/photo_provider.dart';
import 'package:todo_app/providers/theme_provider.dart';
import 'package:todo_app/screens/photo_detail_screen.dart';

class AdvancedScrollViewScreen extends StatefulWidget {
  const AdvancedScrollViewScreen({super.key});

  @override
  State<AdvancedScrollViewScreen> createState() =>
      _AdvancedScrollViewScreenState();
}

class _AdvancedScrollViewScreenState extends State<AdvancedScrollViewScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Add a listener to the scroll controller to handle lazy loading.
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PhotoProvider>(context, listen: false).loadMoreImages();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // Callback for the scroll controller.
  void _onScroll() {
    final photoProvider = Provider.of<PhotoProvider>(context, listen: false);

    // Trigger loading more images when the user scrolls near the end of the list.
    if (!photoProvider.isLoading &&
        photoProvider.hasMore &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.9) {
      photoProvider.loadMoreImages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PhotoProvider>(
      builder: (context, photoProvider, child) {
        return CupertinoPageScaffold(
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            controller: _scrollController,
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: const Text('Profile'),
                trailing: CupertinoSwitch(
                  value: Provider.of<ThemeProvider>(context).isDarkMode,
                  onChanged: (value) {
                    Provider.of<ThemeProvider>(
                      context,
                      listen: false,
                    ).toggleTheme();
                  },
                ),
              ),

              const SliverToBoxAdapter(child: _ProfileHeader()),

              SliverPersistentHeader(
                delegate: _SliverHeaderDelegate('My Photos'),
                pinned: false,
              ),

              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver:
                    photoProvider.imageUrls.isEmpty && photoProvider.isLoading
                    ? _buildShimmerGrid()
                    : _buildImageGrid(photoProvider.imageUrls),
              ),

              if (photoProvider.isLoading && photoProvider.imageUrls.isNotEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(child: CupertinoActivityIndicator()),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageGrid(List<String> imageUrls) {
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
          final imageUrl = imageUrls[index];
          // The heroTag MUST match the one used in PhotoDetailScreen, which is the URL itself.
          final heroTag = imageUrl;

          // Handle taps to navigate to the detail screen.
          return GestureDetector(
            onTap: () {
              // Use PageRouteBuilder for a custom transparent route transition.
              // This is required for the swipe-to-dismiss effect to work correctly.
              Navigator.of(context, rootNavigator: true).push(
                PageRouteBuilder(
                  opaque:
                      false, // Important: Allows the underlying screen to be visible.
                  barrierColor:
                      Colors.transparent, // No default background color.
                  pageBuilder: (context, animation, secondaryAnimation) {
                    // Pass the full list of URLs and the index of the tapped image.
                    return PhotoDetailScreen(
                      imageUrls: imageUrls,
                      initialIndex: index,
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
        childCount: imageUrls.length,
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

// A dedicated stateless widget for the profile header.
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
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
      color: CupertinoTheme.of(context).scaffoldBackgroundColor,
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
