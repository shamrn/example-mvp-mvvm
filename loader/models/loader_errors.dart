import 'package:freezed_annotation/freezed_annotation.dart';

part 'loader_errors.freezed.dart';

@freezed
class LoaderErrors with _$LoaderErrors {
  const factory LoaderErrors({
    @Default(false) bool isError,
  }) = _LoaderErrors;
}
