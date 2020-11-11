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
