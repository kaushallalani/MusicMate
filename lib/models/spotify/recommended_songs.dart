import 'package:json_annotation/json_annotation.dart';
part 'recommended_songs.g.dart';

@JsonSerializable()
class RecommendedSongs {
    @JsonKey(name: "tracks")
    List<Track> tracks;

    RecommendedSongs({
        required this.tracks,
    });

    factory RecommendedSongs.fromJson(Map<String, dynamic> json) => _$RecommendedSongsFromJson(json);

    Map<String, dynamic> toJson() => _$RecommendedSongsToJson(this);
}

@JsonSerializable()
class Track {
    @JsonKey(name: "album")
    Album album;
    @JsonKey(name: "artists")
    List<Artist> artists;
    @JsonKey(name: "disc_number")
    int discNumber;
    @JsonKey(name: "duration_ms")
    int durationMs;
    @JsonKey(name: "href")
    String href;
    @JsonKey(name: "id")
    String id;
    @JsonKey(name: "name")
    String name;
    @JsonKey(name: "popularity")
    int popularity;
    @JsonKey(name: "preview_url")
    String previewUrl;
    @JsonKey(name: "track_number")
    int trackNumber;
    @JsonKey(name: "type")
    String type;

    Track({
        required this.album,
        required this.artists,
        required this.discNumber,
        required this.durationMs,
        required this.href,
        required this.id,
        required this.name,
        required this.popularity,
        required this.previewUrl,
        required this.trackNumber,
        required this.type,
    });

    factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);

    Map<String, dynamic> toJson() => _$TrackToJson(this);
}

@JsonSerializable()
class Album {
    @JsonKey(name: "album_type")
    String albumType;
    @JsonKey(name: "artists")
    List<Artist> artists;
    @JsonKey(name: "href")
    String href;
    @JsonKey(name: "id")
    String id;
    @JsonKey(name: "images")
    List<TrackImage> images;
    @JsonKey(name: "name")
    String name;
    @JsonKey(name: "type")
    String type;

    Album({
        required this.albumType,
        required this.artists,
        required this.href,
        required this.id,
        required this.images,
        required this.name,
        required this.type,
    });

    factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);

    Map<String, dynamic> toJson() => _$AlbumToJson(this);
}

@JsonSerializable()
class Artist {
    @JsonKey(name: "href")
    String href;
    @JsonKey(name: "id")
    String id;
    @JsonKey(name: "name")
    String name;
    @JsonKey(name: "type")
    String type;

    Artist({
        required this.href,
        required this.id,
        required this.name,
        required this.type,
    });

    factory Artist.fromJson(Map<String, dynamic> json) => _$ArtistFromJson(json);

    Map<String, dynamic> toJson() => _$ArtistToJson(this);
}

@JsonSerializable()
class TrackImage {
    @JsonKey(name: "height")
    int height;
    @JsonKey(name: "url")
    String url;
    @JsonKey(name: "width")
    int width;

    TrackImage({
        required this.height,
        required this.url,
        required this.width,
    });

    factory TrackImage.fromJson(Map<String, dynamic> json) => _$TrackImageFromJson(json);

    Map<String, dynamic> toJson() => _$TrackImageToJson(this);
}
