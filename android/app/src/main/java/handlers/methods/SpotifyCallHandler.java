package handlers.methods;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class SpotifyCallHandler implements MethodCallHandler {

  @Override
  public void onMethodCall(MethodCall methodCall, Result result) {
    switch (methodCall.method) {
      case "login":
        break;
      default:
        result.notImplemented();
        break;
    }
  }
}
