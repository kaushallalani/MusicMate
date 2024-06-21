import 'package:json_annotation/json_annotation.dart';
part 'albums_data.g.dart';

@JsonSerializable()
class AlbumData {
    @JsonKey(name: "albums")
    Albums albums;

    AlbumData({
        required this.albums,
    });

    factory AlbumData.fromJson(Map<String, dynamic> json) => _$AlbumDataFromJson(json);

    Map<String, dynamic> toJson() => _$AlbumDataToJson(this);
}

@JsonSerializable()
class Albums {
    @JsonKey(name: "href")
    String href;
    @JsonKey(name: "items")
    List<AlbumItem> items;
    @JsonKey(name: "limit")
    int limit;
    @JsonKey(name: "next")
    String? next;
    @JsonKey(name: "offset")
    int offset;
    @JsonKey(name: "previous")
    dynamic previous;
    @JsonKey(name: "total")
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
    @JsonKey(name: "album_type")
    AlbumTypeEnum albumType;
    @JsonKey(name: "artists")
    List<Artist> artists;
    @JsonKey(name: "available_markets")
    List<String> availableMarkets;
    @JsonKey(name: "external_urls")
    ExternalUrls externalUrls;
    @JsonKey(name: "href")
    String href;
    @JsonKey(name: "id")
    String id;
    @JsonKey(name: "images")
    List<AlbumImage> images;
    @JsonKey(name: "name")
    String name;
    @JsonKey(name: "release_date")
    DateTime releaseDate;
    @JsonKey(name: "release_date_precision")
    ReleaseDatePrecision releaseDatePrecision;
    @JsonKey(name: "total_tracks")
    int totalTracks;
    @JsonKey(name: "type")
    AlbumTypeEnum type;
    @JsonKey(name: "uri")
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

enum AlbumTypeEnum {
    @JsonValue("album")
    ALBUM,
    @JsonValue("ep")
    EP,
    @JsonValue("single")
    SINGLE
}

@JsonSerializable()
class Artist {
    @JsonKey(name: "external_urls")
    ExternalUrls externalUrls;
    @JsonKey(name: "href")
    String href;
    @JsonKey(name: "id")
    String id;
    @JsonKey(name: "name")
    String name;
    @JsonKey(name: "type")
    ArtistType type;
    @JsonKey(name: "uri")
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

@JsonSerializable()
class ExternalUrls {
    @JsonKey(name: "spotify")
    String spotify;

    ExternalUrls({
        required this.spotify,
    });

    factory ExternalUrls.fromJson(Map<String, dynamic> json) => _$ExternalUrlsFromJson(json);

    Map<String, dynamic> toJson() => _$ExternalUrlsToJson(this);
}

enum ArtistType {
    @JsonValue("artist")
    ARTIST
}

@JsonSerializable()
class AlbumImage {
    @JsonKey(name: "height")
    int height;
    @JsonKey(name: "url")
    String url;
    @JsonKey(name: "width")
    int width;

    AlbumImage({
        required this.height,
        required this.url,
        required this.width,
    });

    factory AlbumImage.fromJson(Map<String, dynamic> json) => _$AlbumImageFromJson(json);

    Map<String, dynamic> toJson() => _$AlbumImageToJson(this);
}

enum ReleaseDatePrecision {
    @JsonValue("day")
    DAY
}
