import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class EnvConfig {
  static Future<void> loadEnv() async {
    if (!kIsWeb) {
      await dotenv.load(fileName: ".env.dev");
    }
  }

  static String get apiUrl {
    const prodApi = String.fromEnvironment('API_URL', defaultValue: '');
    return prodApi.isNotEmpty ? prodApi : dotenv.env['API_URL']!;
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
