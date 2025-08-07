abstract class BaseMapType {
  final String type;

  const BaseMapType(this.type);
}

class AndroidMapType extends BaseMapType {
  const AndroidMapType._(super.type);

  static const default$ = AndroidMapType._("DEFAULT");
  static const lightBlue = AndroidMapType._("LIGHT_BLUE");
  static const grayWhite = AndroidMapType._("GRAY_WHITE");
  static const darkBlue = AndroidMapType._("DARK_BLUE");
}

class IOSMapType extends BaseMapType {
  const IOSMapType._(super.type);

  static const standard = IOSMapType._('standard');
  static const satellite = IOSMapType._('satellite');
  static const hybrid = IOSMapType._('hybrid');
  static const satelliteFlyover = IOSMapType._('satelliteFlyover');
  static const hybridFlyover = IOSMapType._('hybridFlyover');
  static const mutedStandard = IOSMapType._('mutedStandard');
}
