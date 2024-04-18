import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

class IdentifyPage extends StatefulWidget {
  const IdentifyPage({super.key});

  @override
  State<IdentifyPage> createState() => _IdentifyPageState();
}

class _IdentifyPageState extends State<IdentifyPage> {
  Process? _process;
  Uint8List? _imageData;
  String _label = "";

  @override
  void initState() {
    super.initState();
    _startProcess();
  }

  Future<void> _startProcess() async {
    try {
      _process = await Process.start('py', ['testlive.py']);
      _process?.stdout.transform(utf8.decoder).listen((data) {
        final parts = data.trim().split(',');
        if (parts.length == 2) {
          final frameBytes = base64.decode(parts[0]);
          setState(() {
            _imageData = frameBytes;
            _label = parts[1];
          });
        }
      });
      _process?.stderr.transform(utf8.decoder).listen((data) {
        print(data); // Print testlive.py errors to console
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void _stopProcess() {
    _process?.kill();
    _imageData = null;
    _label = "";
  }

  void _sendSignalToPython() async {
    try {
      final file = File('signal.txt');
      await file.writeAsString('process_frame');
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeee4fc),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 180,
              width: 360,
            ),
          ],
        ),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_imageData != null)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Image.memory(
                      _imageData!,
                      gaplessPlayback: true,
                      fit: BoxFit.contain,
                    ),
                  ),
                const SizedBox(height: 16),
                Text(_label),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _sendSignalToPython,
                  child: const Text('Process Gesture'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _stopProcess,
                  child: const Text('Stop Process'),
                ),
              ],
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 300,
              width: 220,
              child: Image.asset('assets/boy.png'),
            ),
          ],
        ),
      ),
    );
  }
}
