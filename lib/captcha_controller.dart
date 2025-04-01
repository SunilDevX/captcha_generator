import 'dart:math' show Random;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class CaptchaController {
  String _captchaText = '';
  String _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ23456789';
  final String _charsLower = 'abcdefghijklmnopqrstuvwxyz';
  _CaptchaGenerator? _captchaGenerator;

  CaptchaController({
    int length = 6,
    double fontSize = 30.0,
    Color? textColor,
    Color? backgroundColor,
    bool enableDistortion = true,
    bool includeLowercase = false,
  }) : this._(
         length: length,
         fontSize: fontSize,
         textColor: textColor,
         backgroundColor: backgroundColor,
         enableDistortion: enableDistortion,
         includeLowercase: includeLowercase,
       );
  CaptchaController._({
    int length = 6,
    double fontSize = 30.0,
    Color? textColor,
    Color? backgroundColor,
    bool enableDistortion = true,
    bool includeLowercase = false,
  }) {
    // Include lowercase letters if specified
    if (includeLowercase) {
      _chars += _charsLower;
    }
    _captchaGenerator = _CaptchaGenerator(
      backgroundColor: backgroundColor,
      enableDistortion: enableDistortion,
      fontSize: fontSize,
      length: length,
      textColor: textColor,
    );
  }

  /// Generate CAPTCHA image
  /// Returns Uint8List of the generated image
  Future<Uint8List?> generateCaptchaImage() async {
    _captchaText = _generateRandomText();
    return _captchaGenerator!.generateCaptchaImage(_captchaText);
  }

  /// Generate random CAPTCHA text
  /// Returns a random string of length
  String _generateRandomText() {
    Random random = Random();

    return List.generate(
      _captchaGenerator?.length ?? 6,
      (index) => _chars[random.nextInt(_chars.length)],
    ).join();
  }

  /// Verify user input against CAPTCHA
  bool verifyCaptcha(String userInput) {
    return userInput == _captchaText;
  }
}

class _CaptchaGenerator {
  final int length;
  final double fontSize;
  Color? textColor;
  Color? backgroundColor;
  final bool enableDistortion;

  _CaptchaGenerator({
    this.length = 6,
    this.fontSize = 30.0,
    this.textColor = Colors.black,
    this.backgroundColor = Colors.grey,
    this.enableDistortion = true,
  });

  /// Generates CAPTCHA as an image (Uint8List) without showing CustomPainter
  Future<Uint8List?> generateCaptchaImage(String captchaText) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, 200, 80));

    // Create CAPTCHA Painter and draw on an offscreen canvas
    _CaptchaPainter(
      text: captchaText,
      fontSize: fontSize,
      textColor: textColor,
      backgroundColor: backgroundColor,
      enableDistortion: enableDistortion,
    ).paint(canvas, Size(200, 80));

    // Convert canvas to image
    ui.Image image = await recorder.endRecording().toImage(200, 80);
    // Convert image to byte data (PNG format)
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }
}

class _CaptchaPainter extends CustomPainter {
  final String text;
  final double fontSize;
  Color? textColor;
  Color? backgroundColor;
  final bool enableDistortion;

  _CaptchaPainter({
    required this.text,
    required this.fontSize,
    this.textColor,
    this.backgroundColor,
    required this.enableDistortion,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random();
    final paint =
        Paint()
          ..color = textColor ?? Colors.black
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Draw background
    final backgroundPaint =
        Paint()..color = backgroundColor ?? Colors.grey[200]!;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    // Draw random distortion lines
    if (enableDistortion) {
      for (int i = 0; i < 5; i++) {
        paint.color = Colors.primaries[random.nextInt(Colors.primaries.length)];
        paint.strokeWidth = random.nextDouble() * 2 + 1;
        canvas.drawLine(
          Offset(
            random.nextDouble() * size.width,
            random.nextDouble() * size.height,
          ),
          Offset(
            random.nextDouble() * size.width,
            random.nextDouble() * size.height,
          ),
          paint,
        );
      }
    }

    // Draw CAPTCHA text with some random offsets
    for (int i = 0; i < text.length; i++) {
      textPainter.text = TextSpan(
        text: text[i],
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.primaries[random.nextInt(Colors.primaries.length)],
        ),
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          15.0 + i * 25,
          20 + (enableDistortion ? random.nextDouble() * 10 : 0),
        ),
      );
    }
  }

  @override
  bool shouldRepaint(_CaptchaPainter oldDelegate) {
    return text != oldDelegate.text ||
        fontSize != oldDelegate.fontSize ||
        textColor != oldDelegate.textColor ||
        backgroundColor != oldDelegate.backgroundColor ||
        enableDistortion != oldDelegate.enableDistortion;
  }
}
