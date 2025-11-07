import 'package:chilliguard/core/constants/app_constants.dart';

void main() {
  print('✅ BASE_URL: ${AppConstants.baseUrl}');
  print('✅ API TIMEOUT: ${AppConstants.apiTimeout}');

  // Should print:
  // ✅ BASE_URL: http://192.168.0.100:5000
  // ✅ API TIMEOUT: 30000
}
