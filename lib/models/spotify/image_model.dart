/// A data model representing an image retrieved from the Spotify web API.
class ImageModel {
  final int height;
  final int width;
  final String url;

  ImageModel.fromMap(Map map)
      : height = map["height"],
        width = map["width"],
        url = map["url"];

  static List<ImageModel> mapImages(List images) {
    if (images == null) {
      return images;
    }

    return images.map((image) => ImageModel.fromMap(image)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      "height": height,
      "width": width,
      "url": url,
    };
  }

  static List<Map<String, dynamic>> toMapList(List<ImageModel> models) {
    return models?.map((model) => model.toMap())?.toList();
  }
}
