# Yes Music App Spotify API

Outlined below is a description of the methods that should be supported by native code that intends to interface with the Yes music app.

### Channels

 - Connection: `yes.yesmusic/connection`
 - Playback: `yes.yesmusic/playback`

### Connection

##### Method Calls

| Method     | Arguments | Return | Description                             |
|------------|-----------|--------|-----------------------------------------|
| connect    | N/A       | N/A    | Connects to the Spotify Remote API      |
| disconnect | N/A       | N/A    | Disconnects from the Spotify Remote API |

##### Method Callbacks

| Method            | Arguments | Return | Description                                      |
|-------------------|-----------|--------|--------------------------------------------------|
| connectionUpdate  | int       | N/A    | Provides the most recent connection state change |

### Playback

##### Method Calls

| Method                     | Arguments | Return | Description                                                                                              |
|----------------------------|-----------|--------|----------------------------------------------------------------------------------------------------------|
| subscribeToPlayerState     | N/A       | N/A    | Creates a subscription to player state changes, causing the `updatePlayerState` callback to begin firing |
| unsubscribeFromPlayerState | N/A       | N/A    | Unsubscribes from player state changes                                                                   |

##### Method Callbacks

| Method            | Arguments                                      | Return | Description                                                         |
|-------------------|------------------------------------------------|--------|---------------------------------------------------------------------|
| updatePlayerState | Map: a map representing a `PlayerState` object | N/A    | The handler for a player state update, receives a map of the object |

