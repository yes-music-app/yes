# Spotify Data Models

These data models are direct mappings from Spotify objects.

The conversions between Dart values and Android and IOS values are mapped out in [this article](https://flutter.io/docs/development/platform-integration/platform-channels).

A standard data model should have:
 - a set of immutable fields that map directly to the corresponding Spotify model.
 - a named `fromMap(Map map)` constructor that creates an instance of the model from a `Map` as received from the Spotify APIs.
 
In the case of nested models (ie: a `TrackModel` contains an `ArtistModel`), expect the relevant key's corresponding value to be another `Map` matching the schema of the contained model.

For example, a track model will have:
```
{
    keys: values,
    ...: ...,
    artist: {
        keys: values,
    }
}
```

Thus, the best practice for parsing such objects is to use the named constructor of the contained data model.

For example, to parse a track model, the named constructor in `TrackModel` should be formed as:
```
TrackModel.fromMap(Map map)
  : this.field = map['key'],
    ... = ...,
    this.artist = ArtistModel.fromMap(map['artist']);
```