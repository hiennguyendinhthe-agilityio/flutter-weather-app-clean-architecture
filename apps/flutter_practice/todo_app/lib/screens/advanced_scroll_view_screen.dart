import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../controllers/photo_scroll_controller.dart';
import '../services/scroll_service.dart';
import '../services/navigation_service.dart';
import '../widgets/profile_header_widget.dart';
import '../widgets/photo_grid_widget.dart';
import '../widgets/shimmer_grid_widget.dart';
import '../widgets/sliver_header_delegate.dart';
import '../widgets/loading_indicator_widget.dart';
import '../widgets/error_widget.dart' as custom;
import '../constants/app_constants.dart';
import '../config/theme_extensions.dart';

class AdvancedScrollViewScreen extends StatelessWidget {
  const AdvancedScrollViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ScrollService>(create: (_) => ScrollService()),
        Provider<NavigationService>(create: (_) => NavigationService()),
        ChangeNotifierProvider<PhotoScrollController>(
          create: (context) {
            return PhotoScrollController(
              context.read<ScrollService>(),
            );
          },
        ),
      ],
      child: const _AdvancedScrollViewContent(),
    );
  }
}

class _AdvancedScrollViewContent extends StatefulWidget {
  const _AdvancedScrollViewContent();

  @override
  State<_AdvancedScrollViewContent> createState() => _AdvancedScrollViewContentState();
}

class _AdvancedScrollViewContentState extends State<_AdvancedScrollViewContent> {
  @override
  void initState() {
    super.initState();
    // Initialize controller after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PhotoScrollController>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PhotoScrollController>(
      builder: (context, controller, child) {
        return CupertinoPageScaffold(
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            controller: controller.scrollController,
            slivers: [
              _buildNavigationBar(context),
              const SliverToBoxAdapter(child: ProfileHeaderWidget()),
              _buildPhotosHeader(),
              _buildContent(context, controller),
              _buildLoadingIndicator(controller),
              _buildErrorWidget(context, controller),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavigationBar(BuildContext context) {
    return CupertinoSliverNavigationBar(
      largeTitle: ThemedText(
        AppConstants.profileTitle,
        style: const TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: const ThemeToggleWidget(showLabel: false),
    );
  }

  Widget _buildPhotosHeader() {
    return SliverPersistentHeader(
      delegate: const SliverHeaderDelegate(title: AppConstants.photosTitle),
      pinned: false,
    );
  }

  Widget _buildContent(
    BuildContext context,
    PhotoScrollController controller,
  ) {
    return SliverPadding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      sliver: _getContentSliver(context, controller),
    );
  }

  Widget _getContentSliver(
    BuildContext context,
    PhotoScrollController controller,
  ) {
    if (controller.isInitialLoading) {
      return const ShimmerGridWidget();
    }

    if (controller.imageUrls.isEmpty && controller.scrollState.error != null) {
      return custom.ErrorWidget(
        message: controller.scrollState.error!,
        onRetry: controller.retryLoading,
      );
    }

    return PhotoGridWidget(
      imageUrls: controller.imageUrls,
      navigationService: context.read<NavigationService>(),
    );
  }

  Widget _buildLoadingIndicator(PhotoScrollController controller) {
    if (!controller.isLoadingMore) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return const LoadingIndicatorWidget(message: 'Loading more photos...');
  }

  Widget _buildErrorWidget(
    BuildContext context,
    PhotoScrollController controller,
  ) {
    if (controller.scrollState.error == null || controller.imageUrls.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return custom.ErrorWidget(
      message: controller.scrollState.error!,
      onRetry: controller.retryLoading,
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
    );
  }
}
