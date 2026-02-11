import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tryon/shared/widgets/empty_state.dart';

void main() {
  group('EmptyState Widget Tests', () {
    testWidgets('renders icon and title correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.inbox,
              title: 'No items found',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.inbox), findsOneWidget);
      expect(find.text('No items found'), findsOneWidget);
    });

    testWidgets('renders subtitle when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.inbox,
              title: 'No items found',
              subtitle: 'Try adjusting your search',
            ),
          ),
        ),
      );

      expect(find.text('No items found'), findsOneWidget);
      expect(find.text('Try adjusting your search'), findsOneWidget);
    });

    testWidgets('renders action button when provided', (WidgetTester tester) async {
      bool actionPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.inbox,
              title: 'No items found',
              action: ElevatedButton(
                onPressed: () {
                  actionPressed = true;
                },
                child: const Text('Add Item'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Add Item'), findsOneWidget);
      
      await tester.tap(find.text('Add Item'));
      expect(actionPressed, true);
    });

    testWidgets('applies custom icon color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.inbox,
              title: 'No items found',
              iconColor: Colors.red,
            ),
          ),
        ),
      );

      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.inbox));
      expect(iconWidget.color, Colors.red);
    });

    testWidgets('centers content correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.inbox,
              title: 'No items found',
            ),
          ),
        ),
      );

      expect(find.byType(Center), findsOneWidget);
    });
  });
}