import 'package:bloc_test/bloc_test.dart';
import 'package:bunnybondz/bunny_bonds/bunny_bonds.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BunnyBondCubit', () {
    blocTest<BunnyBondCubit, BunnyBondState>(
      'authenticates the demo user',
      build: BunnyBondCubit.new,
      act: (cubit) {
        cubit
          ..usernameChanged('user123')
          ..passwordChanged('123456')
          ..login();
      },
      verify: (cubit) => expect(cubit.state.isAuthenticated, isTrue),
    );

    blocTest<BunnyBondCubit, BunnyBondState>(
      'rejects invalid credentials',
      build: BunnyBondCubit.new,
      act: (cubit) {
        cubit
          ..usernameChanged('wrong')
          ..passwordChanged('password')
          ..login();
      },
      verify: (cubit) => expect(cubit.state.loginError, isNotNull),
    );
  });
}
