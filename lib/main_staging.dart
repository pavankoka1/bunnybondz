import 'package:bunnybondz/app/app.dart';
import 'package:bunnybondz/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
