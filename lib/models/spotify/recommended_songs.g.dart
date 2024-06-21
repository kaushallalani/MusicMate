// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommended_songs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendedSongs _$RecommendedSongsFromJson(Map<String, dynamic> json) =>
    RecommendedSongs(
      tracks: (json['tracks'] as List<dynamic>)
          .map((e) => Track.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RecommendedSongsToJson(RecommendedSongs instance) =>
    <String, dynamic>{
      'tracks': instance.tracks,
    };

Track _$TrackFromJson(Map<String, dynamic> json) => Track(
      album: Album.fromJson(json['album'] as Map<String, dynamic>),
      artists: (json['artists'] as List<dynamic>)
          .map((e) => Artist.fromJson(e as Map<String, dynamic>))
          .toList(),
      discNumber: (json['disc_number'] as num).toInt(),
      durationMs: (json['duration_ms'] as num).toInt(),
      href: json['href'] as String,
      id: json['id'] as String,
      name: json['name'] as String,
      popularity: (json['popularity'] as num).toInt(),
      previewUrl: json['preview_url'] as String,
      trackNumber: (json['track_number'] as num).toInt(),
      type: json['type'] as String,
    );

Map<String, dynamic> _$TrackToJson(Track instance) => <String, dynamic>{
      'album': instance.album,
      'artists': instance.artists,
      'disc_number': instance.discNumber,
      'duration_ms': instance.durationMs,
      'href': instance.href,
      'id': instance.id,
      'name': instance.name,
      'popularity': instance.popularity,
      'preview_url': instance.previewUrl,
      'track_number': instance.trackNumber,
      'type': instance.type,
    };

Album _$AlbumFromJson(Map<String, dynamic> json) => Album(
      albumType: json['album_type'] as String,
      artists: (json['artists'] as List<dynamic>)
          .map((e) => Artist.fromJson(e as Map<String, dynamic>))
          .toList(),
      href: json['href'] as String,
      id: json['id'] as String,
      images: (json['images'] as List<dynamic>)
          .map((e) => TrackImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$AlbumToJson(Album instance) => <String, dynamic>{
      'album_type': instance.albumType,
      'artists': instance.artists,
      'href': instance.href,
      'id': instance.id,
      'images': instance.images,
      'name': instance.name,
      'type': instance.type,
    };

Artist _$ArtistFromJson(Map<String, dynamic> json) => Artist(
      href: json['href'] as String,
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$ArtistToJson(Artist instance) => <String, dynamic>{
      'href': instance.href,
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
    };

TrackImage _$TrackImageFromJson(Map<String, dynamic> json) => TrackImage(
      height: (json['height'] as num).toInt(),
      url: json['url'] as String,
      width: (json['width'] as num).toInt(),
    );

Map<String, dynamic> _$TrackImageToJson(TrackImage instance) =>
    <String, dynamic>{
      'height': instance.height,
      'url': instance.url,
      'width': instance.width,
    };
