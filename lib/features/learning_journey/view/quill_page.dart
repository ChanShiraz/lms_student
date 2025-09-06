import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class QuillPage extends StatefulWidget {
  QuillPage({super.key, required this.text, required this.lesson});
  static final routeName = '/quillpage';
  String text;
  String lesson;

  @override
  State<QuillPage> createState() => _QuillPageState();
}

class _QuillPageState extends State<QuillPage> {
  final QuillController quillController = QuillController.basic();
  @override
  void initState() {
    quillController.readOnly = true;
    quillController.document = Document.fromJson(jsonDecode(widget.text));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.lesson,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            Text('Formative Assessment'),
          ],
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Expanded(
          child: QuillEditor.basic(
            controller: quillController,
            config: const QuillEditorConfig(),
          ),
        ),
      ),
    );
  }
}
