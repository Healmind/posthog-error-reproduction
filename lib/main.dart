import 'package:flutter/material.dart';
import 'custom_input.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PostHog Error Reproduction',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PostHogErrorReproduction(),
    );
  }
}

class PostHogErrorReproduction extends StatefulWidget {
  const PostHogErrorReproduction({super.key});

  @override
  State<PostHogErrorReproduction> createState() => _PostHogErrorReproductionState();
}

class _PostHogErrorReproductionState extends State<PostHogErrorReproduction> {
  String _textValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('PostHog Masking Error Reproduction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomInputText(
          title: 'Text',
          colorCardHome: Colors.white,
          isRequired: true,
          onChanged: (value) {
            setState(() {
              _textValue = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Text is required';
            }
            return null;
          },
        ),
      ),
    );
  }
}
