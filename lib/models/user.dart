import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'fieldvalue_converter.dart';
part 'user.g.dart';

@JsonSerializable()
class UserModel {
  final String? id;
  final String? email;
  final String? fullName;
  final String? deviceUniqueId;
  @FieldValueConverter()
  final FieldValue? createdAt;
  @FieldValueConverter()
  final FieldValue? updatedAt;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromMap(Map<Object, Object?> map) {
    return UserModel(
      id: map['id'] as String,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      deviceUniqueId: map['deviceUniqueId'] as String,
      createdAt: map['createdAt'] as FieldValue,
      updatedAt: map['updatedAt'] as FieldValue,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'deviceUniqueId': deviceUniqueId,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }

  Map<String, dynamic> toMapWithoutNulls() {
    final map = toMap();
    map.removeWhere((key, value) => value == null);
    return map;
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel(
      {this.id,
      this.email,
      this.fullName,
      this.createdAt,
      this.updatedAt,
      this.deviceUniqueId});
}
