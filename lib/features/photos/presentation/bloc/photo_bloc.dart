import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_photos_usecase.dart';
import 'photo_event.dart';
import 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final GetPhotosUseCase getPhotosUseCase;
  static const int _photosLimit = 30;

  PhotoBloc({required this.getPhotosUseCase}) : super(const PhotoState.initial()) {
    on<PhotosLoadRequested>(_onLoadRequested);
    on<PhotosLoadMoreRequested>(_onLoadMoreRequested);
  }

  Future<void> _onLoadRequested(
    PhotosLoadRequested event,
    Emitter<PhotoState> emit,
  ) async {
    emit(const PhotoState.loading());

    try {
      final photos = await getPhotosUseCase(page: 1, limit: _photosLimit);

      emit(PhotoState.loaded(
        photos: photos,
        currentPage: 1,
        hasReachedMax: photos.length < _photosLimit,
      ));
    } catch (e) {
      emit(PhotoState.error(message: e.toString()));
    }
  }

  Future<void> _onLoadMoreRequested(
    PhotosLoadMoreRequested event,
    Emitter<PhotoState> emit,
  ) async {
    final currentState = state;

    // Only load more if we're in a loaded state and haven't reached max
    if (currentState is! PhotoLoaded || currentState.hasReachedMax) {
      return;
    }

    emit(PhotoState.loadingMore(
      photos: currentState.photos,
      currentPage: currentState.currentPage,
    ));

    try {
      final nextPage = currentState.currentPage + 1;
      final newPhotos = await getPhotosUseCase(page: nextPage, limit: _photosLimit);

      final allPhotos = [...currentState.photos, ...newPhotos];

      emit(PhotoState.loaded(
        photos: allPhotos,
        currentPage: nextPage,
        hasReachedMax: newPhotos.length < _photosLimit,
      ));
    } catch (e) {
      // On error, return to loaded state with existing photos
      emit(PhotoState.loaded(
        photos: currentState.photos,
        currentPage: currentState.currentPage,
        hasReachedMax: currentState.hasReachedMax,
      ));
    }
  }
}
