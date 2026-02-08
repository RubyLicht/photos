import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/photo_model.dart';

abstract class PhotoRemoteDataSource {
  Future<List<PhotoModel>> getPhotos({required int page, required int limit});
}

class PhotoRemoteDataSourceImpl implements PhotoRemoteDataSource {
  final http.Client client;

  PhotoRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PhotoModel>> getPhotos({
    required int page,
    required int limit,
  }) async {
    final url = Uri.https(
      'picsum.photos',
      '/v2/list',
      {
        'page': page.toString(),
        'limit': limit.toString(),
      },
    );

    final response = await client.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => PhotoModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load photos: ${response.statusCode}');
    }
  }
}

