[![Build Status](https://travis-ci.com/yes-music-app/yes.svg?branch=master)](https://travis-ci.com/yes-music-app/yes) [![Coverage Status](https://coveralls.io/repos/github/yes-music-app/yes/badge.svg?branch=master)](https://coveralls.io/github/yes-music-app/yes?branch=master)

# Yes Music

The Yes music app.

## Getting Started

1. Install Flutter (linked [here](https://flutter.io/docs/get-started/install))
2. Clone this repository to your local machine.
3. Open the root directory as a project in your IDE of choice (IntelliJ recommended).
4. Set up the Dart SDK for the editor that you are using.
5. In a shell, run `flutter packages get` followed by `flutter packages upgrade` in the root directory.
6. Make a copy of the `google-services.example.json` file found at `/android/app/` and name it `google-services.json`; 
populate the fields with the correct information (ask Jaewon for the information). 
7. Make a copy of the `ExampleItems.java` file found at `android/app/src/main/java/com/yes/yesmusic/methods/spotify/`,
rename it to `Items.java`, and populate the fields with the correct information.
8. Install the `flutter` and `dart` plugins for your IDE.
9. Add your debug SHA-1 fingerprint to Firebase and Spotify.
10. Migrate your android project to androidx.
