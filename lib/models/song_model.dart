import 'package:json_annotation/json_annotation.dart';
import 'package:musicmate/models/index.dart';
part 'song_model.g.dart';

@JsonSerializable()
class SongModel {
  final AlbumItem? albumItem;
  final String? videoId;
  final String? audioUrl;

  SongModel({this.albumItem, this.videoId, this.audioUrl});

  factory SongModel.fromJson(Map<String, dynamic> json) =>
      _$SongModelFromJson(json);

  Map<String, dynamic> toJson() => _$SongModelToJson(this);
}
