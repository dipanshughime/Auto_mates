import 'package:automates/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
// import 'package:record/record.dart';

// import 'package:record_example/audio_player.dart';
// import 'package:record_example/audio_recorder.dart';
// import 'dart:async';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:just_audio/just_audio.dart' as ja;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isRecording = false;
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  // bool _isRecording = false;
  late String _filePath;

  Future<void> _init() async {
    var status = await Permission.microphone.request();
    await _recorder.openRecorder();
  }

  // Future<void> _startRecording() async {
  //   try {
  //     await _recorder.openRecorder();
  //     final directory = await getApplicationDocumentsDirectory();
  //     setState(() {
  //       _filePath = '${directory.path}/audio.wav';
  //     });
  //     await _recorder!.startRecorder(
  //       toFile: _filePath, // Change the file extension to .mp3
  //       codec: Codec.pcm16WAV, // Use PCM codec
  //     );
  //     setState(() {
  //       _isRecording = true;
  //     });
  //   } catch (err) {
  //     print('Recording error: $err');
  //   }
  // }

  // Future<void> _stopRecording() async {
  //   try {
  //     await _recorder!.stopRecorder();
  //     setState(() {
  //       _isRecording = false;
  //     });
  //     print('Audio recorded and saved to: $_filePath');
  //   } catch (err) {
  //     print('Stop recording error: $err');
  //   }
  // }

  @override
  void dispose() {
    _recorder!.closeRecorder();
    // _recorder = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // _initSensors();
    // _recorder = FlutterSoundRecorder();
    _init();
    _loadFiles();
  }

  // void _initSensors() {
  //   accelerometerEvents.listen((AccelerometerEvent event) {
  //     if (_isShaking(event)) {
  //       print("hhhhhhhh shake");
  //       if (!_isRecording) {
  //         _startRecording();
  //       } else if (_isRecording) {
  //         _stopRecording();
  //       }
  //     } else {
  //       // if (_isRecording) {
  //       //   _stopRecording();
  //       // }
  //     }
  //   });
  // }

  // bool _isShaking(AccelerometerEvent event) {
  //   const double shakeThreshold = 20; // Adjust as needed
  //   return event.x.abs() >= shakeThreshold ||
  //       event.y.abs() >= shakeThreshold ||
  //       event.z.abs() >= shakeThreshold;
  // }

  // Future<void> _startRecording() async {
  //   try {AudioRecord
  //     // if (await AudioRecorder.hasPermissions) {
  //     // await AudioRecorder.start();
  //     setState(() {
  //       _isRecording = true;
  //     });
  //   } catch (e) {
  //     // Handle errors
  //     print(e);
  //   }
  // }

  // Future<void> _stopRecording() async {
  //   try {
  //     // Recording recording = await AudioRecorder.stop();
  //     // print("Audio recording stopped: ${recording.path}");
  //     setState(() {
  //       _isRecording = false;
  //     });
  //   } catch (e) {
  //     // Handle errors
  //     print(e);
  //   }
  // }
  List<File>? _files = null;
  final ja.AudioPlayer _audioPlayer = ja.AudioPlayer();

  Future<void> _loadFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      _files = directory.listSync().whereType<File>().toList();
    });
  }

  Future<void> _playAudio(File file) async {
    final fileUri = Uri.file(file.path);

    // final audioSource = ja.AudioSource.uri(fileUri);

    final audioSource = ja.AudioSource.uri(
      fileUri,
    );
    await _audioPlayer.setAudioSource(audioSource);

    // await _audioPlayer.setAudioSource(audioSource);
    await _audioPlayer.play();
    print('Playback started: ${file.path}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shake Detection'),
      ),
      body: _files != null
          ? ListView.builder(
              itemCount: _files!.length,
              itemBuilder: (context, index) {
                final file = _files![index];
                return ListTile(
                  selectedColor: Colors.grey,
                  leading: Icon(
                    Icons.mic,
                    color: AppColors.primary,
                  ),
                  title: Text('Recoring ${index}'),
                  subtitle:
                      Text('${file.path.split('/').last.split('.').first}'),
                  onTap: () {
                    _playAudio(file);
                  },
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      // ),
      // ),
    );
  }
}
