import 'package:flutter_test/flutter_test.dart';
import 'package:yes_music/helpers/list_utils.dart';

void main() {
  test("Null lists should compare to false", () {
    const list0 = null;
    const list1 = null;
    const list2 = [1, 2, 3];

    expect(listsEqual(list0, list1), false);
    expect(listsEqual(list0, list2), false);
  });

  test("Different lists should compare to false", () {
    const list0 = [1, 2, 3];
    const list1 = [1, 2, 3, 4];
    const list2 = [3, 2, 1];

    expect(listsEqual(list0, list1), false);
    expect(listsEqual(list0, list2), false);
  });

  test("Equal lists should compare to true", () {
    const list0 = [1, 2, 3];
    const list1 = [1, 2, 3];

    expect(listsEqual(list0, list1), true);
  });
}