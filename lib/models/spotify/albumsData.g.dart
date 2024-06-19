// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'albumsData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumsData _$AlbumsDataFromJson(Map<String, dynamic> json) => AlbumsData(
      albums: Albums.fromJson(json['albums'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AlbumsDataToJson(AlbumsData instance) =>
    <String, dynamic>{
      'albums': instance.albums,
    };

Albums _$AlbumsFromJson(Map<String, dynamic> json) => Albums(
      href: json['href'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => AlbumItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      limit: (json['limit'] as num).toInt(),
      next: json['next'] as String,
      offset: (json['offset'] as num).toInt(),
      previous: json['previous'],
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$AlbumsToJson(Albums instance) => <String, dynamic>{
      'href': instance.href,
      'items': instance.items,
      'limit': instance.limit,
      'next': instance.next,
      'offset': instance.offset,
      'previous': instance.previous,
      'total': instance.total,
    };

AlbumItem _$AlbumItemFromJson(Map<String, dynamic> json) => AlbumItem(
      albumType:
          const AlbumTypeEnumConverter().fromJson(json['albumType'] as String),
      artists: (json['artists'] as List<dynamic>)
          .map((e) => Artist.fromJson(e as Map<String, dynamic>))
          .toList(),
      availableMarkets: (json['availableMarkets'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      externalUrls:
          ExternalUrls.fromJson(json['externalUrls'] as Map<String, dynamic>),
      href: json['href'] as String,
      id: json['id'] as String,
      images: (json['images'] as List<dynamic>)
          .map((e) => AlbumImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String,
      releaseDate: DateTime.parse(json['releaseDate'] as String),
      releaseDatePrecision: const ReleaseDatePrecisionEnumConverter()
          .fromJson(json['releaseDatePrecision'] as String),
      totalTracks: (json['totalTracks'] as num).toInt(),
      type: const AlbumTypeEnumConverter().fromJson(json['type'] as String),
      uri: json['uri'] as String,
    );

Map<String, dynamic> _$AlbumItemToJson(AlbumItem instance) => <String, dynamic>{
      'albumType': const AlbumTypeEnumConverter().toJson(instance.albumType),
      'artists': instance.artists,
      'availableMarkets': instance.availableMarkets,
      'externalUrls': instance.externalUrls,
      'href': instance.href,
      'id': instance.id,
      'images': instance.images,
      'name': instance.name,
      'releaseDate': instance.releaseDate.toIso8601String(),
      'releaseDatePrecision': const ReleaseDatePrecisionEnumConverter()
          .toJson(instance.releaseDatePrecision),
      'totalTracks': instance.totalTracks,
      'type': const AlbumTypeEnumConverter().toJson(instance.type),
      'uri': instance.uri,
    };

Artist _$ArtistFromJson(Map<String, dynamic> json) => Artist(
      externalUrls:
          ExternalUrls.fromJson(json['externalUrls'] as Map<String, dynamic>),
      href: json['href'] as String,
      id: json['id'] as String,
      name: json['name'] as String,
      type: const ArtistTypeEnumConverter().fromJson(json['type'] as String),
      uri: json['uri'] as String,
    );

Map<String, dynamic> _$ArtistToJson(Artist instance) => <String, dynamic>{
      'externalUrls': instance.externalUrls,
      'href': instance.href,
      'id': instance.id,
      'name': instance.name,
      'type': const ArtistTypeEnumConverter().toJson(instance.type),
      'uri': instance.uri,
    };

ExternalUrls _$ExternalUrlsFromJson(Map<String, dynamic> json) => ExternalUrls(
      spotify: json['spotify'] as String,
    );

Map<String, dynamic> _$ExternalUrlsToJson(ExternalUrls instance) =>
    <String, dynamic>{
      'spotify': instance.spotify,
    };

AlbumImage _$AlbumImageFromJson(Map<String, dynamic> json) => AlbumImage(
      height: (json['height'] as num).toInt(),
      url: json['url'] as String,
      width: (json['width'] as num).toInt(),
    );

Map<String, dynamic> _$AlbumImageToJson(AlbumImage instance) =>
    <String, dynamic>{
      'height': instance.height,
      'url': instance.url,
      'width': instance.width,
    };

ReleaseDatePrecisionEnumConverter _$ReleaseDatePrecisionEnumConverterFromJson(
        Map<String, dynamic> json) =>
    ReleaseDatePrecisionEnumConverter();

Map<String, dynamic> _$ReleaseDatePrecisionEnumConverterToJson(
        ReleaseDatePrecisionEnumConverter instance) =>
    <String, dynamic>{};
