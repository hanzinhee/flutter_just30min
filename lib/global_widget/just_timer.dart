import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JustTimer extends StatefulWidget {
  const JustTimer({Key? key}) : super(key: key);

  @override
  State<JustTimer> createState() => _JustTimerState();
}

class _JustTimerState extends State<JustTimer> {
  int _totalMilliseconds = 10 * 1000;
  int _milliseconds = 0;
  Timer? timer;

  @override
  initState() {
    super.initState();
  }

  startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      setState(() {
        _milliseconds++;
      });
    });
  }

  stopTimer() {
    timer?.cancel();
  }

  refreshTimer() {
    setState(() {
      _milliseconds = 0;
    });
  }

  String get currentMillisecond {
    final milliseconds =
        _milliseconds > _totalMilliseconds ? _totalMilliseconds : _milliseconds;
    Duration(milliseconds: milliseconds);
    return (Duration(milliseconds: milliseconds).inMilliseconds %
            Duration.millisecondsPerSecond *
            0.1)
        .ceil()
        .toString()
        .padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        CustomPaint(
          size: size,
          painter: Clock(
              second: _milliseconds,
              onComplete: stopTimer,
              totalMillisecond: _totalMilliseconds),
          // child: Text(size.toString()),
        ),
        Row(
          children: [
            TextButton(
                onPressed: () {
                  startTimer();
                },
                child: const Text('START')),
            TextButton(
                onPressed: () {
                  stopTimer();
                },
                child: const Text('STOP')),
            TextButton(
                onPressed: () {
                  refreshTimer();
                },
                child: const Text('REFRESH')),
          ],
        ),
        Align(
            alignment: Alignment.bottomCenter, child: Text(currentMillisecond))
        // Center(child: Text('$_second')),
      ],
    );
  }
}

class Clock extends CustomPainter {
  int second;
  VoidCallback onComplete;
  int totalMillisecond;
  Clock(
      {required this.second,
      required this.totalMillisecond,
      required this.onComplete});
  @override
  void paint(Canvas canvas, Size size) {
    var center = size / 2;
    var paintCircle = Paint()..color = Colors.deepOrangeAccent;
    var paintArc = Paint()..color = Colors.amber;
    var sizeCircle =
        size.width > size.height ? size.height * 0.5 : size.width * 0.5;
    var sizeArc = size.width > size.height ? size.height : size.width;

    canvas.drawCircle(
        Offset(center.width, center.height), sizeCircle, paintCircle);
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(center.width, center.height),
        width: size.width > size.height ? size.height : size.width,
        height: size.width > size.height ? size.height : size.width,
      ),
      pi + (pi / 2),
      ((pi * 2) * (1 / totalMillisecond)) * second,
      true,
      paintArc,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    print('_totalSecond: $totalMillisecond,second: $second');
    if (totalMillisecond <= second) {
      onComplete();
    }
    return true;
  }
}
