import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'analysis_screen.dart'; // Import your analysis screen

void main() {
  runApp(SkinAnalysisApp());
}

class SkinAnalysisApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FaceAnalyzerPage(),
    );
  }
}

class FaceAnalyzerPage extends StatefulWidget {
  @override
  _FaceAnalyzerPageState createState() => _FaceAnalyzerPageState();
}

class _FaceAnalyzerPageState extends State<FaceAnalyzerPage> {
  File? _image;
  String _result = "Capture your face for analysis.";

  Future pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
      await sendToBackend(_image!);
    }
  }

  Future sendToBackend(File imageFile) async {
    var request = http.MultipartRequest('POST', Uri.parse('http://127.0.0.1:8000/analyze-face/'));
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
    var res = await request.send();
    var response = await res.stream.bytesToString();
    var decoded = json.decode(response);

    setState(() {
      _result = decoded.containsKey('error')
          ? decoded['error']
          : "Skin Type: ${decoded['skin_type']}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Beauty Parlour Face Analyzer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null ? Text('No image selected.') : Image.file(_image!),
            SizedBox(height: 20),
            ElevatedButton(onPressed: pickImage, child: Text('Capture Face')),
            SizedBox(height: 20),
            Text(_result, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
