import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:prime_ballet/common/helpers/device_info_helper.dart';
import 'package:prime_ballet/common/helpers/personal_settings_redirect_helper.dart';
import 'package:prime_ballet/common/providers/base_state_notifier.dart';
import 'package:prime_ballet/common/repositories/local_auth_data_repository.dart';
import 'package:prime_ballet/common/repositories/local_locale_repository.dart';
import 'package:prime_ballet/initial/common/repositories/onboarding_repository.dart';
import 'package:prime_ballet/initial/loader/models/initial_device_os_name_type.dart';
import 'package:prime_ballet/initial/loader/models/initial_device_request.dart';
import 'package:prime_ballet/initial/loader/models/loader_errors.dart';
import 'package:prime_ballet/initial/loader/models/loader_redirect_type.dart';
import 'package:prime_ballet/initial/loader/provider/loader_state.dart';
import 'package:prime_ballet/initial/loader/repositories/device_remote_repository.dart';

@injectable
class LoaderProvider extends BaseStateNotifier<LoaderState> {
  LoaderProvider({
    required DeviceInfoHelper deviceInfoHelper,
    required PackageInfo packageInfo,
    required DeviceRemoteRepository deviceRemoteRepository,
    required LocalAuthDataRepository localAuthDataRepository,
    required OnboardingRepository onboardingRepository,
    required PersonalSettingsRedirectHelper personalSettingsRedirectHelper,
    required LocalLocaleRepository localeRepository,
  })  : _deviceInfoHelper = deviceInfoHelper,
        _packageInfo = packageInfo,
        _deviceRemoteRepository = deviceRemoteRepository,
        _localAuthDataRepository = localAuthDataRepository,
        _onboardingRepository = onboardingRepository,
        _personalSettingsRedirectHelper = personalSettingsRedirectHelper,
        _localeRepository = localeRepository,
        super(const LoaderState());

  final DeviceInfoHelper _deviceInfoHelper;
  final PackageInfo _packageInfo;
  final DeviceRemoteRepository _deviceRemoteRepository;
  final LocalAuthDataRepository _localAuthDataRepository;
  final OnboardingRepository _onboardingRepository;
  final PersonalSettingsRedirectHelper _personalSettingsRedirectHelper;
  final LocalLocaleRepository _localeRepository;

  @override
  Future<void> onInit() async {
    try {
      await _initDevice();

      final loaderRedirectType = await _loaderRedirectType;
      final personalSettingsRedirectType = loaderRedirectType == null
          ? await _personalSettingsRedirectHelper.redirectType
          : null;

      state = state.copyWith(
        loaderRedirectType: loaderRedirectType,
        personalSettingsRedirectHelperType: personalSettingsRedirectType,
      );
    } on Exception catch (_) {
      state = state.copyWith(errors: const LoaderErrors(isError: true));
    }
  }

  Future<void> _initDevice() async {
    await _deviceInfoHelper.init();

    final locale = await _localeRepository.getCurrentLocale();

    await _deviceRemoteRepository.initial(
      InitialDeviceRequest(
        deviceId: _deviceInfoHelper.id,
        osName: InitialDeviceOsNameType.fromString(
          _deviceInfoHelper.platformName,
        ),
        osVersion: _deviceInfoHelper.version,
        model: _deviceInfoHelper.model,
        appVersion: _packageInfo.version,
        language: locale.languageCode,
      ),
    );
  }

  Future<LoaderRedirectType?> get _loaderRedirectType async {
    final isUserAuthorized = await _localAuthDataRepository.isUserAuthorized;

    if (!isUserAuthorized) {
      return _onboardingRepository.isPassedOnboarding
          ? LoaderRedirectType.auth
          : LoaderRedirectType.onboarding;
    }

    return null;
  }
}
