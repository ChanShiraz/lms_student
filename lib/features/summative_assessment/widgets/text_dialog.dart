import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';

class TextDialog extends StatelessWidget {
  final QuillController quillController;

  TextDialog({super.key, String? initialText})
    : quillController = buildController(initialText);
  bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 900;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isDesktop(context)
              ? SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: RichTextInput(
                    showToolBar: false,
                    controller: quillController,
                    label: null,
                  ),
                )
              : RichTextInput(
                  showToolBar: false,
                  controller: quillController,
                  label: null,
                ),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ),
        ],
      ),
    );
  }
}

QuillController buildController(String? jsonText) {
  // 1️⃣ Empty or null → empty editor
  if (jsonText == null || jsonText.trim().isEmpty) {
    return QuillController.basic();
  }

  try {
    // 2️⃣ Try to decode as Quill Delta JSON
    final decoded = jsonDecode(jsonText);

    if (decoded is List) {
      final delta = Delta.fromJson(decoded);
      final document = Document.fromDelta(delta);

      return QuillController(
        document: document,
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
  } catch (e) {
    debugPrint('Quill delta parse failed, falling back to plain text: $e');
  }

  // 3️⃣ Fallback: treat as plain text
  try {
    final document = Document()..insert(0, jsonText);

    return QuillController(
      document: document,
      selection: const TextSelection.collapsed(offset: 0),
    );
  } catch (e) {
    debugPrint('Plain text fallback failed: $e');
  }

  // 4️⃣ Final safety net
  return QuillController.basic();
}

// QuillController buildController(String? jsonText) {
//   if (jsonText == null || jsonText.isEmpty) {
//     return QuillController.basic();
//   }

//   final delta = Delta.fromJson(jsonDecode(jsonText));
//   final document = Document.fromDelta(delta);

//   return QuillController(
//     document: document,
//     selection: const TextSelection.collapsed(offset: 0),
//   );
// }

class RichTextInput extends StatelessWidget {
  final QuillController controller;
  final String? label;
  final bool showToolBar;

  const RichTextInput({
    super.key,
    required this.controller,
    required this.label,
    this.showToolBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label != null ? Text(label!) : SizedBox(),
        const SizedBox(height: 8),

        /// Toolbar
        showToolBar
            ? Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffE2E8F0)),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: QuillSimpleToolbar(
                    controller: controller,
                    config: const QuillSimpleToolbarConfig(
                      showListCheck: false,
                      showInlineCode: false,
                      showSubscript: false,
                      showSuperscript: false,
                      showFontFamily: false,
                      showFontSize: false,
                      showColorButton: false,
                      showBackgroundColorButton: false,
                      showAlignmentButtons: false,
                      showCodeBlock: false,
                      showQuote: false,
                      showLink: false,
                      showUndo: false,
                      showRedo: false,
                      showStrikeThrough: false,
                      showClearFormat: false,
                      showHeaderStyle: false,
                      showIndent: false,
                      showSearchButton: false,
                    ),
                  ),
                ),
              )
            : SizedBox.fromSize(),

        /// Editor
        Container(
          height: 180,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffE2E8F0)),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(12),
            ),
          ),
          child: QuillEditor.basic(
            controller: controller,
            focusNode: FocusNode(),
            scrollController: ScrollController(),
            // scrollable: true,
            // padding: const EdgeInsets.all(16),
            // autoFocus: false,
            // readOnly: false,
            // expands: false,
            // placeholder:
            //     'Paste formatted text and use the toolbar for quick edits.',
          ),
        ),
      ],
    );
  }
}
