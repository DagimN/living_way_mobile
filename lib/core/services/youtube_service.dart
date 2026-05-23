import 'package:dio/dio.dart';
import 'package:living_way/core/core.dart';

class YouTubeService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://www.googleapis.com/youtube/v3',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      queryParameters: {
        'key': youtubeApiKey,
      },
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  YouTubeService();

  Future<List<dynamic>> fetchPlaylists({int maxResults = 25}) async {
    final response = await _dio.get(
      '/playlists',
      queryParameters: {
        'part': 'snippet,contentDetails',
        'channelId': youtubeChannelId,
        'maxResults': maxResults,
      },
    );
    return response.data['items'] as List<dynamic>;
  }

  Future<List<Topic>> fetchPlaylistVideos(
    String playlistId, {
    int maxResults = 25,
    String? pageToken,
  }) async {
    final response = await _dio.get(
      '/playlistItems',
      queryParameters: {
        'part': 'snippet,contentDetails',
        'playlistId': playlistId,
        'maxResults': maxResults,
        if (pageToken != null) 'pageToken': pageToken,
      },
    );

    final items = response.data['items'] as List<dynamic>;

    return items.map((item) {
      String title = item['snippet']['title'];
      String? presenter = title.split('|').firstWhere(
          (item) => item.contains(RegExp(r'[a-zA-Z]')),
          orElse: () => '');

      return Topic(
          id: item['id'],
          title: item['snippet']['title'],
          backgroundImageUrl: item['snippet']['thumbnails']['medium']['url'],
          type: TopicType.video,
          timestamp: DateTime.parse(item['contentDetails']['videoPublishedAt']),
          playlist: [
            Content(
                id: '',
                title: item['snippet']['title'],
                presenter: presenter,
                source: item['contentDetails']['videoId'])
          ]);
    }).toList();
  }

  Future<List<Topic>> fetchAllChannelVideos({int maxResults = 25}) async {
    final uploadsPlaylistId = youtubeChannelId.replaceFirst('UC', 'UU');
    return fetchPlaylistVideos(uploadsPlaylistId, maxResults: maxResults);
  }

  Future<List<dynamic>> fetchAllVideosAcrossPages(String playlistId) async {
    final List<dynamic> allVideos = [];
    String? nextPageToken;

    do {
      final response = await _dio.get(
        '/playlistItems',
        queryParameters: {
          'part': 'snippet,contentDetails',
          'playlistId': playlistId,
          'maxResults': 50,
          if (nextPageToken != null) 'pageToken': nextPageToken,
        },
      );

      allVideos.addAll(response.data['items'] as List<dynamic>);
      nextPageToken = response.data['nextPageToken'];
    } while (nextPageToken != null);

    return allVideos;
  }
}
