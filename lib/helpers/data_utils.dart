import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:yes_music/models/spotify/token_model.dart';
import 'package:yes_music/models/state/session_model.dart';

/// Checks whether a session with the give [sid] exists in the database.
Future<bool> sessionExists(String sid) async {
  // Get a snapshot of the session.
  final DataSnapshot snapshot = await FirebaseDatabase.instance
      .reference()
      .child(SESSION_PATH)
      .child(sid)
      .once();

  return snapshot?.value != null;
}

/// Generates a unique session ID.
Future<String> generateSID() async {
  String sid;

  do {
    Random random = Random();

    List<int> codes = [];
    for (int i = 0; i < 6; i++) {
      int code = random.nextInt(36);
      if (code < 10) {
        code += 48;
      } else {
        code += 55;
      }
      codes.add(code);
    }

    sid = String.fromCharCodes(codes);

    // If this session already exists, generate another sid.
    if (await sessionExists(sid)) {
      sid = null;
    }
  } while (sid == null);

  return sid;
}

/// Generate a [TokenModel] based on data retrieved from the Spotify endpoints.
TokenModel generateModel(Map data) {
  if (data == null ||
      data["access_token"] == null ||
      data["refresh_token"] == null) {
    throw StateError("errors.spotify.auth_cancel");
  }
  return TokenModel.initial(data["access_token"], data["refresh_token"]);
}
