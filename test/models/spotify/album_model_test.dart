import 'package:flutter_test/flutter_test.dart';
import 'package:yes_music/models/spotify/album_model.dart';

import 'mock_album_model.dart';

void main() {
  test("Should be created from map", () {
    final AlbumModel album = new AlbumModel.fromMap(testAlbumGeneric);

    expect(album.name, "test_name");
    expect(album.uri, "test_uri");
    expect(album.id, "test_id");
    expect(album.images, isNot(null));
  });
}