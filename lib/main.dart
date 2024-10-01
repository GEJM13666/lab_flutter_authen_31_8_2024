import 'package:flutter/material.dart';
import 'views/login_page.dart';
import 'views/register_page.dart';
import 'views/admin_page.dart';
import 'views/user_page.dart';
import 'package:provider/provider.dart';
import './providers/user_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Authentication App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.orange,
          backgroundColor: Colors.brown[50],
          brightness: Brightness.light,
        ).copyWith(
          secondary: Colors.amber,
          primary: Colors.deepOrange,
          surface: Colors.brown[100],
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.brown[800],
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.brown[700]),
          bodyMedium: TextStyle(color: Colors.brown[600]),
          headlineLarge: TextStyle(
              color: Colors.deepOrange[800], fontWeight: FontWeight.bold),
          labelLarge: TextStyle(color: Colors.white),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.deepOrange,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/admin': (context) => AdminPage(),
        '/user': (context) => UserPage(),
      },
    );
  }
}
