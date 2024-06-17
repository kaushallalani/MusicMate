// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String?,
      email: json['email'] as String?,
      fullName: json['fullName'] as String?,
      createdAt: const FieldValueConverter().fromJson(json['createdAt']),
      updatedAt: const FieldValueConverter().fromJson(json['updatedAt']),
      deviceUniqueId: json['deviceUniqueId'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'fullName': instance.fullName,
      'deviceUniqueId': instance.deviceUniqueId,
      'createdAt': _$JsonConverterToJson<Object?, FieldValue>(
          instance.createdAt, const FieldValueConverter().toJson),
      'updatedAt': _$JsonConverterToJson<Object?, FieldValue>(
          instance.updatedAt, const FieldValueConverter().toJson),
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
