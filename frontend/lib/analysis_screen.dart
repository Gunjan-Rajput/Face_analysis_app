import 'package:flutter/material.dart';

class AnalysisScreen extends StatelessWidget {
  final String result;
  final String imagePath;

  AnalysisScreen({required this.result, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Analysis Result')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(File(imagePath)),
            SizedBox(height: 20),
            Text(result),
          ],
        ),
      ),
    );
  }
}
