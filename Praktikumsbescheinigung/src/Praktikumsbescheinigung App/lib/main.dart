import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studybuddy/blocs/bloc_provider.dart';
import 'package:studybuddy/objects/MyHttpOverrides.dart';
import 'package:studybuddy/screens/login_screen.dart';
import 'blocs/data_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return BlocProvider(
    bloc: DataBloc(),
        child: MaterialApp(
      title: 'StudyBuddy',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: MaterialColor(0xff00b1ac, <int, Color> {
          50: Color(0xff00b1ac),
          100: Color(0xff00b1ac),
          200: Color(0xff00b1ac),
          300: Color(0xff00b1ac),
          400: Color(0xff00b1ac),
          500: Color(0xff00b1ac),
          600: Color(0xff00b1ac),
          700: Color(0xff00b1ac),
          800: Color(0xff00b1ac),
          900: Color(0xff00b1ac),
        }),
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
        ),
    );
  }
}