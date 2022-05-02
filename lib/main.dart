import 'package:flutter/material.dart';
import 'package:leadoneattendance/screens/mainpage_screen_user.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
import 'package:leadoneattendance/screens/screens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:leadoneattendance/services/supported_locales.dart';

void main() async {
  //Verifica que la Localización y el Framework-Fuente están inicializados correctamente.
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  //Carga de la localización
  runApp(EasyLocalization(
    child: const MyApp(),
    supportedLocales: supportedLocales,
    fallbackLocale: english, //Idioma por defecto.
    path: 'assets/resources/langs',
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context
            .supportedLocales, // Obtiene el listado de idiomas soportados.
        locale: context.locale,
        debugShowCheckedModeBanner:
            false, //Quita la cinta de 'debug' del superior derecho.
        title: 'Lead One: Attendance App',
        theme: AppTheme
            .lightTheme, // Tema de la aplicación, carga el App Theme de la carpeta Themes.
        routes: {
            '/': (BuildContext context) => const LoadingScreen(),
            '/LoginScreen': (BuildContext context) => const LoginScreen(),
            '/ChangePassword': (BuildContext context) => const ChangePasswordScreen(),
    //A D M I N
            '/MainScreenAdmin': (BuildContext context) => const MainScreenAdmin(),
            '/AddUserScreen' : (BuildContext context) => const AddUserScreen(),
            '/DisplayRecordScreenAdmin' : (BuildContext context) => const DisplayRecordScreenAdmin(),
            '/InsertRecordScreenAdmin' : (BuildContext context) => const InsertRecordScreenAdmin(),
            '/EdittRecordScreenAdmin' : (BuildContext context) => const EditRecordScreenAdmin(),
            '/QueryRecordsScreenAdmin' : (BuildContext context) => const QueryRecordsScreenAdmin(),
            '/GenerateReportsScreenAdmin' : (BuildContext context) => const GenerateReportsScreen(),
            '/ReportViewerScreen' : (BuildContext context) => const ReportViewerScreen(),
            '/SendReportScreen': (BuildContext context) => const SendReportScreen(),
    //U S E R 
            '/MainScreenUser': (BuildContext context) => const MainScreenUser(),
            '/DisplayRecordScreenUser' : (BuildContext context) => const DisplayRecordScreenUser(),
            '/InsertRecordScreenUser': (BuildContext context) => const InsertRecordScreenUser(),
            '/EditRecordScreenUser' : (BuildContext context) => const EditRecordScreenAdmin(),
            '/QueryRecordScreenUser' : (BuildContext context) => const InsertRecordScreenUser(),

      },
    );
  }
}
