import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:yes_music/components/common/loading_indicator.dart';

Widget getWebView(String url) {
  return WebviewScaffold(
    url: url,
    initialChild: loadingIndicator(),
  );
}

typedef UrlCallback = bool Function(String);

/// Show the Spotify authorization screen.
void showAuthWebView(String url, UrlCallback callback) {
  final webView = FlutterWebviewPlugin();
  bool closing = false;

  /// Subscribe to url changes.
  StreamSubscription streamSub;
  streamSub = webView.onUrlChanged.listen((String url) {
    if (!closing && callback(url)) {
      // If we have completed the auth flow, close the web view.
      closing = true;
      webView.close();
      streamSub.cancel();
    }
  });

  /// Close any open instances of the web view and then launch it.
  webView.close();
  webView.launch(url);
}
