import '../../domain/entities/photo.dart';
import '../../domain/repositories/photo_repository.dart';
import '../datasources/photo_remote_datasource.dart';

class PhotoRepositoryImpl implements PhotoRepository {
  final PhotoRemoteDataSource remoteDataSource;

  PhotoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Photo>> getPhotos({
    required int page,
    required int limit,
  }) async {
    final photoModels = await remoteDataSource.getPhotos(
      page: page,
      limit: limit,
    );
    return photoModels.map((model) => model.toEntity()).toList();
  }
}

