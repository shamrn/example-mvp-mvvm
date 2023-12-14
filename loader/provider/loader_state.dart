import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:prime_ballet/common/models/personal_settings_redirect_type.dart';
import 'package:prime_ballet/initial/loader/models/loader_errors.dart';
import 'package:prime_ballet/initial/loader/models/loader_redirect_type.dart';

part 'loader_state.freezed.dart';

@freezed
class LoaderState with _$LoaderState {
  const factory LoaderState({
    LoaderRedirectType? loaderRedirectType,
    PersonalSettingsRedirectType? personalSettingsRedirectHelperType,
    LoaderErrors? errors,
  }) = _LoaderState;
}
