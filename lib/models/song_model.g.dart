// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SongModel _$SongModelFromJson(Map<String, dynamic> json) => SongModel(
      albumItem: json['albumItem'] == null
          ? null
          : AlbumItem.fromJson(json['albumItem'] as Map<String, dynamic>),
      videoId: json['videoId'] as String?,
      audioUrl: json['audioUrl'] as String?,
    );

Map<String, dynamic> _$SongModelToJson(SongModel instance) => <String, dynamic>{
      'albumItem': instance.albumItem,
      'videoId': instance.videoId,
      'audioUrl': instance.audioUrl,
    };
