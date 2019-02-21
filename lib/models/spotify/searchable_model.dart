abstract class SearchableModel {
  Map<String, dynamic> toMap();

  SearchableModel.fromMap(Map map) {
    throw new UnimplementedError(
        "Searchable fromMap constructor not implemented.");
  }
}
