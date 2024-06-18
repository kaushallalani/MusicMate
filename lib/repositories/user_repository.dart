import 'package:logger/logger.dart';
import 'package:musicmate/models/session.dart';
import 'package:musicmate/models/user.dart';

class UserRepository {
  UserModel? _userDataModel;
  SessionModel? _sessionModel;

  UserModel? get userDataModel => _userDataModel;
  SessionModel? get sessionDataModel => _sessionModel;

  void saveUserData(UserModel userData) {
    _userDataModel = userData;
  }

  void saveSessionData(SessionModel sessionData) {
    Logger().d('save session => ${sessionData.sessionName}');
    _sessionModel = sessionData;
  }
}
