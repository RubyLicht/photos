import '../entities/photo.dart';
import '../repositories/photo_repository.dart';

class GetPhotosUseCase {
  final PhotoRepository repository;

  GetPhotosUseCase(this.repository);

  Future<List<Photo>> call({required int page, required int limit}) async {
    return await repository.getPhotos(page: page, limit: limit);
  }
}

