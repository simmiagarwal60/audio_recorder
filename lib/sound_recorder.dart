import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';

class SoundRecorder{
  FlutterSoundRecorder? _audioRecorder;
  final pathToSaveAudio = 'audio_example.aac';
  bool _isRecorderInitialised = false;
  bool get isRecording => _audioRecorder!.isRecording;

  Future init() async{
    _audioRecorder = FlutterSoundRecorder();
    final status = await Permission.microphone.request();
    if(status != PermissionStatus.granted){
      throw RecordingPermissionException('Microphone permission denied.');
    }
    await _audioRecorder!.openAudioSession();
    _isRecorderInitialised = true;

  }
  Future dispose() async{
    _audioRecorder!.closeAudioSession();
    _audioRecorder = null;
    _isRecorderInitialised = false;
  }

  Future _record() async{
    if(!_isRecorderInitialised) return;
    await _audioRecorder?.startRecorder(toFile: pathToSaveAudio);
  }

  Future _stop() async{
    if(!_isRecorderInitialised) return;
    await _audioRecorder?.stopRecorder();
  }

  Future toggleRecording() async{
    if(_audioRecorder!.isStopped){
      await _record();
    }
    else{
      await _stop();
    }
  }

}