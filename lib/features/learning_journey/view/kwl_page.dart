import 'package:flutter/material.dart';

class KwlPage extends StatelessWidget {
  const KwlPage({super.key});
  static final routeName = '/kwlpage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lesson 1: The Cell',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            Text('KWL Input'),
          ],
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 5),
            //   child: Text(
            //     'KWL Input',
            //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            //   ),
            // ),
            Text(
              'What I already know',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                'Write a few things you already know about cells.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),
            TextField(
              maxLines: 3,
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hint: Text(
                  'Cells are the building blocks of life...',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'What I Want to Learn',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                'Write what you hope to learn about this topic.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),
            TextField(
              maxLines: 3,
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hint: Text(
                  'I want to understand the difference...',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(onPressed: () {}, child: Text('Save')),
            ),
          ],
        ),
      ),
    );
  }
}
