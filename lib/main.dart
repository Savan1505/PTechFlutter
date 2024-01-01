import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/preference/shared_preference.dart';
import 'package:ptecpos_mobile/core/routes/app_router.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_constants.dart';
import 'package:ptecpos_mobile/core/utils/flavors.dart';
import 'package:ptecpos_mobile/features/authentication/ui/pages/splash_page.dart';

void mainConfig(Flavors flavors) async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPreferencesUtils().init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppRouteManager.navigatorKey,
      onGenerateRoute: AppRouteManager.onGenerateRoute,
      title: "PTECPOS",
      key: key,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.colorPrimary,
        fontFamily: AppConstants.fontFamily,
      ),
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
      ],
      home: FutureBuilder(
        future: AppI18n.loadTranslations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return I18n(
              child: const SplashPage(),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
