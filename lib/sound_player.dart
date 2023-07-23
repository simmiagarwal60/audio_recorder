import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
final pathToReadAudio = 'audio_example.aac';
class SoundPlayer{
  FlutterSoundPlayer? _audioPlayer;

  bool get isPlaying=> _audioPlayer!.isPlaying;

  Future init() async{
    _audioPlayer = FlutterSoundPlayer();
    await _audioPlayer!.openAudioSession();

  }
  Future dispose() async{
    _audioPlayer!.closeAudioSession();
    _audioPlayer = null;
  }


  Future _play(VoidCallback whenFinished) async{
    await _audioPlayer!.startPlayer(fromURI: pathToReadAudio, whenFinished: whenFinished, codec: Codec.mp3);
  }

  Future _stop() async{
    await _audioPlayer!.stopPlayer();
  }

  Future togglePlayer({required VoidCallback whenFinished}) async{
    if(_audioPlayer!.isStopped){
      await _play(whenFinished);
    }else{
     await _stop();
    }
  }
}