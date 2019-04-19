import 'package:flutter/widgets.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:yes_music/components/common/loading_indicator.dart';

Widget getWebView(String url) {
  return WebviewScaffold(
    url: url,
    initialChild: loadingIndicator(),
  );
}
