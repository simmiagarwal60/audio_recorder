import 'dart:async';

import 'package:flutter/material.dart';

class TimeController extends ValueNotifier<bool>{
  TimeController({bool isPlaying = false}): super(isPlaying);

  void startTimer()=> value = true;
  void stopTimer()=> value = false;
}

class TimerWidget extends StatefulWidget {
  final TimeController controller;
  const TimerWidget({super.key, required this.controller});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {

  Duration duration = Duration();
  Timer? timer;
  bool isCountdown = true;
  
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if(widget.controller.value){
        startTimer();
      }else{
        stopTimer();
      }
    });
    //startTimer();
  }

  void reset() => setState(() => duration = Duration());

  void addTime() {
    final addSeconds = 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if(seconds<0){
        timer?.cancel();
      }else{
        duration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer({bool resets = true}){
    if(!mounted) return;
    if(resets){
      reset();
    }
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void stopTimer({bool resets = true}){
    if(!mounted) return;
    if(resets){
      reset();
    }
    setState(() => timer?.cancel());
  }
  @override
  Widget build(BuildContext context) {
    return Center(child: buildTime(),);
  }
  Widget buildTime(){
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Text('${minutes}:${seconds}', style: TextStyle(fontSize: 50, color: Colors.white),);
  }
}
