import '../entities/photo.dart';

abstract class PhotoRepository {
  Future<List<Photo>> getPhotos({required int page, required int limit});
}

