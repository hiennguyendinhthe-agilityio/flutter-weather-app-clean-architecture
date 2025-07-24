import 'package:daily_example_app/widget_of_the_week/weeks/interactive_widgets/week_11_hero.dart';
import 'package:daily_example_app/widget_of_the_week/weeks/interactive_widgets/week_12_transform.dart';
import 'package:flutter/material.dart';

import 'weeks/advanced_widgets/week_29_overlay_portal.dart';
import 'weeks/async_widgets/week_15_future_builder.dart';
import 'weeks/display_widgets/week_17_carousel_view.dart';
import 'weeks/foundation_widgets/week_01_container.dart';
import 'weeks/foundation_widgets/week_02_row_column.dart';
import 'weeks/foundation_widgets/week_03_stack.dart';
import 'weeks/foundation_widgets/week_04_positioned.dart';
import 'weeks/input_widgets/week_13_search_anchor.dart';
import 'weeks/input_widgets/week_14_dropdown_menu.dart';
import 'weeks/interactive_widgets/week_09_draggable.dart';
import 'weeks/interactive_widgets/week_10_raw_magnifier.dart';
import 'weeks/layout_widgets/week_05_expanded_flexible.dart';
import 'weeks/layout_widgets/week_06_wrap.dart';
import 'weeks/layout_widgets/week_07_listview.dart';
import 'weeks/layout_widgets/week_08_gridview.dart';
import 'weeks/navigation_widgets/week_16_navigation_bar.dart';

/// Model for each Widget lesson
class WidgetLesson {
  final String id;
  final String title;
  final String description;
  final int week;
  final String category;
  final Widget Function() builder;
  final String difficulty; // 'Basic', 'Intermediate', 'Advanced'
  bool isCompleted;

  WidgetLesson({
    required this.id,
    required this.title,
    required this.description,
    required this.week,
    required this.category,
    required this.builder,
    required this.difficulty,
    this.isCompleted = false,
  });
}

/// Manager for all Widget lessons
class WidgetManager {
  static final List<WidgetLesson> _lessons = [];

  /// Get all lessons
  static List<WidgetLesson> getAllLessons() => _lessons;

  /// Get lessons by category
  static List<WidgetLesson> getLessonsByCategory(String category) {
    return _lessons.where((lesson) => lesson.category == category).toList();
  }

