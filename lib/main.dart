import 'dart:typed_data';

import 'package:captcha_generator/captcha_generator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CaptchaController _captchaController = CaptchaController();
  Uint8List? _captchaBytes;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    generate();
  }

  void generate() async {
    _captchaBytes = await _captchaController.generateCaptchaImage();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter CAPTCHA with Controller')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _captchaBytes == null
                ? CircularProgressIndicator()
                : Image.memory(_captchaBytes!, width: 200, height: 80),
            SizedBox(height: 20),

            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter CAPTCHA',
              ),
            ),

            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                bool isValid = _captchaController.verifyCaptcha(
                  _textEditingController.text,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isValid
                          ? 'CAPTCHA Matched!'
                          : 'Incorrect CAPTCHA! Try again.',
                    ),
                    backgroundColor: isValid ? Colors.green : Colors.red,
                  ),
                );
              },
              child: Text('Verify CAPTCHA'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                generate();
              },
              child: Text('Refresh CAPTCHA from Controller'),
            ),
          ],
        ),
      ),
    );
  }
}
