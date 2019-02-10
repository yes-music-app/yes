# Yes Music App Spotify API

Outlined below is a description of the methods that should be supported by native code that intends to interface with the Yes music app.

### Channels

 - Connection: `yes.yesmusic/connection`
 - Playback: `yes.yesmusic/playback`

### Connection

##### Method Calls

| Method     | Arguments | Return                                 | Description                             |
|------------|-----------|----------------------------------------|-----------------------------------------|
| connect    | N/A       | int: whether or not the call succeeded | Connects to the Spotify Remote API      |
| disconnect | N/A       | int: whether or not the call succeeded | Disconnects from the Spotify Remote API |

##### Method Callbacks

N/A

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

