import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class EnvConfig {
  static Future<void> loadEnv() async {
    if (!kIsWeb) {
      try {
        await dotenv.load(fileName: ".env");
      } catch (e) {
        print('No .env found, skipping: $e');
      }
    }
  }

  static String get apiUrl {
    const prodApi = String.fromEnvironment('API_URL', defaultValue: '');
    return prodApi.isNotEmpty
        ? prodApi
        : dotenv.env['API_URL'] ?? 'https://api.default.com';
  }

  static bool get displaySkipButton {
    const prodFlag = String.fromEnvironment(
      'DISPLAY_SKIP_BUTTON',
      defaultValue: '',
    );
    return prodFlag == 'true' ||
        (dotenv.env['DISPLAY_SKIP_BUTTON'] ?? 'false') == 'true';
  }
}
