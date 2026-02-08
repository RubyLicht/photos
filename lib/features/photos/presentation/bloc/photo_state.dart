import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/photo.dart';

part 'photo_state.freezed.dart';

@freezed
class PhotoState with _$PhotoState {
  const factory PhotoState.initial() = PhotoInitial;

  const factory PhotoState.loading() = PhotoLoading;

  const factory PhotoState.loaded({
    required List<Photo> photos,
    required int currentPage,
    required bool hasReachedMax,
  }) = PhotoLoaded;

  const factory PhotoState.loadingMore({
    required List<Photo> photos,
    required int currentPage,
  }) = PhotoLoadingMore;

  const factory PhotoState.error({
    required String message,
  }) = PhotoError;
}
