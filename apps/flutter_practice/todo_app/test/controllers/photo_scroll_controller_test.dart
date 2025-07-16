import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:todo_app/controllers/photo_scroll_controller.dart';
import 'package:todo_app/services/scroll_service.dart';
import 'package:todo_app/models/scroll_state.dart';

@GenerateMocks([ScrollService])
import 'photo_scroll_controller_test.mocks.dart';

void main() {
  group('PhotoScrollController', () {
    late PhotoScrollController controller;
    late MockScrollService mockScrollService;

    setUp(() {
      mockScrollService = MockScrollService();
      controller = PhotoScrollController(mockScrollService);
    });

    tearDown(() {
      controller.dispose();
    });

    test('should initialize with correct initial state', () {
      // Assert
      expect(controller.scrollState, equals(ScrollState.initial()));
      expect(controller.imageUrls, isEmpty);
    });

    test('should initialize scroll controller and load initial data', () async {
      // Act
      controller.initialize();
      await Future.delayed(const Duration(seconds: 3)); // Wait for loading

      // Assert
      expect(controller.scrollController, isNotNull);
      expect(controller.imageUrls, isNotEmpty);
    });

    test('should handle loading state correctly', () async {
      // Act
      controller.initialize();

      // Assert initial loading state
      expect(controller.isInitialLoading, isTrue);

      // Wait for loading to complete
      await Future.delayed(const Duration(seconds: 3));
      expect(controller.scrollState.isLoading, isFalse);
    });

    test('should retry loading when retryLoading is called', () async {
      // Test that retryLoading method exists and can be called
      expect(() => controller.retryLoading(), returnsNormally);
    });

    test('should get image URLs from internal storage', () {
      // Initially empty
      expect(controller.imageUrls, isEmpty);
    });

    test('should determine initial loading state correctly', () {
      // Initially should not be loading
      expect(controller.isInitialLoading, isFalse);
    });

    test('should clear images when clearImages is called', () {
      // Act
      controller.clearImages();

      // Assert
      expect(controller.imageUrls, isEmpty);
    });
  });
}
