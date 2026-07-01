import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_advanced_course/chart_demo/widgets/bar_chart/bar_chart_painter.dart';
import 'package:flutter_advanced_course/chart_demo/models/bar_item_data.dart';

void main() {
  group('BarColumnPainter Tests', () {
    const defaultItem = BarItemData(
      label: 'T1',
      value: 60,
      secondaryValue: 20,
      maxValue: 100,
      color: Colors.blue,
      valueLabel: '60%',
    );

    const boundaryKey = Key('painter_boundary');

    testWidgets(
      'BarColumnPainter renders correctly at 100% growProgress - Golden Test',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: RepaintBoundary(
                  key: boundaryKey,
                  child: SizedBox(
                    width: 50,
                    height: 200,
                    child: CustomPaint(
                      painter: BarColumnPainter(
                        item: defaultItem,
                        growProgress: 1.0,
                        primaryRatio: defaultItem.primaryRatio,
                        totalRatio: defaultItem.totalRatio,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        await expectLater(
          find.byKey(boundaryKey),
          matchesGoldenFile('goldens/bar_column_painter_100_percent.png'),
        );
      },
      skip: !Platform.isMacOS,
    );

    testWidgets(
      'BarColumnPainter renders correctly at 50% growProgress - Golden Test',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: RepaintBoundary(
                  key: boundaryKey,
                  child: SizedBox(
                    width: 50,
                    height: 200,
                    child: CustomPaint(
                      painter: BarColumnPainter(
                        item: defaultItem,
                        growProgress: 0.5,
                        primaryRatio: defaultItem.primaryRatio,
                        totalRatio: defaultItem.totalRatio,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        await expectLater(
          find.byKey(boundaryKey),
          matchesGoldenFile('goldens/bar_column_painter_50_percent.png'),
        );
      },
      skip: !Platform.isMacOS,
    );

    testWidgets(
      'BarColumnPainter renders correctly with no secondary value - Golden Test',
      (WidgetTester tester) async {
        const itemNoSecondary = BarItemData(
          label: 'T2',
          value: 80,
          maxValue: 100,
          color: Colors.red,
          valueLabel: '80%',
        );

        await tester.pumpWidget(
          MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: RepaintBoundary(
                  key: boundaryKey,
                  child: SizedBox(
                    width: 50,
                    height: 200,
                    child: CustomPaint(
                      painter: BarColumnPainter(
                        item: itemNoSecondary,
                        growProgress: 1.0,
                        primaryRatio: itemNoSecondary.primaryRatio,
                        totalRatio: itemNoSecondary.totalRatio,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        await expectLater(
          find.byKey(boundaryKey),
          matchesGoldenFile('goldens/bar_column_painter_no_secondary.png'),
        );
      },
      skip: !Platform.isMacOS,
    );

    group('CustomPainter shouldRepaint logic', () {
      test('returns true when growProgress changes', () {
        final painter1 = BarColumnPainter(
          item: defaultItem,
          growProgress: 0.5,
          primaryRatio: 0.6,
          totalRatio: 0.8,
        );

        final painter2 = BarColumnPainter(
          item: defaultItem,
          growProgress: 1.0,
          primaryRatio: 0.6,
          totalRatio: 0.8,
        );

        expect(painter2.shouldRepaint(painter1), isTrue);
      });

      test('returns true when primaryRatio changes', () {
        final painter1 = BarColumnPainter(
          item: defaultItem,
          growProgress: 1.0,
          primaryRatio: 0.6,
          totalRatio: 0.8,
        );

        final painter2 = BarColumnPainter(
          item: defaultItem,
          growProgress: 1.0,
          primaryRatio: 0.7,
          totalRatio: 0.8,
        );

        expect(painter2.shouldRepaint(painter1), isTrue);
      });

      test('returns true when item changes', () {
        final painter1 = BarColumnPainter(
          item: defaultItem,
          growProgress: 1.0,
          primaryRatio: 0.6,
          totalRatio: 0.8,
        );

        final painter2 = BarColumnPainter(
          item: defaultItem.copyWith(value: 40), // Change item value
          growProgress: 1.0,
          primaryRatio: 0.6,
          totalRatio: 0.8,
        );

        expect(painter2.shouldRepaint(painter1), isTrue);
      });

      test('returns false when identical properties are provided', () {
        final painter1 = BarColumnPainter(
          item: defaultItem,
          growProgress: 1.0,
          primaryRatio: 0.6,
          totalRatio: 0.8,
        );

        final painter2 = BarColumnPainter(
          item: defaultItem, // Same identity, conceptually equal
          growProgress: 1.0,
          primaryRatio: 0.6,
          totalRatio: 0.8,
        );

        expect(painter2.shouldRepaint(painter1), isFalse);
      });
    });
  });
}
