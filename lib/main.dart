import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_doit/constants.dart';
import 'package:flutter_doit/data/app_settings.dart';
import 'package:flutter_doit/pages/backdrop.dart';
import 'package:flutter_doit/pages/home.dart';
import 'package:flutter_doit/pages/splash.dart';
// import 'package:flutter_doit/pages/splash.dart';
import 'package:flutter_doit/routes.dart';
import 'package:flutter_doit/theme/flutter_doit_theme_data.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    this.initialRoute = "/",
    this.isTestMode = false,
  }) : super(key: key);

  final String? initialRoute;
  final bool? isTestMode;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ModelBinding(
        initialModel: AppSettings(
            themeMode: ThemeMode.system,
            textScaleFactor: systemTextScaleFactorOption,
            customTextDirection: CustomTextDirection.localeBased,
            locale: null,
            timeDilation: timeDilation,
            platform: defaultTargetPlatform,
            isTestMode: isTestMode),
        child: Builder(
          builder: (context) {
            return MaterialApp(
              scrollBehavior:
                  const MaterialScrollBehavior().copyWith(scrollbars: false),
              title: 'Flutter Doit',
              debugShowCheckedModeBanner: false,
              themeMode: AppSettings.of(context).themeMode,
              theme: FlutterDoitThemeData.lightThemeData.copyWith(
                platform: AppSettings.of(context).platform,
              ),
              darkTheme: FlutterDoitThemeData.darkThemeData.copyWith(
                platform: AppSettings.of(context).platform,
              ),
              // // localizationsDelegates: const [
              // //   ...GalleryLocalizations.localizationsDelegates,
              // //   LocaleNamesLocalizationsDelegate()
              // // ],
              // // supportedLocales: GalleryLocalizations.supportedLocales,
              initialRoute: initialRoute,
              locale: AppSettings.of(context).locale,
              localeListResolutionCallback: (locales, supportedLocales) {
                deviceLocale = locales?.first;
                return basicLocaleListResolution(locales, supportedLocales);
              },
              onGenerateRoute: RouteConfiguration.onGenerateRoute,
            );
          },
        ));
  }
}

class RootPage extends StatelessWidget {
  const RootPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ApplyTextOptions(
      child: SplashPage(
        child: HomePage(),
      ),
    );
  }
}
