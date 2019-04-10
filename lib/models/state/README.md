# Database Schema

This app uses the [Firebase Realtime Database](https://firebase.google.com/docs/database/) offering from Google.

## Schema

The schema for this database is as follows:

```json
{
  "sessions": {
    "$session-id": {
      "playerState": ...,
      "queue": [
        ...
      ],
      "history": [
        ...
      ],
      "host": ...,
      "users": {
        "$user-uid-0": ...,
        "$user-uid-1": ...,
        ...
      },
      "tokens": {
        "authorizationCode": "...",
        "accessToken": "...",
        "refreshToken": "..."
      }
    }
  }
}
```

Note: the `tokens` object is not reflected in the Dart `session_model`, and is used by [Firebase Functions](https://firebase.google.com/docs/functions/) for [Spotify authorization](https://developer.spotify.com/documentation/general/guides/authorization-guide/#authorization-code-flow).