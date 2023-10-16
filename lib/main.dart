import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:samsung_sss_flutter/const/app_color.dart';
import 'package:samsung_sss_flutter/const/localization.dart';
import 'package:samsung_sss_flutter/routes/approutes.dart';
import 'package:firebase_core/firebase_core.dart';

import 'const/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }

  // This widget is the root of your application.
}

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

class _MyApp extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'main_navigator');

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver analyticsObserver =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  void initState() {
    configEasyLoading();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 892),
      minTextAdapt: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Samsung Smart Safety',
        theme: ThemeData(
          primarySwatch: AppColor().createMaterialColor(AppColor.samsungBlue),
        ),
        onGenerateRoute: AppRoutes.generatedRoute,
        initialRoute: AppRoutes.splashScreenRoute,
        navigatorKey: navigatorKey,
        locale: const Locale(Constants.ENGLISH_LANG),
        supportedLocales: const [Locale("en")],
        localizationsDelegates: const [
          MyLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale!.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        navigatorObservers: <NavigatorObserver>[
          routeObserver,
          analyticsObserver
        ],
        builder: (context, child) {
          return MediaQuery(
            child: FlutterEasyLoading(child: child),
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          );
        },
      ),
    );
  }
}

void configEasyLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.grey
    ..backgroundColor = Colors.white
    ..indicatorColor = Colors.grey
    ..textColor = Colors.white
    ..maskColor = Colors.black.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}
