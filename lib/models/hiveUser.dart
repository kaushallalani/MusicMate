import 'package:hive/hive.dart';
import 'package:musicmate/constants/i18n/strings.g.dart';

part 'hiveUser.g.dart';

@HiveType(typeId: 0)
class UserBox {
  @HiveField(0)
  final AppLocale? appLanguage;

  UserBox({required this.appLanguage});
}