  /// Get lesson by ID
  static WidgetLesson? getLessonById(String id) {
    try {
      return _lessons.firstWhere((lesson) => lesson.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Mark lesson as completed
  static void markAsCompleted(String id) {
    final lesson = getLessonById(id);
    if (lesson != null) {
      lesson.isCompleted = true;
    }
  }

  /// Get learning progress (%)
  static double getProgress() {
    if (_lessons.isEmpty) return 0.0;
    final completed = _lessons.where((lesson) => lesson.isCompleted).length;
    return completed / _lessons.length;
  }

  /// Add new lesson
  static void addLesson(WidgetLesson lesson) {
    _lessons.add(lesson);
  }

  /// Initialize all lessons
  static void initializeLessons() {
    _lessons.clear();

    // Foundation Widgets (Week 1-4)
    _addFoundationWidgets();

    // Layout Widgets (Week 5-8)
    _addLayoutWidgets();

    // Interactive Widgets (Week 9-12)
    _addInteractiveWidgets();

    // Input Widgets (Week 13-14)
    _addInputWidgets();

    // Async Widgets (Week 15)
    _addAsyncWidgets();

    // Navigation Widgets (Week 16)
    _addNavigationWidgets();

    // Display Widgets (Week 17-20)
    _addDisplayWidgets();

    // Advanced Widgets (Week 29-32)
    _addAdvancedWidgets();
  }

  static void _addFoundationWidgets() {
    addLesson(
      WidgetLesson(
        id: 'week_01_container',
        title: 'Container Widget',
        description:
            'Basic widget to create containers with decoration, padding, margin',
        week: 1,
        category: 'Foundation',
        difficulty: 'Basic',
        builder: () => const Week01Container(),
      ),
    );

    addLesson(
      WidgetLesson(
        id: 'week_02_row_column',
        title: 'Row & Column',
        description:
            'Layout widgets to arrange widgets horizontally and vertically',
        week: 2,
        category: 'Foundation',
        difficulty: 'Basic',
        builder: () => const Week02RowColumn(),
      ),
    );

    addLesson(
      WidgetLesson(
        id: 'week_03_stack',
        title: 'Stack Widget',
        description: 'Layer widgets on top of each other like layers',
        week: 3,
        category: 'Foundation',
        difficulty: 'Basic',
        builder: () => const Week03Stack(),
      ),
    );

    addLesson(
      WidgetLesson(
        id: 'week_04_positioned',
        title: 'Positioned Widget',
        description: 'Precisely position widgets within Stack',
        week: 4,
        category: 'Foundation',
        difficulty: 'Intermediate',
        builder: () => const Week04Positioned(),
      ),
    );
  }

  static void _addLayoutWidgets() {
    addLesson(
      WidgetLesson(
        id: 'week_05_expanded_flexible',
        title: 'Expanded & Flexible',
        description:
            'Flexible space distribution in Row/Column with flex ratios',
        week: 5,
        category: 'Layout',
        difficulty: 'Intermediate',
        builder: () => const Week05ExpandedFlexible(),
      ),
    );

    addLesson(
      WidgetLesson(
        id: 'week_06_wrap',
        title: 'Wrap Widget',
        description:
            'Auto line-breaking layout for tags, chips, and flexible content',
        week: 6,
        category: 'Layout',
        difficulty: 'Basic',
        builder: () => const Week06Wrap(),
      ),
    );

    addLesson(
      WidgetLesson(
        id: 'week_07_listview',
        title: 'ListView Widget',
        description:
            'Scrollable list widget for displaying large amounts of data efficiently',
        week: 7,
        category: 'Layout',
        difficulty: 'Intermediate',
        builder: () => const Week07ListView(),
      ),
    );

    addLesson(
      WidgetLesson(
        id: 'week_08_gridview',
        title: 'GridView Widget',
        description:
            'Grid layout widget for galleries, dashboards, and product catalogs',
        week: 8,
        category: 'Layout',
        difficulty: 'Intermediate',
        builder: () => const Week08GridView(),
      ),
    );
  }

  static void _addInteractiveWidgets() {
    addLesson(
      WidgetLesson(
        id: 'week_09_draggable',
        title: 'Draggable Widget',
        description: 'Draggable widget for reordering and repositioning items',
        week: 9,
        category: 'Interactive',
        difficulty: 'Intermediate',
        builder: () => const Week09Draggable(),
      ),
    );

    addLesson(
      WidgetLesson(
        id: 'week_10_raw_magnifier',
        title: 'RawMagnifier Widget',
        description: 'Interactive magnifier widget for zooming in on content',
        week: 10,
        category: 'Interactive',
        difficulty: 'Advanced',
        builder: () => const Week10RawMagnifier(),
      ),
    );

    addLesson(
      WidgetLesson(
        id: 'week_11_hero',
        title: 'Hero Widget',
        description: 'reate hero animations between screens',
        week: 11,
        category: 'Interactive',
        difficulty: 'Basic',
        builder: () => const Week11Hero(),
      ),
    );

    addLesson(
      WidgetLesson(
        id: 'week_12_transform',
        title: 'Transform Widget',
        description:
            'Apply transformations like rotation, scaling, and translation',
        week: 12,
        category: 'Interactive',
        difficulty: 'Intermediate',
        builder: () => const Week12Transform(),
      ),
    );
  }

  static void _addInputWidgets() {
    addLesson(
      WidgetLesson(
        id: 'week_13_search_anchor',
        title: 'Search & SearchAnchor',
        description:
            'Material Design search interface with suggestions and filtering',
        week: 13,
        category: 'Input',
        difficulty: 'Intermediate',
        builder: () => const Week13SearchAnchor(),
      ),
    );

    addLesson(
      WidgetLesson(
        id: 'week_14_dropdown_menu',
        title: 'DropdownMenu',
        description:
            'Material Design 3 dropdown menu with modern styling and accessibility',
        week: 14,
        category: 'Input',
        difficulty: 'Basic',
        builder: () => const Week14DropdownMenu(),
      ),
    );
  }

  static void _addAsyncWidgets() {
    addLesson(
      WidgetLesson(
        id: 'week_15_future_builder',
        title: 'FutureBuilder Widget',
        description:
            'Handle async operations with Future objects, loading states, and error handling',
        week: 15,
        category: 'Async',
        difficulty: 'Intermediate',
        builder: () => const Week15FutureBuilder(),
      ),
    );
  }

  static void _addNavigationWidgets() {
    addLesson(
      WidgetLesson(
        id: 'week_16_navigation_bar',
        title: 'NavigationBar Widget',
        description:
            'Material 3 bottom navigation with modern design and responsive patterns',
        week: 16,
        category: 'Navigation',
        difficulty: 'Basic',
        builder: () => const Week16NavigationBar(),
      ),
    );
  }

  static void _addDisplayWidgets() {
    addLesson(
      WidgetLesson(
        id: 'week_17_carousel_view',
        title: 'CarouselView',
        description:
            'Scrollable carousel widget for showcasing content horizontally',
        week: 17,
        category: 'Display',
        difficulty: 'Intermediate',
        builder: () => const Week17CarouselView(),
      ),
    );
  }

  static void _addAdvancedWidgets() {
    addLesson(
      WidgetLesson(
        id: 'week_29_overlay_portal',
        title: 'OverlayPortal',
        description:
            'Declarative overlay system for tooltips, menus, and modals',
        week: 29,
        category: 'Advanced',
        difficulty: 'Advanced',
        builder: () => const Week29OverlayPortal(),
      ),
    );
  }
}
