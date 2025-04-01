# Flutter CAPTCHA Generator

A simple and customizable CAPTCHA generator for Flutter applications. This package allows you to generate CAPTCHA images with random text, distortion effects, and easy verification.

## Features
- Generate random CAPTCHA images
- Customizable text length, font size, and colors
- Enable or disable distortion for added security
- Easy verification of user input

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  captcha_generator: latest
```

Then, run:

```sh
flutter pub get
```

## Usage

### Import the package

```dart
import 'package:captcha_generator/captcha_generator.dart';
```

### Generate and Verify CAPTCHA

```dart
final CaptchaController _captchaController = CaptchaController();
Uint8List? _captchaBytes;

void generateCaptcha() async {
  _captchaBytes = await _captchaController.generateCaptchaImage();
}

bool isValid = _captchaController.verifyCaptcha(userInput);
```

## API Reference

### `CaptchaController`

- **`generateCaptchaImage()`** → Generates a new CAPTCHA image and returns `Uint8List`.
- **`verifyCaptcha(String userInput)`** → Verifies user input against the generated CAPTCHA text. Returns `true` if matched, `false` otherwise.

### Customization

You can customize the CAPTCHA using the `CaptchaController` constructor:

```dart
CaptchaController(
  length: 6, // Length of the CAPTCHA text
  fontSize: 30.0, // Font size of CAPTCHA text
  textColor: Colors.black, // Text color
  backgroundColor: Colors.grey, // Background color
  enableDistortion: true, // Enable distortion for security
  includeLowercase: false, // Adds lowercase to the captcha text
);
```

## License

This project is licensed under the MIT License.

## Contributions

Feel free to contribute by submitting issues or pull requests!

---

Happy coding! 🚀

