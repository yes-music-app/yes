/// Tests to see whether two lists are equal.
bool listsEqual<T>(List<T> l1, List<T> l2) {
  if (l1 == null || l2 == null || l1.length != l2.length) {
    return false;
  }

  for (int i = 0; i < l1.length; i++) {
    if (l1[i] != l2[i]) {
      return false;
    }
  }

  return true;
}

/// Converts a dynamic list into a list of strings.
List<String> listToString(List<dynamic> list) {
  return list?.map<String>((dynamic element) => element.toString())?.toList();
}
