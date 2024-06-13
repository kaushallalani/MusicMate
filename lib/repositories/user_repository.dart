import 'package:musicmate/models/user.dart';

class UserRepository {
  UserModel? _userDataModel;

  UserModel? get userDataModel => _userDataModel;

  void saveUserData(UserModel userData) {
    _userDataModel = userData;
  }
}
