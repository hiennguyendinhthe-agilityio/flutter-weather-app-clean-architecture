import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../widgets/loading_indicator_widget.dart';
import '../../widgets/shimmer_grid_widget.dart';
import '../../widgets/error_widget.dart' as custom_error;

/// Category chứa các basic UI components
class BasicComponentsCategory {
  static WidgetbookCategory create() {
    return WidgetbookCategory(
      name: '🧩 Basic Components',
      children: [
        // Loading States Folder
        WidgetbookFolder(
          name: '⏳ Loading States',
          children: [
            WidgetbookComponent(
              name: 'Loading Indicator',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default Loading',
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Default Loading'),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    body: const CustomScrollView(
                      slivers: [
                        LoadingIndicatorWidget(),
                      ],
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'With Custom Message',
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Loading with Message'),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    body: const CustomScrollView(
                      slivers: [
                        LoadingIndicatorWidget(
                          message: 'Đang tải dữ liệu...',
                        ),
                      ],
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'With Custom Padding',
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Custom Padding'),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    body: const CustomScrollView(
                      slivers: [
                        LoadingIndicatorWidget(
                          message: 'Loading with extra padding...',
                          padding: EdgeInsets.all(64.0),
                        ),
                      ],
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Multiple Loading States',
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Multiple Loading'),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    body: const CustomScrollView(
                      slivers: [
                        LoadingIndicatorWidget(message: 'Loading user data...'),
                        LoadingIndicatorWidget(message: 'Loading photos...'),
                        LoadingIndicatorWidget(message: 'Loading settings...'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Shimmer Grid',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default Shimmer Grid',
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Shimmer Loading'),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    body: const CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.all(16.0),
                          sliver: ShimmerGridWidget(),
                        ),
                      ],
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Shimmer with Header',
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Shimmer with Header'),
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
                                  'Loading Photos...',
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Please wait while we fetch your photos',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          sliver: ShimmerGridWidget(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        
        // Error States Folder
        WidgetbookFolder(
          name: '❌ Error States',
          children: [
            WidgetbookComponent(
              name: 'Error Widget',
              useCases: [
                WidgetbookUseCase(
                  name: 'Network Error',
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Network Error'),
                      backgroundColor: Theme.of(context).colorScheme.errorContainer,
                    ),
                    body: CustomScrollView(
                      slivers: [
                        custom_error.ErrorWidget(
                          message: 'Không thể kết nối mạng. Vui lòng kiểm tra kết nối internet của bạn.',
                          onRetry: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('🔄 Đang thử lại kết nối...'),
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Server Error (500)',
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Server Error'),
                      backgroundColor: Theme.of(context).colorScheme.errorContainer,
                    ),
                    body: CustomScrollView(
                      slivers: [
                        custom_error.ErrorWidget(
                          message: 'Lỗi server (500). Máy chủ đang gặp sự cố, vui lòng thử lại sau ít phút.',
                          onRetry: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('🔄 Đang thử lại...'),
                                backgroundColor: Colors.orange,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Authentication Error',
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Auth Error'),
                      backgroundColor: Theme.of(context).colorScheme.errorContainer,
                    ),
                    body: CustomScrollView(
                      slivers: [
                        custom_error.ErrorWidget(
                          message: 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại để tiếp tục.',
                          onRetry: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('🔐 Chuyển đến trang đăng nhập...'),
                                backgroundColor: Colors.deepPurple,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Fatal Error (No Retry)',
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Fatal Error'),
                      backgroundColor: Theme.of(context).colorScheme.errorContainer,
                    ),
                    body: const CustomScrollView(
                      slivers: [
                        custom_error.ErrorWidget(
                          message: 'Đã xảy ra lỗi nghiêm trọng không thể khôi phục. Vui lòng khởi động lại ứng dụng.',
                          onRetry: null, // No retry button
                        ),
                      ],
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Custom Padding Error',
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Custom Padding'),
                      backgroundColor: Theme.of(context).colorScheme.errorContainer,
                    ),
                    body: CustomScrollView(
                      slivers: [
                        custom_error.ErrorWidget(
                          message: 'Lỗi với padding tùy chỉnh',
                          padding: const EdgeInsets.all(32.0),
                          onRetry: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Retry with custom padding!'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ],
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
}