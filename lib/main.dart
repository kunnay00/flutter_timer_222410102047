// NAMA  : Kunny Masrukhati
// NIM   : 222410102047
// KELAS : PBM A

import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(TimerApp());
}

class TimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Timer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TimerHomePage(),
    );
  }
}

class TimerHomePage extends StatefulWidget {
  @override
  _TimerHomePageState createState() => _TimerHomePageState();
}

class _TimerHomePageState extends State<TimerHomePage> {
  TextEditingController _controller = TextEditingController();
  Timer? _timer;
  int _timeInSeconds = 0;
  bool _isRunning = false;
  bool _isPaused = false;

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _isPaused = false;
      int minutes = int.tryParse(_controller.text) ?? 0;
      _timeInSeconds = minutes * 60; 
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (_timeInSeconds < 1) {
            _timer?.cancel();
            _isRunning = false;
            _showTimesUpDialog();
          } else {
            _timeInSeconds--;
          }
        });
      });
    });
  }

  void _pauseTimer() {
    if (_isRunning && !_isPaused) {
      _timer?.cancel();
      setState(() {
        _isPaused = true;
      });
    }
  }

  void _resumeTimer() {
    if (_isPaused) {
      setState(() {
        _isRunning = true;
        _isPaused = false;
        _timer = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {
            if (_timeInSeconds < 1) {
              _timer?.cancel();
              _isRunning = false;
              _showTimesUpDialog();
            } else {
              _timeInSeconds--;
            }
          });
        });
      });
    }
  }

  void _resetTimer() {
    setState(() {
      _timer?.cancel();
      _isRunning = false;
      _isPaused = false;
      _timeInSeconds = 0;
      _controller.clear();
    });
  }

  String _formatTime(int timeInSeconds) {
    int hours = timeInSeconds ~/ 3600;
    int minutes = (timeInSeconds % 3600) ~/ 60;
    int seconds = timeInSeconds % 60;
    String hoursStr = (hours % 24).toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    return '$hoursStr:$minutesStr:$secondsStr';
  }

  void _showTimesUpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Times Up"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetTimer(); 
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 8, 57, 116),
        toolbarHeight: 75,
        title: Text(
          'Timer App',
          style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 167, 220, 244), 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (!_isRunning) 
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Masukkan Waktu (menit)',
                      alignLabelWithHint: true, 
                    ),
                  ),
                ),
              ),
            SizedBox(height: 20),
            if (_isRunning)
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 8, 57, 116),
                ),
                child: Center(
                  child: Text(
                    '${_formatTime(_timeInSeconds)}',
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
              ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isRunning && !_isPaused)
                  FloatingActionButton(
                    onPressed: _pauseTimer,
                    child: Icon(Icons.pause, color: Colors.black),
                    backgroundColor: Color(0xFFFF9900), 
                  ),
                if (_isPaused)
                  FloatingActionButton(
                    onPressed: _resumeTimer,
                    child: Icon(Icons.play_arrow, color: Colors.black),
                    backgroundColor: Color(0xFFFF9900),
                  ),
                SizedBox(width: 20),
                if (_isRunning || _isPaused)
                  FloatingActionButton(
                    onPressed: _resetTimer,
                    child: Icon(Icons.refresh, color: Colors.black),
                    backgroundColor: Color(0xFFFF9900),
                  ),
              ],
            ),
            SizedBox(height: 20),
            if (!_isRunning && !_isPaused)
              TextButton(
                onPressed: _startTimer,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFFFF9900)),
                  minimumSize: MaterialStateProperty.all(Size(200, 50)), 
                ),
                child: Text(
                  'Start Timer',
                  style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold), 
                ),
              ),
          ],
        ),
      ),
    );
  }
}
