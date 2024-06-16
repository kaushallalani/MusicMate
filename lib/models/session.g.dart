// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionModel _$SessionModelFromJson(Map<String, dynamic> json) => SessionModel(
      id: json['id'] as String?,
      sessionName: json['sessionName'] as String?,
      ownerId: json['ownerId'] as String?,
      currentSongId: json['currentSongId'] as String?,
      allUsers: (json['allUsers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      sessionCode: json['sessionCode'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$SessionModelToJson(SessionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionName': instance.sessionName,
      'ownerId': instance.ownerId,
      'currentSongId': instance.currentSongId,
      'allUsers': instance.allUsers,
      'sessionCode': instance.sessionCode,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
