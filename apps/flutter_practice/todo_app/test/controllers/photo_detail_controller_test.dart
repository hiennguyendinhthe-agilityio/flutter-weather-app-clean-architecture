import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:todo_app/controllers/photo_detail_controller.dart';
import 'package:todo_app/services/photo_animation_service.dart';
import 'package:todo_app/models/photo_gesture_state.dart';

@GenerateMocks([PhotoAnimationService])
import 'photo_detail_controller_test.mocks.dart';

void main() {
  group('PhotoDetailController', () {
    late PhotoDetailController controller;
    late MockPhotoAnimationService mockAnimationService;

    setUp(() {
      mockAnimationService = MockPhotoAnimationService();
      controller = PhotoDetailController(mockAnimationService);
    });

    tearDown(() {
      controller.dispose();
    });

    test('should initialize with correct initial index', () {
      // Arrange
      const initialIndex = 2;

      // Act
      controller.initialize(initialIndex);

      // Assert
      expect(controller.currentIndex, equals(initialIndex));
      expect(controller.pageController.initialPage, equals(initialIndex));
    });

    test('should update current index on page change', () {
      // Arrange
      controller.initialize(0);
      const newIndex = 3;

      // Act
      controller.onPageChanged(newIndex);

      // Assert
      expect(controller.currentIndex, equals(newIndex));
    });

    test('should update gesture state on vertical drag', () {
      // Arrange
      controller.initialize(0);
      const screenSize = Size(400, 800);
      final dragDetails = DragUpdateDetails(
        delta: const Offset(0, 50),
        globalPosition: const Offset(200, 400),
      );

      when(mockAnimationService.calculateScale(any)).thenReturn(0.9);
      when(mockAnimationService.calculateOpacity(any)).thenReturn(0.8);

      // Act
      controller.onVerticalDragUpdate(dragDetails, screenSize);

      // Assert
      expect(controller.gestureState.dragOffset, equals(const Offset(0, 50)));
      verify(mockAnimationService.calculateScale(any)).called(1);
      verify(mockAnimationService.calculateOpacity(any)).called(1);
    });

    test('should call onDismiss when should dismiss is true', () {
      // Arrange
      controller.initialize(0);
      const screenSize = Size(400, 800);
      final dragDetails = DragEndDetails(primaryVelocity: 600);
      var dismissCalled = false;

      when(mockAnimationService.shouldDismiss(any, any, any)).thenReturn(true);

      // Act
      controller.onVerticalDragEnd(dragDetails, screenSize, () {
        dismissCalled = true;
      });

      // Assert
      expect(dismissCalled, isTrue);
      verify(mockAnimationService.shouldDismiss(any, any, any)).called(1);
    });

    test('should reset gesture state', () {
      // Arrange
      controller.initialize(0);
      final dragDetails = DragUpdateDetails(
        delta: const Offset(0, 50),
        globalPosition: const Offset(200, 400),
      );

      when(mockAnimationService.calculateScale(any)).thenReturn(0.9);
      when(mockAnimationService.calculateOpacity(any)).thenReturn(0.8);

      controller.onVerticalDragUpdate(dragDetails, const Size(400, 800));

      // Act
      controller.resetGestureState();

      // Assert
      expect(controller.gestureState, equals(PhotoGestureState.initial()));
    });
  });
}
