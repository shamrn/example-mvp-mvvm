import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prime_ballet/common/extensions/localization_extension.dart';
import 'package:prime_ballet/common/models/personal_settings_redirect_type.dart';
import 'package:prime_ballet/common/providers/consumer_state_with_provider.dart';
import 'package:prime_ballet/common/routes.dart';
import 'package:prime_ballet/common/ui/app_text_styles.dart';
import 'package:prime_ballet/initial/loader/models/loader_redirect_type.dart';
import 'package:prime_ballet/initial/loader/provider/loader_provider.dart';
import 'package:prime_ballet/initial/loader/provider/loader_state.dart';

class LoaderPage extends ConsumerStatefulWidget {
  const LoaderPage({super.key});

  @override
  ConsumerState<LoaderPage> createState() => _LoaderState();
}

class _LoaderState
    extends ConsumerStateWithProvider<LoaderProvider, LoaderState, LoaderPage> {
  void _listenToRedirectPage(LoaderState? previous, LoaderState next) {
    if (next.loaderRedirectType != null) {
      switch (next.loaderRedirectType!) {
        case LoaderRedirectType.onboarding:
          Navigator.of(context).pushReplacementNamed(Routes.initialOnboarding);
        case LoaderRedirectType.auth:
          Navigator.of(context).pushReplacementNamed(Routes.auth);
      }
    }

    if (next.personalSettingsRedirectHelperType != null) {
      switch (next.personalSettingsRedirectHelperType!) {
        case PersonalSettingsRedirectType.authSignUpPersonalSettingsOneStep:
          Navigator.of(context)
              .pushReplacementNamed(Routes.authSignUpPersonalSettingsOneStep);

        case PersonalSettingsRedirectType.authSignUpPersonalSettingsTwoStep:
          Navigator.of(context)
              .pushReplacementNamed(Routes.authSignUpPersonalSettingsTwoStep);
        case PersonalSettingsRedirectType
              .authSignUpPersonalSettingsThirdStepBeginnerAverage:
          Navigator.of(context).pushReplacementNamed(
            Routes.authSignUpPersonalSettingsThirdStepBeginnerAverage,
          );
        case PersonalSettingsRedirectType
              .authSignUpPersonalSettingsThirdStepPro:
          Navigator.of(context).pushReplacementNamed(
            Routes.authSignUpPersonalSettingsThirdStepPro,
          );
        case PersonalSettingsRedirectType.home:
          Navigator.of(context).pushReplacementNamed(Routes.home);
      }
    }
  }

  Widget _buildBody() {
    ref.listen(provider, _listenToRedirectPage);

    final state = ref.watch(provider);

    if (state.errors?.isError ?? false) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Text(
          context.locale.loaderError,
          textAlign: TextAlign.center,
          style: AppTextStyles.latoMedium.copyWith(fontSize: 18.sp),
        ),
      );
    }

    return const CircularProgressIndicator();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _buildBody(),
        ),
      ),
    );
  }
}
