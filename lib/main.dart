import 'package:flutter/material.dart';
import 'package:request_queue_and_completer/elementary/download_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DownloadScreen(),
    );
  }
}
