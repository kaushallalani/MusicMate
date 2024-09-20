import 'package:json_annotation/json_annotation.dart';
part 'albums_data.g.dart';
@JsonSerializable()
class AlbumData {
    @JsonKey(name: "albums")
    Albums? albums;

    AlbumData({
        this.albums,
    });

    factory AlbumData.fromJson(Map<String, dynamic> json) => _$AlbumDataFromJson(json);

    Map<String, dynamic> toJson() => _$AlbumDataToJson(this);
}

@JsonSerializable()
class Albums {
    @JsonKey(name: "href")
    String? href;
    @JsonKey(name: "items")
    List<AlbumItem>? items;
    @JsonKey(name: "limit")
    int? limit;
    @JsonKey(name: "next")
    String? next;
    @JsonKey(name: "offset")
    int? offset;
    @JsonKey(name: "previous")
    dynamic previous;
    @JsonKey(name: "total")
    int? total;

    Albums({
        this.href,
        this.items,
        this.limit,
        this.next,
        this.offset,
        this.previous,
        this.total,
    });

    factory Albums.fromJson(Map<String, dynamic> json) => _$AlbumsFromJson(json);

    Map<String, dynamic> toJson() => _$AlbumsToJson(this);
}

@JsonSerializable()
class AlbumItem {
    @JsonKey(name: "album_type")
    String? albumType;
    @JsonKey(name: "artists")
    List<Artist>? artists;
    @JsonKey(name: "available_markets")
    List<String>? availableMarkets;
    @JsonKey(name: "external_urls")
    ExternalUrls? externalUrls;
    @JsonKey(name: "href")
    String? href;
    @JsonKey(name: "id")
    String? id;
    @JsonKey(name: "images")
    List<AlbumImage>? images;
    @JsonKey(name: "name")
    String? name;
    @JsonKey(name: "release_date")
    DateTime? releaseDate;
    @JsonKey(name: "release_date_precision")
    String? releaseDatePrecision;
    @JsonKey(name: "total_tracks")
    int? totalTracks;
    @JsonKey(name: "type")
    String? type;
    @JsonKey(name: "uri")
    String? uri;

    AlbumItem({
        this.albumType,
        this.artists,
        this.availableMarkets,
        this.externalUrls,
        this.href,
        this.id,
        this.images,
        this.name,
        this.releaseDate,
        this.releaseDatePrecision,
        this.totalTracks,
        this.type,
        this.uri,
    });

    factory AlbumItem.fromJson(Map<String, dynamic> json) => _$AlbumItemFromJson(json);

    Map<String, dynamic> toJson() => _$AlbumItemToJson(this);
}

@JsonSerializable()
class Artist {
    @JsonKey(name: "external_urls")
    ExternalUrls? externalUrls;
    @JsonKey(name: "href")
    String? href;
    @JsonKey(name: "id")
    String? id;
    @JsonKey(name: "name")
    String? name;
    @JsonKey(name: "type")
    String? type;
    @JsonKey(name: "uri")
    String? uri;

    Artist({
        this.externalUrls,
        this.href,
        this.id,
        this.name,
        this.type,
        this.uri,
    });

    factory Artist.fromJson(Map<String, dynamic> json) => _$ArtistFromJson(json);

    Map<String, dynamic> toJson() => _$ArtistToJson(this);
}

@JsonSerializable()
class ExternalUrls {
    @JsonKey(name: "spotify")
    String? spotify;

    ExternalUrls({
        this.spotify,
    });

    factory ExternalUrls.fromJson(Map<String, dynamic> json) => _$ExternalUrlsFromJson(json);

    Map<String, dynamic> toJson() => _$ExternalUrlsToJson(this);
}

@JsonSerializable()
class AlbumImage {
    @JsonKey(name: "height")
    int? height;
    @JsonKey(name: "url")
    String? url;
    @JsonKey(name: "width")
    int? width;

    AlbumImage({
        this.height,
        this.url,
        this.width,
    });

    factory AlbumImage.fromJson(Map<String, dynamic> json) => _$AlbumImageFromJson(json);

    Map<String, dynamic> toJson() => _$AlbumImageToJson(this);
}
