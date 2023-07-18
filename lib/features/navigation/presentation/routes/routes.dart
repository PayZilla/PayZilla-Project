import 'package:pay_zilla/features/navigation/navigation.dart';

class AppRoutes {
//splash screen first
  static const splash = '/splash';

  //onboarding screen and where you can go and come from Onboarding
  static const onboarding = '/onboarding';
  static const onboardingAuth = '/onboarding/auth';

  // recovery screen
  static const authToRecovery = '/auth/recovery';
  static const authToSignUp = '/auth/sign-up';
  static const recoveryToVerify = '/auth/recovery/verify';
  static const verifyToPassword = '/auth/recovery/verify/new-password';

  // biometric
  static const biometric = '/biometric';

  // country of residence, onboarding reasons, pin
  static const pin = '/pin';

  static const country = '/pin/country';
  static const countryToBvn = '/pin/country/bvn-verification';
  static const bvnToReasons = '/pin/country/bvn-verification/reasons';
  static const reasonsToPin = '/pin/country/bvn-verification/reasons/pin';

  static String tab(AppNavTab tab) {
    return '/tab/${tab.toString().split('.').last}';
  }

  //bottom tab routes
  static const home = '/tab/home';
  static const myCard = '/tab/card';
  static const activity = '/tab/activity';
  static const profile = '/tab/profile';

  /// Scanner routes
  static const qrScan = '/tab/home/qr-scanner';
  static const qrShowScan = '/tab/home/qr-show-scanner';

  // My cards
  static const startCreateCard = '/tab/card/start-create-card';
  static const chooseCardStyle =
      '/tab/card/start-create-card/choose-card-style';
  static const editCardScreen =
      '/tab/card/start-create-card/choose-card-style/edit-card';
}
