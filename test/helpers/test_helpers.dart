import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

/// Loads test environment variables and mocks shared preferences.
Future<void> initTestEnvironment() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferencesAsyncPlatform.instance =
      InMemorySharedPreferencesAsync.empty();
  dotenv.testLoad(fileInput: '''
ENCRYPTION_SECRET_KEY=12345678901234567890123456789012
ENCRYPTION_IV=1234567890123456
UNSPLASH_APP_ID=test_app_id
UNSPLASH_ACCESS_KEY=test_access_key
UNSPLASH_SECRET_KEY=test_secret_key
''');
}
