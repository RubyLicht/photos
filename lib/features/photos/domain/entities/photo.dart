import 'package:freezed_annotation/freezed_annotation.dart';

part 'photo.freezed.dart';

@freezed
class Photo with _$Photo {
  const factory Photo({
    required String id,
    required String author,
    required int width,
    required int height,
    required String url,
    required String downloadUrl,
  }) = _Photo;
}

