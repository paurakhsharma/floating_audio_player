## Floating Audio Player in Flutter

Today, we are going to learn how to build a floating audio player in Flutter. This method is not limited to the audio player but can use used for the video player as well.

![Floating Audio Player](https://dev-to-uploads.s3.amazonaws.com/i/vbiscrn7zvro8vpqr6rs.gif)

First of all, let's create a new flutter project.

```
flutter create floating_audio_player
```

Replace all the codes in `main.dart` with the following:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Floating media player')),
      body: ListView.builder(itemBuilder: (context, index) {
        return Card(
          child: Container(
            height: 200,
            child: Center(
                child: Text(
              'Item $index',
              style: TextStyle(
                color: index.isEven ? Colors.white : Colors.green,
              ),
            )),
          ),
          color: index.isEven ? Colors.green : Colors.white70,
        );
      }),
    );
  }
}

```

Here we are rendering an infinite list with cards inside for demonstration purposes only.

![Infinite ListView](https://dev-to-uploads.s3.amazonaws.com/i/xbe18d9x5wiq1a0174vw.png)

Now we are going to create a FAB (Floating Action Button) which can transform into a container. We are going to use [AnimationSwitcher](https://api.flutter.dev/flutter/widgets/AnimatedSwitcher-class.html) for a slick animation.

Update your `main.dart` and add `floatingActionButton`
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isPlayerOpened = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Floating media player')),
      body: ListView.builder(itemBuilder: (context, index) {
        return Card(
          child: Container(
            height: 200,
            child: Center(
                child: Text(
              'Item $index',
              style: TextStyle(
                color: index.isEven ? Colors.white : Colors.green,
              ),
            )),
          ),
          color: index.isEven ? Colors.green : Colors.white70,
        );
      }),
      floatingActionButton: floatingActionItem,
    );
  }

  get floatingActionItem {
    Widget floatingPlayer = GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 35,),
          Container(
            height: 125,
            width: 325,
            color: Colors.teal,
          ),
        ],
      ),
      onTap: () {
        setState(() {
          isPlayerOpened = false;
        });
      },
    );

    Widget floatingActionButton = FloatingActionButton(
      onPressed: () {
        setState(() {
          isPlayerOpened = true;
        });
      },
      child: Icon(Icons.play_arrow_outlined),
    );

    return AnimatedSwitcher(
      reverseDuration: Duration(milliseconds: 0),
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(child: child, scale: animation);
      },
      child: isPlayerOpened ? floatingPlayer : floatingActionButton,
    );
  }
}

```

A `bool` `isPlayerOpened` is used to show a play button or a container using an `AnimatedSwitcher`.

