import 'package:flutter_test/flutter_test.dart';
import 'package:yes_music/feature_flags/flag_provider.dart';

void main() {
  test("Null key returns false", () {
    expect(new FlagProvider().getFlag(null), false);
  });
}