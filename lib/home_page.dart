import 'package:audio_recorder/sound_player.dart';
import 'package:audio_recorder/sound_recorder.dart';
import 'package:audio_recorder/timer_widget.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  static const maxSeconds = 60;
  final recorder = SoundRecorder();
  final player = SoundPlayer();
  final timerController = TimeController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recorder.init();
    player.init();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    recorder.dispose();
    player.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Recorder'),
        ),
        body: Container(
          color: Colors.blue.withOpacity(0.5),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildPlayer(),
                const SizedBox(height: 80,),
                buildStart(),
                const SizedBox(height: 10,),
                buildPlay()
              ],
            ),
          ),
        )
      ),
    );
  }
  Widget buildStart(){
    final isRecording = recorder.isRecording;
    final icon = isRecording? Icons.stop: Icons.mic;
    final text = isRecording? 'STOP': 'START';
    final primary = isRecording? Colors.red: Colors.white;
    final onPrimary = isRecording? Colors.white: Colors.black;
    return ElevatedButton.icon(onPressed: () async{
      await recorder!.toggleRecording();
      final isRecording = recorder.isRecording;
      setState(() {});
      if(isRecording){
        timerController.startTimer();
      }else{
        timerController.stopTimer();
      }

    },
        icon: Icon(icon),
        label: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
    style: ElevatedButton.styleFrom(
      minimumSize: Size(175,50),
      backgroundColor: primary,
      foregroundColor: onPrimary
    ),);
  }
  Widget buildPlayer(){
    final text = recorder.isRecording? 'Now Recording': 'Press start';
    final animate = recorder.isRecording;

    return AvatarGlow(
      endRadius: 140,
        animate: animate,
      repeatPauseDuration: Duration(milliseconds: 100),
      child: CircleAvatar(
        radius: 100,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 92,
          backgroundColor: Colors.indigo.shade900.withBlue(70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.mic,size: 30,color: Colors.white,),
              TimerWidget(controller: timerController),
              SizedBox(height: 8,),
              Text(text, style: TextStyle(color: Colors.white),)
            ],
          ),
        ),
      ),
    );
  }
  Widget buildPlay(){
    final isPlaying = player.isPlaying;
    final icon = isPlaying? Icons.stop: Icons.play_arrow;
    final text = isPlaying? 'Stop Playing': 'Play Recording';

    return ElevatedButton.icon(onPressed: () async {
      await player.togglePlayer(whenFinished: () => setState(() {}));
      setState(() {});
    },
        icon: Icon(icon),
        label: Text(text),
    style: ElevatedButton.styleFrom(
      minimumSize: Size(175, 50),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black
    ),);
  }

}

