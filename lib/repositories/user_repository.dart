import 'package:logger/logger.dart';
import 'package:musicmate/models/session.dart';
import 'package:musicmate/models/user.dart';

class UserRepository {
  UserModel? _userDataModel;
  SessionModel? _sessionModel;
  String? _accessToken;
  DateTime? _tokenExpirationTime;

  UserModel? get userDataModel => _userDataModel;
  SessionModel? get sessionDataModel => _sessionModel;
  String? get accessToken => _accessToken;
  DateTime? get tokenExpirationTime => _tokenExpirationTime;

  void saveUserData(UserModel userData) {
    _userDataModel = userData;
  }

  void saveSessionData(SessionModel sessionData) {
    Logger().d('save session => ${sessionData.sessionName}');
    _sessionModel = sessionData;
  }

  void saveAccessToken(String accessToken, DateTime tokenExpirationTime) {
    _accessToken = accessToken;
    _tokenExpirationTime= tokenExpirationTime;
  }
}
