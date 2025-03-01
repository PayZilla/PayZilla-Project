import 'package:flutter/material.dart';
import 'package:pay_zilla/config/config.dart';
import 'package:pay_zilla/core/core.dart';
import 'package:pay_zilla/features/auth/auth.dart';
import 'package:pay_zilla/features/navigation/navigation.dart';
import 'package:pay_zilla/features/ui_widgets/ui_widgets.dart';
import 'package:pay_zilla/functional_utils/functional_utils.dart';
import 'package:provider/provider.dart';

class CountryScreen extends StatefulWidget {
  const CountryScreen({Key? key}) : super(key: key);

  @override
  State<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> with FormMixin {
  AuthParams requestDto = AuthParams.empty();
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();

    return AppScaffold(
      appBar: CustomAppBar(
        leading: AppBoxedButton(
          onPressed: () =>
              AppNavigator.of(context).push(AppRoutes.onboardingAuth),
        ),
      ),
      body: Form(
        key: formKey,
        autovalidateMode: autoValidateMode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Country of Residence',
              style: context.textTheme.headlineLarge!.copyWith(
                color: AppColors.textHeaderColor,
                fontWeight: FontWeight.w700,
                fontSize: Insets.dim_24,
              ),
              textAlign: TextAlign.start,
            ),
            const YBox(Insets.dim_8),
            Text(
              'Please select all the countries that you’re a tax resident in',
              style: context.textTheme.bodyMedium!.copyWith(
                color: AppColors.textBodyColor,
                fontWeight: FontWeight.w400,
                fontSize: Insets.dim_16,
              ),
              textAlign: TextAlign.start,
            ),
            const YBox(Insets.dim_40),
            ClickableFormField(
              hintText: 'Select country',
              controller: TextEditingController(
                text: registeringCountries.first.currencyCode,
              ),
              validator: (input) => Validators.validateString()(input),
              onPressed: () async {
                await showCountry(context: context, provider: provider)
                    .show(context);
              },
            ),
            const Spacer(),
            AppSolidButton(
              textTitle: 'Continue',
              showLoading: provider.onboardingResp.isLoading,
              action: () => validate(() async {
                await provider.initializeBvn(context).then((value) {
                  if (provider.onboardingResp.isSuccess) {
                    AppNavigator.of(context).push(AppRoutes.countryToBvn);
                  }
                });
              }),
            ),
            const YBox(Insets.dim_20),
            if (provider.onboardingResp.isLoading)
              const SizedBox.shrink()
            else
              Center(
                child: TextButton(
                  onPressed: () {
                    AppNavigator.of(context).push(AppRoutes.home);
                  },
                  child: Text(
                    'SKIP',
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: AppColors.textHeaderColor,
                      fontWeight: FontWeight.w800,
                      fontSize: Insets.dim_18,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
