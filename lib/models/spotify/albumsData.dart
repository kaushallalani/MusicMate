import 'package:json_annotation/json_annotation.dart';

part 'albumsData.g.dart';

@JsonSerializable()
class AlbumsData {
  Albums albums;

  AlbumsData({
    required this.albums,
  });

  factory AlbumsData.fromJson(Map<String, dynamic> json) => _$AlbumsDataFromJson(json);
  Map<String, dynamic> toJson() => _$AlbumsDataToJson(this);
}

@JsonSerializable()
class Albums {
  String href;
  List<AlbumItem> items;
  int limit;
  String next;
  int offset;
  dynamic previous;
  int total;

  Albums({
    required this.href,
    required this.items,
    required this.limit,
    required this.next,
    required this.offset,
    required this.previous,
    required this.total,
  });

  factory Albums.fromJson(Map<String, dynamic> json) => _$AlbumsFromJson(json);
  Map<String, dynamic> toJson() => _$AlbumsToJson(this);
}

@JsonSerializable()
class AlbumItem {
  @AlbumTypeEnumConverter()
  AlbumTypeEnum albumType;
  List<Artist> artists;
  List<String> availableMarkets;
  ExternalUrls externalUrls;
  String href;
  String id;
  List<AlbumImage> images;
  String name;
  DateTime releaseDate;
  @ReleaseDatePrecisionEnumConverter()
  ReleaseDatePrecision releaseDatePrecision;
  int totalTracks;
  @AlbumTypeEnumConverter()
  AlbumTypeEnum type;
  String uri;

  AlbumItem({
    required this.albumType,
    required this.artists,
    required this.availableMarkets,
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.images,
    required this.name,
    required this.releaseDate,
    required this.releaseDatePrecision,
    required this.totalTracks,
    required this.type,
    required this.uri,
  });

  factory AlbumItem.fromJson(Map<String, dynamic> json) => _$AlbumItemFromJson(json);
  Map<String, dynamic> toJson() => _$AlbumItemToJson(this);
}

class AlbumTypeEnumConverter extends JsonConverter<AlbumTypeEnum, String> {
  const AlbumTypeEnumConverter();

  @override
  AlbumTypeEnum fromJson(String json) {
    switch (json) {
      case 'album':
        return AlbumTypeEnum.ALBUM;
      case 'single':
        return AlbumTypeEnum.SINGLE;
      default:
        throw ArgumentError('Unknown enum value: $json');
    }
  }

  @override
  String toJson(AlbumTypeEnum object) {
    switch (object) {
      case AlbumTypeEnum.ALBUM:
        return 'album';
      case AlbumTypeEnum.SINGLE:
        return 'single';
    }
  }
}

enum AlbumTypeEnum {
  ALBUM,
  SINGLE
}

@JsonSerializable()
class Artist {
  ExternalUrls externalUrls;
  String href;
  String id;
  String name;
  @ArtistTypeEnumConverter()
  ArtistType type;
  String uri;

  Artist({
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.name,
    required this.type,
    required this.uri,
  });

  factory Artist.fromJson(Map<String, dynamic> json) => _$ArtistFromJson(json);
  Map<String, dynamic> toJson() => _$ArtistToJson(this);
}

class ArtistTypeEnumConverter extends JsonConverter<ArtistType, String> {
  const ArtistTypeEnumConverter();

  @override
  ArtistType fromJson(String json) {
    switch (json) {
      case 'artist':
        return ArtistType.ARTIST;
      default:
        throw ArgumentError('Unknown enum value: $json');
    }
  }

  @override
  String toJson(ArtistType object) {
    switch (object) {
      case ArtistType.ARTIST:
        return 'artist';
    }
  }
}

enum ArtistType {
  ARTIST
}

@JsonSerializable()
class ExternalUrls {
  String spotify;

  ExternalUrls({
    required this.spotify,
  });

  factory ExternalUrls.fromJson(Map<String, dynamic> json) => _$ExternalUrlsFromJson(json);
  Map<String, dynamic> toJson() => _$ExternalUrlsToJson(this);
}

@JsonSerializable()
class AlbumImage {
  int height;
  String url;
  int width;

  AlbumImage({
    required this.height,
    required this.url,
    required this.width,
  });

  factory AlbumImage.fromJson(Map<String, dynamic> json) => _$AlbumImageFromJson(json);
  Map<String, dynamic> toJson() => _$AlbumImageToJson(this);
}

@JsonSerializable()
class ReleaseDatePrecisionEnumConverter extends JsonConverter<ReleaseDatePrecision, String> {
  const ReleaseDatePrecisionEnumConverter();

  @override
  ReleaseDatePrecision fromJson(String json) {
    switch (json) {
      case 'day':
        return ReleaseDatePrecision.DAY;
      default:
        throw ArgumentError('Unknown enum value: $json');
    }
  }

  @override
  String toJson(ReleaseDatePrecision object) {
    switch (object) {
      case ReleaseDatePrecision.DAY:
        return 'day';
    }
  }
}

enum ReleaseDatePrecision {
  DAY
}
