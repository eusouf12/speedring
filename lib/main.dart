import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import 'package:speedring/core/dependency/dependency_injection.dart';
import 'package:speedring/helper/guest_checker.dart';
import 'package:speedring/service/deeplink_service.dart';
import 'package:speedring/view/language/app_translate.dart';
import 'package:speedring/view/language/language_helper.dart';

import 'utils/app_colors/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GuestChecker.init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  // Load language settings
  final locale = await LanguageHelper.getSavedLocale();

  runApp(MyApp(initialLocale: locale));
  // Initialize deep links
  await DeepLinkService().initDeepLinks();
}

class MyApp extends StatelessWidget {
  final Locale initialLocale;
  const MyApp({super.key, required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: const Size(393, 852),
      child: GetMaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.transparent,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: AppColors.yellow,
            selectionHandleColor: AppColors.yellow,
            selectionColor: Colors.white24,
          ),
          appBarTheme: const AppBarTheme(
            toolbarHeight: 65,
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: AppColors.white),
          ),
        ),
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
        translations: AppTranslate(),
        locale: initialLocale,
        fallbackLocale: const Locale('en'),
        initialBinding: DependencyInjection(),
        initialRoute: AppRoutes.splashScreen,
        navigatorKey: Get.key,
        getPages: AppRoutes.routes,
      ),
    );
  }
}
