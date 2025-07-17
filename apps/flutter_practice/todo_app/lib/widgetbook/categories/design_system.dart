import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

/// Category showcase Design System của app
class DesignSystemCategory {
  static WidgetbookCategory create() {
    return WidgetbookCategory(
      name: '🎨 Design System',
      children: [
        // Colors & Themes
        WidgetbookFolder(
          name: '🎨 Colors & Themes',
          children: [
            WidgetbookComponent(
              name: 'Color Palette',
              useCases: [
                WidgetbookUseCase(
                  name: 'Primary Colors',
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Primary Color Palette'),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    body: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Primary Colors',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          _buildColorRow(context, 'Primary', Theme.of(context).colorScheme.primary),
                          _buildColorRow(context, 'Primary Container', Theme.of(context).colorScheme.primaryContainer),
                          _buildColorRow(context, 'On Primary', Theme.of(context).colorScheme.onPrimary),
                          _buildColorRow(context, 'On Primary Container', Theme.of(context).colorScheme.onPrimaryContainer),
                          
                          const SizedBox(height: 24),
                          Text(
                            'Secondary Colors',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          _buildColorRow(context, 'Secondary', Theme.of(context).colorScheme.secondary),
                          _buildColorRow(context, 'Secondary Container', Theme.of(context).colorScheme.secondaryContainer),
                          _buildColorRow(context, 'On Secondary', Theme.of(context).colorScheme.onSecondary),
                          _buildColorRow(context, 'On Secondary Container', Theme.of(context).colorScheme.onSecondaryContainer),
                        ],
                      ),
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Surface Colors',
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Surface Colors'),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    body: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Surface & Background',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          _buildColorRow(context, 'Surface', Theme.of(context).colorScheme.surface),
                          _buildColorRow(context, 'Surface Container', Theme.of(context).colorScheme.surfaceContainer),
                          _buildColorRow(context, 'On Surface', Theme.of(context).colorScheme.onSurface),
                          _buildColorRow(context, 'On Surface Variant', Theme.of(context).colorScheme.onSurfaceVariant),
                        ],
                      ),
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Status Colors',
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Status Colors'),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    body: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status & Feedback Colors',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          _buildColorRow(context, 'Error', Theme.of(context).colorScheme.error),
                          _buildColorRow(context, 'Error Container', Theme.of(context).colorScheme.errorContainer),
                          _buildColorRow(context, 'On Error', Theme.of(context).colorScheme.onError),
                          _buildColorRow(context, 'On Error Container', Theme.of(context).colorScheme.onErrorContainer),
                          
                          const SizedBox(height: 16),
                          _buildColorRow(context, 'Success', Colors.green),
                          _buildColorRow(context, 'Warning', Colors.orange),
                          _buildColorRow(context, 'Info', Colors.blue),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        
        // Typography
        WidgetbookFolder(
          name: '📝 Typography',
          children: [
            WidgetbookComponent(
              name: 'Text Styles',
              useCases: [
                WidgetbookUseCase(
                  name: 'Headlines',
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Headlines'),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    body: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextStyleRow(context, 'Headline Large', 
                            Theme.of(context).textTheme.headlineLarge, 'The quick brown fox'),
                          _buildTextStyleRow(context, 'Headline Medium', 
                            Theme.of(context).textTheme.headlineMedium, 'The quick brown fox'),
                          _buildTextStyleRow(context, 'Headline Small', 
                            Theme.of(context).textTheme.headlineSmall, 'The quick brown fox'),
                        ],
                      ),
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Titles',
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Titles'),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    body: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextStyleRow(context, 'Title Large', 
                            Theme.of(context).textTheme.titleLarge, 'The quick brown fox jumps'),
                          _buildTextStyleRow(context, 'Title Medium', 
                            Theme.of(context).textTheme.titleMedium, 'The quick brown fox jumps'),
                          _buildTextStyleRow(context, 'Title Small', 
                            Theme.of(context).textTheme.titleSmall, 'The quick brown fox jumps'),
                        ],
                      ),
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Body & Labels',
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Body & Labels'),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    body: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextStyleRow(context, 'Body Large', 
                            Theme.of(context).textTheme.bodyLarge, 
                            'The quick brown fox jumps over the lazy dog'),
                          _buildTextStyleRow(context, 'Body Medium', 
                            Theme.of(context).textTheme.bodyMedium, 
                            'The quick brown fox jumps over the lazy dog'),
                          _buildTextStyleRow(context, 'Body Small', 
                            Theme.of(context).textTheme.bodySmall, 
                            'The quick brown fox jumps over the lazy dog'),
                          const SizedBox(height: 16),
                          _buildTextStyleRow(context, 'Label Large', 
                            Theme.of(context).textTheme.labelLarge, 'LABEL TEXT'),
                          _buildTextStyleRow(context, 'Label Medium', 
                            Theme.of(context).textTheme.labelMedium, 'LABEL TEXT'),
                          _buildTextStyleRow(context, 'Label Small', 
                            Theme.of(context).textTheme.labelSmall, 'LABEL TEXT'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        
        // Spacing & Layout
        WidgetbookFolder(
          name: '📐 Spacing & Layout',
          children: [
            WidgetbookComponent(
              name: 'Spacing System',
              useCases: [
                WidgetbookUseCase(
                  name: 'Padding Variations',
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Spacing System'),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    body: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Spacing Scale',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          _buildSpacingExample(context, '4px', 4.0),
                          _buildSpacingExample(context, '8px', 8.0),
                          _buildSpacingExample(context, '12px', 12.0),
                          _buildSpacingExample(context, '16px', 16.0),
                          _buildSpacingExample(context, '24px', 24.0),
                          _buildSpacingExample(context, '32px', 32.0),
                          _buildSpacingExample(context, '48px', 48.0),
                          _buildSpacingExample(context, '64px', 64.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Border Radius',
              useCases: [
                WidgetbookUseCase(
                  name: 'Radius Variations',
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Border Radius'),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    body: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Border Radius Scale',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          _buildRadiusExample(context, 'No Radius', 0.0),
                          _buildRadiusExample(context, 'Small (4px)', 4.0),
                          _buildRadiusExample(context, 'Medium (8px)', 8.0),
                          _buildRadiusExample(context, 'Large (12px)', 12.0),
                          _buildRadiusExample(context, 'Extra Large (16px)', 16.0),
                          _buildRadiusExample(context, 'Circular (24px)', 24.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        
        // Elevation & Shadows
        WidgetbookFolder(
          name: '🌟 Elevation & Effects',
          children: [
            WidgetbookComponent(
              name: 'Material Elevation',
              useCases: [
                WidgetbookUseCase(
                  name: 'Elevation Levels',
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Material Elevation'),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    body: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Elevation Scale',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          _buildElevationExample(context, 'Level 0', 0.0),
                          _buildElevationExample(context, 'Level 1', 1.0),
                          _buildElevationExample(context, 'Level 2', 2.0),
                          _buildElevationExample(context, 'Level 4', 4.0),
                          _buildElevationExample(context, 'Level 6', 6.0),
                          _buildElevationExample(context, 'Level 8', 8.0),
                          _buildElevationExample(context, 'Level 12', 12.0),
                          _buildElevationExample(context, 'Level 16', 16.0),
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
  
  // Helper methods for building design system examples
  static Widget _buildColorRow(BuildContext context, String name, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '#${color.toARGB32().toRadixString(16).toUpperCase().padLeft(8, '0')}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  static Widget _buildTextStyleRow(BuildContext context, String name, TextStyle? style, String sample) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(sample, style: style),
          const SizedBox(height: 4),
          Text(
            'Size: ${style?.fontSize?.toStringAsFixed(0) ?? 'default'}px, Weight: ${style?.fontWeight?.toString() ?? 'normal'}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const Divider(height: 16),
        ],
      ),
    );
  }
  
  static Widget _buildSpacingExample(BuildContext context, String label, double spacing) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          Container(
            width: spacing,
            height: 24,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
  
  static Widget _buildRadiusExample(BuildContext context, String label, double radius) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          Container(
            width: 60,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  static Widget _buildElevationExample(BuildContext context, String label, double elevation) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          Material(
            elevation: elevation,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 80,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  elevation.toString(),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}