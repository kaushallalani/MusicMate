import 'package:json_annotation/json_annotation.dart';
part 'recommended_songs.g.dart';

@JsonSerializable()
class RecommendedSongs {
    @JsonKey(name: "tracks")
    List<Track>? tracks;
    @JsonKey(name: "seeds")
    List<Seed>? seeds;

    RecommendedSongs({
        this.tracks,
        this.seeds,
    });

    factory RecommendedSongs.fromJson(Map<String, dynamic> json) => _$RecommendedSongsFromJson(json);

    Map<String, dynamic> toJson() => _$RecommendedSongsToJson(this);
}

@JsonSerializable()
class Seed {
    @JsonKey(name: "initialPoolSize")
    int? initialPoolSize;
    @JsonKey(name: "afterFilteringSize")
    int? afterFilteringSize;
    @JsonKey(name: "afterRelinkingSize")
    int? afterRelinkingSize;
    @JsonKey(name: "id")
    String? id;
    @JsonKey(name: "type")
    String? type;
    @JsonKey(name: "href")
    String? href;

    Seed({
        this.initialPoolSize,
        this.afterFilteringSize,
        this.afterRelinkingSize,
        this.id,
        this.type,
        this.href,
    });

    factory Seed.fromJson(Map<String, dynamic> json) => _$SeedFromJson(json);

    Map<String, dynamic> toJson() => _$SeedToJson(this);
}

@JsonSerializable()
class Track {
    @JsonKey(name: "album")
    Album? album;
    @JsonKey(name: "artists")
    List<Artist>? artists;
    @JsonKey(name: "available_markets")
    List<String>? availableMarkets;
    @JsonKey(name: "disc_number")
    int? discNumber;
    @JsonKey(name: "duration_ms")
    int? durationMs;
    @JsonKey(name: "explicit")
    bool? explicit;
    @JsonKey(name: "external_ids")
    ExternalIds? externalIds;
    @JsonKey(name: "external_urls")
    ExternalUrls? externalUrls;
    @JsonKey(name: "href")
    String? href;
    @JsonKey(name: "id")
    String? id;
    @JsonKey(name: "is_local")
    bool? isLocal;
    @JsonKey(name: "name")
    String? name;
    @JsonKey(name: "popularity")
    int? popularity;
    @JsonKey(name: "preview_url")
    String? previewUrl;
    @JsonKey(name: "track_number")
    int? trackNumber;
    @JsonKey(name: "type")
    String? type;
    @JsonKey(name: "uri")
    String? uri;

    Track({
        this.album,
        this.artists,
        this.availableMarkets,
        this.discNumber,
        this.durationMs,
        this.explicit,
        this.externalIds,
        this.externalUrls,
        this.href,
        this.id,
        this.isLocal,
        this.name,
        this.popularity,
        this.previewUrl,
        this.trackNumber,
        this.type,
        this.uri,
    });

    factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);

    Map<String, dynamic> toJson() => _$TrackToJson(this);
}

@JsonSerializable()
class Album {
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
    List<TrackImage>? images;
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

    Album({
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

    factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);

    Map<String, dynamic> toJson() => _$AlbumToJson(this);
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
    Type? type;
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

enum Type {
    @JsonValue("artist")
    ARTIST
}

@JsonSerializable()
class TrackImage {
    @JsonKey(name: "height")
    int? height;
    @JsonKey(name: "url")
    String? url;
    @JsonKey(name: "width")
    int? width;

    TrackImage({
        this.height,
        this.url,
        this.width,
    });

    factory TrackImage.fromJson(Map<String, dynamic> json) => _$TrackImageFromJson(json);

    Map<String, dynamic> toJson() => _$TrackImageToJson(this);
}

@JsonSerializable()
class ExternalIds {
    @JsonKey(name: "isrc")
    String? isrc;

    ExternalIds({
        this.isrc,
    });

    factory ExternalIds.fromJson(Map<String, dynamic> json) => _$ExternalIdsFromJson(json);

    Map<String, dynamic> toJson() => _$ExternalIdsToJson(this);
}
