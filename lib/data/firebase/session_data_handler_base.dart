import 'package:yes_music/models/state/session_model.dart';

abstract class SessionDataHandlerBase {
  /// Gets a [SessionModel] stream for the given [sid].
  Future<Stream<SessionModel>> getSessionModelStream(String sid);
}
