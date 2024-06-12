class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String createdAt;
  final String updatedAt;

  UserModel(this.fullName, this.createdAt, this.updatedAt,
      {required this.id, required this.email});
}
