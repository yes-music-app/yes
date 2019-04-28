import 'package:flutter_test/flutter_test.dart';
import 'package:yes_music/options/flag_provider.dart';

void main() {
  test("Null key returns false", () {
    expect(FlagProvider().getFlag(null), false);
  });
}