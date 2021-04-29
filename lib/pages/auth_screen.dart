import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sign_up_screen.dart';
import 'sign_in_screen.dart';
import 'home_page.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  double alto;
  double ancho;
  FirebaseAuth auth;

  @override
  void initState() {
    auth = FirebaseAuth.instance;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).cardColor,
            ),
          );
        }
        if (snapshot.hasData) {
          return HomeScreen(
            userName: snapshot.data.displayName,
            userID: snapshot.data.uid,
          );
        } else {
          return AuthScreenContent();
        }
      },
    );
  }
}

class AuthScreenContent extends StatefulWidget {
  @override
  _AuthScreenContentState createState() => _AuthScreenContentState();
}

class _AuthScreenContentState extends State<AuthScreenContent> {
  double alto;
  double ancho;
  @override
  Widget build(BuildContext context) {
    alto = MediaQuery.of(context).size.height;
    ancho = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Center(
                  child: Column(
                children: [
                  Container(
                    height: alto * 0.3,
                    child: Stack(children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: alto * 0.5,
                          width: ancho * 0.7,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).cardColor,
                                  Theme.of(context).accentColor
                                ],
                              ),
                              borderRadius: BorderRadius.circular(200)),
                        ),
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: Image.asset('assets/lista_vector.png'))
                    ]),
                  ),
                  SizedBox(
                    height: alto * 0.05,
                  ),
                  Text(
                    'ToDoApp',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 50,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: alto * 0.05,
                  ),
                  Container(
                    width: ancho * 0.6,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AuthSignUpScreen()),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Theme.of(context).cardColor;
                            return Theme.of(context)
                                .accentColor; // Use the component's default.
                          },
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          'Registrarme',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: alto * 0.05,
                  ),
                  Container(
                    width: ancho * 0.6,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AuthSignInScreen()),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Theme.of(context).accentColor;
                            return Theme.of(context)
                                .cardColor; // Use the component's default.
                          },
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        child: Text(
                          'Iniciar Sesión',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  )
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }
}
