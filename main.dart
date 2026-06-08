import 'package:flutter/material.dart';

import 'features/projects/screens/project_list_screen.dart';

void main() {
  runApp(const MDFApp());
}

class MDFApp extends StatelessWidget {
  const MDFApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MDF Workshop',

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),

      home: const ProjectListScreen(),
    );
  }
}