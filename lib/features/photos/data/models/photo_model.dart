import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/photo.dart';

part 'photo_model.freezed.dart';
part 'photo_model.g.dart';

@freezed
class PhotoModel with _$PhotoModel {
  const PhotoModel._();

  const factory PhotoModel({
    required String id,
    required String author,
    required int width,
    required int height,
    required String url,
    @JsonKey(name: 'download_url') required String downloadUrl,
  }) = _PhotoModel;

  factory PhotoModel.fromJson(Map<String, dynamic> json) =>
      _$PhotoModelFromJson(json);

  Photo toEntity() {
    return Photo(
      id: id,
      author: author,
      width: width,
      height: height,
      url: url,
      downloadUrl: downloadUrl,
    );
  }
}

