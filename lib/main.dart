import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_app/pages/auth_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(App());
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
            color: Colors.red,
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return TodoApp();
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TodoApp',
      theme: ThemeData(
        primaryColor: Color(0xFFD5BAD2),
        primaryColorDark: Color(0xFFBB73BB),
        accentColor: Color(0xFFBB73BB),
        backgroundColor: Color(0xFF1A1C21),
        cardColor: Color(0xFF8078DF),
      ),
      home: AuthScreen(),
    );
  }
}
