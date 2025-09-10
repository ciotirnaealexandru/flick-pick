import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  // Load .env for dev only
  static Future<void> loadEnv() async {
    await dotenv.load(fileName: '.env');
  }

  // Get API URL depending on environment
  // Dev: reads from dotenv
  // Prod: reads from dart-define
  static String get apiUrl {
    const prodEnvResponse = String.fromEnvironment('API_URL', defaultValue: '');
    if (prodEnvResponse.isNotEmpty) return prodEnvResponse;
    return dotenv.env['API_URL']!;
  }

  static String get displaySkipButton {
    const prodEnvResponse = String.fromEnvironment(
      'DISPLAY_SKIP_BUTTON',
      defaultValue: '',
    );
    if (prodEnvResponse.isNotEmpty) return prodEnvResponse;
    return dotenv.env['API_URL']!;
  }
}
