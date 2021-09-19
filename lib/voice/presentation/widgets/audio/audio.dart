import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' as Rx;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:voice_note/voice/domain/entities/audio.dart';
import 'package:voice_note/voice/domain/use_cases/constant_data.dart';
import 'package:voice_note/voice/presentation/widgets/audio/seek_bar.dart';
import 'package:voice_note/voice/presentation/widgets/loading_widget.dart';

class AudioWidget extends StatefulWidget {
  AudioWidget(
      {Key? key,
      this.audio = "",
      this.link = "",
      required this.type,
      required this.index,
      required this.selectedIndex,
      required this.selected})
      : super(key: key);
  String audio;
  String link;
  TypeAudio type;
  ValueChanged<int> selectedIndex;
  int index;
  int selected;

  @override
  _AudioWidgetState createState() {
    return _AudioWidgetState();
  }
}

class _AudioWidgetState extends State<AudioWidget> with WidgetsBindingObserver {
  final _player = AudioPlayer();
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
  }

  Future<void> _init() async {
    print('init');
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {
      print('event::::::: $event');
    }, onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    // Try to load audio from a source and catch any errors.
    try {
      if (widget.type == TypeAudio.link) {
        await _player.setAudioSource(AudioSource.uri(Uri.parse(widget.link)));
      } else {
        await _player.setFilePath(widget.audio);
      }
      loaded = true;
      widget.selectedIndex(widget.index);
      _player.play();
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  @override
  void didUpdateWidget(oldWidget) {
    if (widget.selected != widget.index) {
      _player.pause();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    _player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      _player.stop();
    }
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get _positionDataStream =>
      Rx.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return Container(
      //  decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Row(
        children: [
          // Display play/pause button and volume/speed sliders.
          StreamBuilder<PlaybackEvent>(
            stream: _player.playbackEventStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
               if(processingState == ProcessingState.idle){
                      return IconButton(
                        icon: Icon(Icons.play_arrow),
                        iconSize: 64.0,
                        onPressed: _init,
                      );
                    }else
              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return Container(
                  margin: EdgeInsets.all(8.0),
                  width: 64.0,
                  height: 64.0,
                  child: loadingContainer(),
                );
              } else if (_player.playing != true) {
                return IconButton(
                  icon: Icon(Icons.play_arrow),
                  iconSize: 64.0,
                  onPressed: () {
                    widget.selectedIndex(widget.index);
                    _player.play();
                  },
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  icon: Icon(Icons.pause),
                  iconSize: 64.0,
                  onPressed: _player.pause,
                );
              } else {
                _player.seek(Duration.zero);
                _player.stop();
                return IconButton(
                  icon: Icon(Icons.replay),
                  iconSize: 64.0,
                  onPressed: () => _player.seek(Duration.zero),
                );
              }
            },
          ),
          // Display seek bar. Using StreamBuilder, this widget rebuilds
          // each time the position, buffered position or duration changes.
          Expanded(
            child: StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return SeekBar(
                  duration: positionData?.duration ?? Duration.zero,
                  position: positionData?.position ?? Duration.zero,
                  bufferedPosition:
                      positionData?.bufferedPosition ?? Duration.zero,
                  onChangeEnd: _player.seek,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
