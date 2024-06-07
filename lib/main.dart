import 'dart:io';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:mhs_application/models/student.dart';
import 'package:mhs_application/screens/wrapper.dart';
import 'package:mhs_application/services/auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase SDK initialization
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCGuKPR91_VUUmDuHWKeFxzf7czwQpC1Xg', 
      appId: '1:997653559531:android:6b8ba984d626c793f1a6ae',
      messagingSenderId: '997653559531',
      projectId: 'mhs-application',
      databaseURL: 'https://mhs-application-default-rtdb.firebaseio.com',
      storageBucket: 'mhs-application.appspot.com'
    ),
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

  // Firebase Crashlytics setup
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterError(errorDetails,
        fatal: !(errorDetails.exception is HttpException ||
            errorDetails.exception is SocketException ||
            errorDetails.exception is HandshakeException ||
            errorDetails.exception is ClientException));
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark),
    );
    return StreamProvider<Student?>.value(
      value: AuthService().studentUserAuthentication,
      initialData: Student(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(textTheme: GoogleFonts.rudaTextTheme()),
        home: const Wrapper(),
      ),
    );
  }
}