/// A data model representing an image retrieved from the Spotify web API.
class ImageModel {
  final int height;
  final int width;
  final String url;

  ImageModel.fromMap(Map map)
      : height = map['height'],
        width = map['width'],
        url = map['url'];

  static List<ImageModel> mapImages(List images) {
    if (images == null) {
      return images;
    }

    return images.map((image) => new ImageModel.fromMap(image)).toList();
  }
}
