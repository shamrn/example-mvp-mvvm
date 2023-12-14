import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:prime_ballet/initial/loader/models/initial_device_os_name_type.dart';

part 'initial_device_request.freezed.dart';
part 'initial_device_request.g.dart';

@freezed
class InitialDeviceRequest with _$InitialDeviceRequest {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory InitialDeviceRequest({
    required String deviceId,
    required InitialDeviceOsNameType osName,
    required String osVersion,
    required String model,
    required String appVersion,
    required String language,
  }) = _InitialDeviceRequest;

  factory InitialDeviceRequest.fromJson(Map<String, dynamic> json) =>
      _$InitialDeviceRequestFromJson(json);
}
