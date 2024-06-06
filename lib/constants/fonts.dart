import 'package:flutter_screenutil/flutter_screenutil.dart';

class Fonts {
  // Font family definitions
  static const String roboto = 'Roboto';

  // Font sizes
  static FontSize size = FontSize();
  // Scale functions
  static double scale(double size) => ScreenUtil().setWidth(size);
  static double verticalScale(double size) => ScreenUtil().setHeight(size);
  static double moderateScale(double size, [double factor = 0.5]) =>
      size + (scale(size) - size) * factor;
}

class FontSize {
  static double xxxlarge = 90.0;
  static const double xxlarge = 40.0;
  static const double xmlarge = 35.0;
  static const double xlarge = 30.0;
  static const double content = 21.0;
  static const double large = 25.0;
  static const double xmedium = 20.0;
  static const double smedium = 19.0;
  static const double medium = 18.0;
  static  const double normal = 16.0;
  static const double snormal = 15.0;
  static const double small = 14.0;
  static const double msmall = 13.0;
  static const double xsmall = 12.0;
  static const double xmsmall = 11.0;
  static const double xxsmall = 10.0;
  static const double smallest = 9.0;
  static var item = 20.0;
}
