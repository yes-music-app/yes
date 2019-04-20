import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:yes_music/models/spotify/token_model.dart';

/// The redirect uri that will be the prefix for a valid url to navigate from.
const String REDIRECT_URI = "yes-music-app://connect";

/// The type of method that can be used to act upon a successful login.
typedef SuccessCallback = Function(String);

/// Show the Spotify authorization screen.
void showAuthWebView(
  String url, {
  @required SuccessCallback onSuccess,
  @required VoidCallback onFail,
}) {
  final webView = FlutterWebviewPlugin();

  /// Subscribe to url changes.
  StreamSubscription streamSub;
  streamSub = webView.onUrlChanged.listen((String url) {
    switch (_isSuccessUrl(url, _getState(url))) {
      case -1:
        break;
      case 1:
        webView.close();
        streamSub.cancel();
        onSuccess(_getCode(url));
        break;
      case 0:
        webView.close();
        streamSub.cancel();
        onFail();
        break;
      default:
        break;
    }
  });

  /// Close any open instances of the web view and then launch it.
  webView.close();
  webView.launch(url);
}

/// Checks whether the url that is navigated to is a successful url or not.
int _isSuccessUrl(String url, String state) {
  if (!url.startsWith(REDIRECT_URI)) {
    // If we were not redirected to a final state, proceed.
    return -1;
  }

  final List<String> urlParts = url.split("/?");
  if (urlParts.length < 1) {
    // If we received an incomplete query string, return an error state.
    return 0;
  }

  final String queryString = urlParts[1];

  if (!queryString.contains("code")) {
    // If we were directed to an error state, proceed.
    return 0;
  }

  if (_getState(queryString) != state) {
    // If we did not receive the same state, return an error state.
    return 0;
  }

  return 1;
}

/// Gets the state string from a given url.
String _getState(String url) {
  final List<String> urlParts = url.split("state=");
  if (urlParts.length < 1) {
    return "";
  }

  return urlParts[1].split("&")[0];
}

/// Gets the authorization code from the given url.
String _getCode(String url) {
  final List<String> urlParts = url.split("code=");
  if (urlParts.length < 1) {
    return "";
  }

  return urlParts[1].split("&")[0];
}
