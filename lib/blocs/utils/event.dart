/// An event with a [type] and a [payload]. The [type] of the event indicates
/// the purpose of the event. The [payload] of the event includes data that
/// provides context for the event.
class Event<T, P> {
  /// The type of this event.
  final T type;

  /// This event's payload.
  final P payload;

  /// Creates a new [Event] with the given [type] and [payload].
  Event(this.type, this.payload);
}
