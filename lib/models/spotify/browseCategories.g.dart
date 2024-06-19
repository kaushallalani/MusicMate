// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'browseCategories.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrowseCategories _$BrowseCategoriesFromJson(Map<String, dynamic> json) =>
    BrowseCategories(
      categories:
          Categories.fromJson(json['categories'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BrowseCategoriesToJson(BrowseCategories instance) =>
    <String, dynamic>{
      'categories': instance.categories,
    };

Categories _$CategoriesFromJson(Map<String, dynamic> json) => Categories(
      href: json['href'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
      limit: (json['limit'] as num).toInt(),
      next: json['next'] as String,
      offset: (json['offset'] as num).toInt(),
      previous: json['previous'],
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$CategoriesToJson(Categories instance) =>
    <String, dynamic>{
      'href': instance.href,
      'items': instance.items,
      'limit': instance.limit,
      'next': instance.next,
      'offset': instance.offset,
      'previous': instance.previous,
      'total': instance.total,
    };

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      href: json['href'] as String,
      id: json['id'] as String,
      icons: (json['icons'] as List<dynamic>)
          .map((e) => CategoryIcon.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'href': instance.href,
      'id': instance.id,
      'icons': instance.icons,
      'name': instance.name,
    };

CategoryIcon _$CategoryIconFromJson(Map<String, dynamic> json) => CategoryIcon(
      height: (json['height'] as num).toInt(),
      url: json['url'] as String,
      width: (json['width'] as num).toInt(),
    );

Map<String, dynamic> _$CategoryIconToJson(CategoryIcon instance) =>
    <String, dynamic>{
      'height': instance.height,
      'url': instance.url,
      'width': instance.width,
    };
