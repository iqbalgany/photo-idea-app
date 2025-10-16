import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_idea_app/core/di.dart';
import 'package:photo_idea_app/presentation/pages/dashboard_page.dart';
import 'package:photo_idea_app/presentation/pages/search_photo_page.dart';

void main() {
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
        '/': (context) => DashboardPage(),
        SearchPhotoPage.routeName: (context) {
          final query = ModalRoute.of(context)?.settings.arguments as String;
          return SearchPhotoPage(query: query);
        }
      },
    );
  }
}
