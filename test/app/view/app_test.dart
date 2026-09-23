// Ignore for testing purposes
// ignore_for_file: prefer_const_constructors

import 'package:bunnybondz/app/app.dart';
import 'package:bunnybondz/bunny_bonds/bunny_bonds.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App', () {
    testWidgets('renders BunnyBondsPage', (tester) async {
      await tester.pumpWidget(App());
      expect(find.byType(BunnyBondsPage), findsOneWidget);
    });
  });
}
