import 'package:doit_calendar_todo/data/schedule.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:doit_calendar_todo/constants.dart';
import 'package:doit_calendar_todo/data/app_settings.dart';
import 'package:doit_calendar_todo/pages/backdrop.dart';
import 'package:doit_calendar_todo/pages/home.dart';
import 'package:doit_calendar_todo/pages/splash.dart';
import 'package:doit_calendar_todo/routes.dart';
import 'package:doit_calendar_todo/theme/flutter_doit_theme_data.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;

  initializeDateFormatting().then((_) => runApp(const MyApp()));
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
    return ApplyTextOptions(
      child: SplashPage(
          child: ChangeNotifierProvider(
        create: (_) => AppCalenderScheduler(),
        child: const HomePage(),
      )),
    );
  }
}
