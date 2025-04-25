import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerPage extends StatelessWidget {
  final String pdfBase64;
  const PdfViewerPage({Key? key, required this.pdfBase64}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bytes = base64Decode(pdfBase64);
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: SfPdfViewer.memory(bytes),
    );
  }
}