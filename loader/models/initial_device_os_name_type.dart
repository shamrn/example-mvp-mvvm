import 'package:freezed_annotation/freezed_annotation.dart';

enum InitialDeviceOsNameType {
  @JsonValue(0)
  ios,
  @JsonValue(1)
  android;

  static InitialDeviceOsNameType fromString(String value) {
    return values.firstWhere((type) => type.name == value);
  }
}