![AnimatedSwitcher](https://dev-to-uploads.s3.amazonaws.com/i/fzryg2hvaevs1sjlml5g.gif)

Let's move the floating audio player code into `FloatingAudioPlayer.dart`, add the following code inside it to show a player UI.

```dart
// floating_audio_player.dart

import 'package:flutter/material.dart';

class FloatingAudioPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 35),
        Container(
            height: 75,
            width: 325,
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: [
                pauseButton(),
                Expanded(child: progressSlider()),
              ],
            )),
      ],
    );
  }

  Widget pauseButton() {
    return IconButton(
      icon: Icon(Icons.pause_outlined),
      onPressed: pause,
    );
  }

  pause() {}

  Widget progressSlider() {
    const textStyle = TextStyle(color: Colors.white);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('00:00', style: textStyle),
              Text('10:10', style: textStyle),
            ],
          ),
        ),
        SizedBox(
          width: 300,
          height: 25,
          child: Slider(
            min: 0,
            max: 280,
            value: 150,
            activeColor: Colors.white,
            inactiveColor: Colors.grey,
            onChanged: (value) {},
          ),
        )
      ],
    );
  }
}
```

Make sure you replace child inside `GestureDetector()`  in `main.dart` with newly created `FloatingAudioPlayer()`.

<!-- screenshot 2 -->

Finally, we are going to implement playing audio. For this I am using [just_audio](https://pub.dev/packages/just_audio), you can use your favorite audio player.

Add `just_audio: ^0.5.6` in your `pubspec.yml`'s `dependencies`.

*Note: Make sure you restart your app after installing dependency which uses platform channels.*

- For iOS: Make sure you add the following inside your `Info.plist` file. Even though we do not use the Microphone, iOS requires us to add this.
```plist
<key>NSMicrophoneUsageDescription</key>
<string>... explain why you use (or don't use) the microphone ...</string>
```

Update `floating_audio_player.dart` and all audio playing functionality.

```dart
// floating_audio_player.dart

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class FloatingAudioPlayer extends StatefulWidget {
  final Function onPaused;
  FloatingAudioPlayer({@required this.onPaused});
  @override
  _FloatingAudioPlayerState createState() => _FloatingAudioPlayerState();
}

class _FloatingAudioPlayerState extends State<FloatingAudioPlayer> {
  Duration _duration;
  AudioPlayer _audioPlayer;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 35),
        Container(
          height: 75,
          width: 325,
          decoration: BoxDecoration(
            color: Colors.teal.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: StreamBuilder(
            stream: _audioPlayer.positionStream,
            builder: (context, snapshot) {
              if (snapshot.hasData && _duration != null) {
                if (_audioPlayer.processingState == ProcessingState.completed) {
                  _audioPlayer.stop();
                  Future.delayed(Duration(seconds: 0), widget.onPaused);
                }
                return Row(
                  children: [
                    if (_audioPlayer.playerState.playing)
                      pauseButton()
                    else
                      playButton(),
                    Expanded(child: progressSlider(snapshot.data)),
                  ],
                );
              }

              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

  Widget playButton() {
    return IconButton(
      icon: Icon(Icons.play_arrow_outlined),
      onPressed: playAudio,
      iconSize: 34,
      color: Colors.white,
    );
  }

  Widget pauseButton() {
    return IconButton(
      icon: Icon(Icons.pause_outlined),
      onPressed: pause,
      iconSize: 34,
      color: Colors.white,
    );
  }

  pause() {
    _audioPlayer.pause();
    Future.delayed(Duration(milliseconds: 500), widget.onPaused);
  }

  Widget progressSlider(Duration position) {
    const textStyle = TextStyle(color: Colors.white);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(position.toString().substring(2, 7), style: textStyle),
              Text(_duration.toString().substring(2, 7), style: textStyle),
            ],
          ),
        ),
        SizedBox(
          width: 300,
          height: 25,
          child: Slider(
            min: 0,
            max: _duration.inMilliseconds.toDouble(),
            value: position.inMilliseconds.toDouble(),
            activeColor: Colors.white,
            inactiveColor: Colors.grey,
            onChanged: (value) {
              _audioPlayer.seek(Duration(milliseconds: value.floor()));
            },
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    initAudio();
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer?.dispose();
  }

  initAudio() async {
    _audioPlayer = AudioPlayer();
    final duration = await _audioPlayer.setUrl(
      'https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3',
    );

    setState(() {
      _duration = duration;
    });

    playAudio();
  }

  playAudio() {
    _audioPlayer.play();
  }
}
```

Here `onPaused` is passed inside the `FloatingAudioPlayer()` widget so that when the user pauses the audio or the audio is played completely, the floating audio player is closed.

Likewise, we need to update our `main.dart` to implement `onPaused`

```dart
// main.dart

import 'package:flutter/material.dart';

import 'floating_audio_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isPlayerOpened = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Floating media player')),
      body: ListView.builder(itemBuilder: (context, index) {
        return Card(
          child: Container(
            height: 200,
            child: Center(
                child: Text(
              'Item $index',
              style: TextStyle(
                color: index.isEven ? Colors.white : Colors.green,
              ),
            )),
          ),
          color: index.isEven ? Colors.green : Colors.white70,
        );
      }),
      floatingActionButton: floatingActionItem,
    );
  }

  onPaused() {
    setState(() {
      isPlayerOpened = false;
    });
  }

  get floatingActionItem {
    Widget floatingPlayer = FloatingAudioPlayer(onPaused: onPaused);

    Widget floatingActionButton = FloatingActionButton(
      onPressed: () {
        setState(() {
          isPlayerOpened = true;
        });
      },
      child: Icon(Icons.play_arrow_outlined),
    );

    return AnimatedSwitcher(
      reverseDuration: Duration(milliseconds: 0),
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(child: child, scale: animation);
      },
      child: isPlayerOpened ? floatingPlayer : floatingActionButton,
    );
  }
}
```

![Floating Audio Player](https://dev-to-uploads.s3.amazonaws.com/i/vbiscrn7zvro8vpqr6rs.gif)

That's it 🎉🥳, we have created a floating audio player. As mentioned earlier this is not limited to the audio player but can be used for anything.

**Now go and create awesome stuff with it.**

You can find the source code [here](github.com)

If you have any suggestions or comments feel free to write down in the comment section, follow me on Twitter [@PaurakhSharma](https://twitter.com/PaurakhSharma) for new contents or to suggest one ;)

Happy Coding!



