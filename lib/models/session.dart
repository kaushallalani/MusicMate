import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:musicmate/models/user.dart';

part 'session.g.dart';

@JsonSerializable()
class SessionModel {
  final String? id;
  final String? sessionName;
  final String? ownerId;
  final String? currentSongId;
  final List<UserModel>? allUsers;
  final String? createdAt;
  final String? updatedAt;

  SessionModel({
    this.id,
    this.sessionName,
    this.ownerId,
    this.currentSongId,
    this.allUsers,
    this.createdAt,
    this.updatedAt,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SessionModelToJson(this);
}
