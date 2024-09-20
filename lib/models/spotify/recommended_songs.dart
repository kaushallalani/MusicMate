import 'package:json_annotation/json_annotation.dart';

import 'albums_data.dart';
part 'recommended_songs.g.dart';

@JsonSerializable()
class Tracks {
    @JsonKey(name: "tracks")
    List<Track>? tracks;
    @JsonKey(name: "seeds")
    List<Seed>? seeds;

    Tracks({
        this.tracks,
        this.seeds,
    });

    factory Tracks.fromJson(Map<String, dynamic> json) => _$TracksFromJson(json);

    Map<String, dynamic> toJson() => _$TracksToJson(this);
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
    AlbumItem? album;
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
class ExternalIds {
    @JsonKey(name: "isrc")
    String? isrc;

    ExternalIds({
        this.isrc,
    });

    factory ExternalIds.fromJson(Map<String, dynamic> json) => _$ExternalIdsFromJson(json);

    Map<String, dynamic> toJson() => _$ExternalIdsToJson(this);
}
