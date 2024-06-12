import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class UserModel {
  final String? id;
  final String? email;
  final String? fullName;
  final String? createdAt;
  final String? updatedAt;

  factory UserModel.fromJson(Map<String, dynamic?> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic?> toJson() => _$UserModelToJson(this);

  UserModel(
      {this.id, this.email, this.fullName, this.createdAt, this.updatedAt});
}
