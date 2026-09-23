import 'package:bunnybondz/bunny_bonds/bunny_bonds.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  testWidgets('logs in and opens the nearby bonds screen', (tester) async {
    await tester.pumpApp(const BunnyBondsPage());

    await tester.enterText(find.byKey(const Key('usernameField')), 'user123');
    await tester.enterText(find.byKey(const Key('passwordField')), '123456');
    await tester.tap(find.byKey(const Key('loginButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('nearbyBondsScreen')), findsOneWidget);
    expect(find.text("What's happening nearby?"), findsOneWidget);
    expect(find.byKey(const Key('createBondButton')), findsOneWidget);
    expect(find.text('Create Bond'), findsNothing);
  });
}
