package handlers;

import android.app.Activity;
import com.spotify.android.appremote.api.ConnectionParams;
import com.spotify.android.appremote.api.Connector.ConnectionListener;
import com.spotify.android.appremote.api.SpotifyAppRemote;

/**
 * A class that manages the connection between the yes music app and the Spotify app.
 */
class ConnectionHandler {

  private static ConnectionHandler instance = null;

  public static ConnectionHandler getInstance() {
    if (instance == null) {
      instance = new ConnectionHandler();
    }

    return instance;
  }

  private ConnectionHandler() {}

  private SpotifyAppRemote spotifyAppRemote;
  private ConnectionParams connectionParams;
  private final ConnectionListener connectionListener = new ConnectionListener() {
    @Override
    public void onConnected(SpotifyAppRemote spotifyAppRemote) {

    }

    @Override
    public void onFailure(Throwable throwable) {

    }
  };

  protected void setupConnection(Activity activity) {
    SpotifyAppRemote.disconnect(spotifyAppRemote);
    SpotifyAppRemote.connect(activity, connectionParams, connectionListener);
  }

  protected void disconnect() {
    SpotifyAppRemote.disconnect(spotifyAppRemote);
  }
}
