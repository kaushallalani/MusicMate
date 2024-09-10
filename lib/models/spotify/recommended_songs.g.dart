// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommended_songs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendedSongs _$RecommendedSongsFromJson(Map<String, dynamic> json) =>
    RecommendedSongs(
      tracks: (json['tracks'] as List<dynamic>?)
          ?.map((e) => Track.fromJson(e as Map<String, dynamic>))
          .toList(),
      seeds: (json['seeds'] as List<dynamic>?)
          ?.map((e) => Seed.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RecommendedSongsToJson(RecommendedSongs instance) =>
    <String, dynamic>{
      'tracks': instance.tracks,
      'seeds': instance.seeds,
    };

Seed _$SeedFromJson(Map<String, dynamic> json) => Seed(
      initialPoolSize: (json['initialPoolSize'] as num?)?.toInt(),
      afterFilteringSize: (json['afterFilteringSize'] as num?)?.toInt(),
      afterRelinkingSize: (json['afterRelinkingSize'] as num?)?.toInt(),
      id: json['id'] as String?,
      type: json['type'] as String?,
      href: json['href'] as String?,
    );

Map<String, dynamic> _$SeedToJson(Seed instance) => <String, dynamic>{
      'initialPoolSize': instance.initialPoolSize,
      'afterFilteringSize': instance.afterFilteringSize,
      'afterRelinkingSize': instance.afterRelinkingSize,
      'id': instance.id,
      'type': instance.type,
      'href': instance.href,
    };

Track _$TrackFromJson(Map<String, dynamic> json) => Track(
      album: json['album'] == null
          ? null
          : Album.fromJson(json['album'] as Map<String, dynamic>),
      artists: (json['artists'] as List<dynamic>?)
          ?.map((e) => Artist.fromJson(e as Map<String, dynamic>))
          .toList(),
      availableMarkets: (json['available_markets'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      discNumber: (json['disc_number'] as num?)?.toInt(),
      durationMs: (json['duration_ms'] as num?)?.toInt(),
      explicit: json['explicit'] as bool?,
      externalIds: json['external_ids'] == null
          ? null
          : ExternalIds.fromJson(json['external_ids'] as Map<String, dynamic>),
      externalUrls: json['external_urls'] == null
          ? null
          : ExternalUrls.fromJson(
              json['external_urls'] as Map<String, dynamic>),
      href: json['href'] as String?,
      id: json['id'] as String?,
      isLocal: json['is_local'] as bool?,
      name: json['name'] as String?,
      popularity: (json['popularity'] as num?)?.toInt(),
      previewUrl: json['preview_url'] as String?,
      trackNumber: (json['track_number'] as num?)?.toInt(),
      type: json['type'] as String?,
      uri: json['uri'] as String?,
    );

Map<String, dynamic> _$TrackToJson(Track instance) => <String, dynamic>{
      'album': instance.album,
      'artists': instance.artists,
      'available_markets': instance.availableMarkets,
      'disc_number': instance.discNumber,
      'duration_ms': instance.durationMs,
      'explicit': instance.explicit,
      'external_ids': instance.externalIds,
      'external_urls': instance.externalUrls,
      'href': instance.href,
      'id': instance.id,
      'is_local': instance.isLocal,
      'name': instance.name,
      'popularity': instance.popularity,
      'preview_url': instance.previewUrl,
      'track_number': instance.trackNumber,
      'type': instance.type,
      'uri': instance.uri,
    };

Album _$AlbumFromJson(Map<String, dynamic> json) => Album(
      albumType: json['album_type'] as String?,
      artists: (json['artists'] as List<dynamic>?)
          ?.map((e) => Artist.fromJson(e as Map<String, dynamic>))
          .toList(),
      availableMarkets: (json['available_markets'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      externalUrls: json['external_urls'] == null
          ? null
          : ExternalUrls.fromJson(
              json['external_urls'] as Map<String, dynamic>),
      href: json['href'] as String?,
      id: json['id'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => TrackImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String?,
      releaseDate: json['release_date'] == null
          ? null
          : DateTime.parse(json['release_date'] as String),
      releaseDatePrecision: json['release_date_precision'] as String?,
      totalTracks: (json['total_tracks'] as num?)?.toInt(),
      type: json['type'] as String?,
      uri: json['uri'] as String?,
    );

Map<String, dynamic> _$AlbumToJson(Album instance) => <String, dynamic>{
      'album_type': instance.albumType,
      'artists': instance.artists,
      'available_markets': instance.availableMarkets,
      'external_urls': instance.externalUrls,
      'href': instance.href,
      'id': instance.id,
      'images': instance.images,
      'name': instance.name,
      'release_date': instance.releaseDate?.toIso8601String(),
      'release_date_precision': instance.releaseDatePrecision,
      'total_tracks': instance.totalTracks,
      'type': instance.type,
      'uri': instance.uri,
    };

TrackImage _$TrackImageFromJson(Map<String, dynamic> json) => TrackImage(
      height: (json['height'] as num?)?.toInt(),
      url: json['url'] as String?,
      width: (json['width'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TrackImageToJson(TrackImage instance) =>
    <String, dynamic>{
      'height': instance.height,
      'url': instance.url,
      'width': instance.width,
    };

ExternalIds _$ExternalIdsFromJson(Map<String, dynamic> json) => ExternalIds(
      isrc: json['isrc'] as String?,
    );

Map<String, dynamic> _$ExternalIdsToJson(ExternalIds instance) =>
    <String, dynamic>{
      'isrc': instance.isrc,
    };
