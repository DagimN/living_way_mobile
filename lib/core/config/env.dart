import 'package:flutter_dotenv/flutter_dotenv.dart';

final secretKey = dotenv.get('ENCRYPTION_SECRET_KEY', fallback: '');
final secretIv = dotenv.get('ENCRYPTION_IV', fallback: '');

final unsplasAppId = dotenv.get('UNSPLASH_APP_ID', fallback: '');
final unsplasSecretKey = dotenv.get('UNSPLASH_SECRET_KEY', fallback: '');
final unsplasAccessKey = dotenv.get('UNSPLASH_ACCESS_KEY', fallback: '');

final youtubeApiKey = dotenv.get('YOUTUBE_API_KEY', fallback: '');
final youtubeChannelId = dotenv.get('YOUTUBE_CHANNEL_ID', fallback: '');

final googleClientId = dotenv.get('GOOGLE_CLIENT_ID', fallback: '');
