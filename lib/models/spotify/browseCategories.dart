import 'package:json_annotation/json_annotation.dart';
part 'browseCategories.g.dart';

@JsonSerializable()
class BrowseCategories {
  Categories categories;

  BrowseCategories({
    required this.categories,
  });
  factory BrowseCategories.fromJson(Map<String, dynamic> json) =>
      _$BrowseCategoriesFromJson(json);

  Map<String, dynamic> toJson() => _$BrowseCategoriesToJson(this);
}

@JsonSerializable()
class Categories {
  String href;
  List<Item> items;
  int limit;
  String next;
  int offset;
  dynamic previous;
  int total;

  Categories({
    required this.href,
    required this.items,
    required this.limit,
    required this.next,
    required this.offset,
    required this.previous,
    required this.total,
  });

  factory Categories.fromJson(Map<String, dynamic> json) =>
      _$CategoriesFromJson(json);

  Map<String, dynamic> toJson() => _$CategoriesToJson(this);
}

@JsonSerializable()
class Item {
  String href;
  String id;
  List<CategoryIcon> icons;
  String name;

  Item({
    required this.href,
    required this.id,
    required this.icons,
    required this.name,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}

@JsonSerializable()
class CategoryIcon {
  int height;
  String url;
  int width;

  CategoryIcon({
    required this.height,
    required this.url,
    required this.width,
  });

  factory CategoryIcon.fromJson(Map<String, dynamic> json) => _$CategoryIconFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryIconToJson(this);
}
