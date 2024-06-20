import 'package:json_annotation/json_annotation.dart';
 part 'albums_data.g.dart';
// Models generated from JSON using json_serializable

@JsonSerializable()
class AlbumData {
  final Albums albums;

  AlbumData({required this.albums});

  factory AlbumData.fromJson(Map<String, dynamic> json) => _$AlbumDataFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumDataToJson(this);
}

@JsonSerializable()
class Albums {
  final String? href;
  final List<AlbumItem> items;
  final int? limit;
  final String? next;
  final int? offset;
  final dynamic previous;
  final int? total;


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
  final String? albumType; // Nullable albumType

  // Other fields remain the same
  final List<Artist> artists;
  final List<String>? availableMarkets; // Nullable availableMarkets
  final ExternalUrls? externalUrls; // Nullable ExternalUrls
  final String? href;
  final String? id;
  final List<AlbumImage>? images;
  final String? name;
  final DateTime? releaseDate;
  final String? releaseDatePrecision;
  final int? totalTracks;
  final String? type;
  final String? uri;

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

@JsonSerializable()
class Artist {
  final ExternalUrls externalUrls;
  final String href;
  final String id;
  final String name;
  final String type;
  final String uri;

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

@JsonSerializable()
class ExternalUrls {
  final String spotify;

  ExternalUrls({required this.spotify});

  // Updated fromJson method to handle null values gracefully
  factory ExternalUrls.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ExternalUrls(spotify: ''); // Default value for spotify if json is null
    }
    return _$ExternalUrlsFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ExternalUrlsToJson(this);
}

@JsonSerializable()
class AlbumImage {
  final int height;
  final String url;
  final int width;

  AlbumImage({
    required this.height,
    required this.url,
    required this.width,
  });

  factory AlbumImage.fromJson(Map<String, dynamic> json) => _$AlbumImageFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumImageToJson(this);
}