import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_motivation/modules/homePage/bloc/home_page_bloc.dart';
import 'package:flutter_motivation/modules/homePage/screen/home_page.dart';
import 'package:flutter_motivation/constants/assets_color.dart';
import 'package:flutter_motivation/data/repositories/quote_repository.dart';
import 'package:flutter_motivation/modules/webPage/webPage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'modules/searchPage/bloc/search_page_bloc.dart';

//BYPASS CERTIFICATE. IMPORTANT! REMOVE AFTER RELEASE
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  // HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => QuoteRepository(),
          ),
        ],
        child: MultiBlocProvider(
            providers: [
              BlocProvider<HomePageBloc>(
                create: (context) => HomePageBloc(
                    RepositoryProvider.of<QuoteRepository>(context)),
              ),
              BlocProvider<SearchPageBloc>(
                create: (context) => SearchPageBloc(
                    RepositoryProvider.of<QuoteRepository>(context)),
              )
            ],
            child: ScreenUtilInit(
                designSize: const Size(360, 690),
                minTextAdapt: true,
                splitScreenMode: true,
                builder: (context, child) {
                  return MaterialApp(
                      title: 'Motivasi - Kata',
                      theme: ThemeData(
                          brightness: Brightness.light,
                          primarySwatch: AssetsColor.getMaterialColor(
                            AssetsColor.primary,
                          )),
                      darkTheme: ThemeData(
                          brightness: Brightness.dark,
                          primarySwatch: AssetsColor.getMaterialColor(
                            AssetsColor.primary,
                          )),
                      themeMode: ThemeMode.light,
                      home: kIsWeb
                          ? const WebMotivationPage()
                          : const HomePageScreen());
                })));
  }
}
