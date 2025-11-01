import 'package:d_session/d_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_idea_app/core/di.dart';
import 'package:photo_idea_app/presentation/pages/dashboard_page.dart';
import 'package:photo_idea_app/presentation/pages/onboarding_page.dart';
import 'package:photo_idea_app/presentation/pages/search_photo_page.dart';

import 'presentation/pages/detail_photo_page.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Future.delayed(Duration(milliseconds: 2000), () {
    FlutterNativeSplash.remove();
  });
  initInjection();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      routes: {
        '/': (context) => FutureBuilder(
              future: DSession.getCustom('see_onboarding'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  print('Error loading preference: ${snapshot.error}');
                  return OnboardingPage();
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == null) return OnboardingPage();
                  return DashboardPage();
                }
                return SizedBox();
              },
            ),
        SearchPhotoPage.routeName: (context) {
          final query = ModalRoute.of(context)?.settings.arguments as String;
          return SearchPhotoPage(query: query);
        },
        DetailPhotoPage.routeName: (context) {
          final id = ModalRoute.of(context)?.settings.arguments as int;
          return DetailPhotoPage(id: id);
        },
      },
    );
  }
}
