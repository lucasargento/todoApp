import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/Tools/auth_helper.dart';

class AuthSignInScreen extends StatefulWidget {
  @override
  _AuthSignInScreenState createState() => _AuthSignInScreenState();
}

class _AuthSignInScreenState extends State<AuthSignInScreen> {
  double alto;
  double ancho;
  FirebaseAuth auth;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwController = TextEditingController();
  AuthHelper authHelper;

  bool chequearSignIn() {
    try {
      auth.authStateChanges().listen((User user) {
        if (user == null) {
          print('User is currently signed out!');
          print(user);
          return false;
        } else {
          print('User is signed in!');
          return true;
        }
      });
    } catch (e) {
      print(e);
    }
    return false;
  }

  @override
  void initState() {
    auth = FirebaseAuth.instance;
    authHelper = AuthHelper(context: context);
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ancho = MediaQuery.of(context).size.width;
    alto = MediaQuery.of(context).size.height;

    return chequearSignIn()
        ? Container(
            color: Colors.red,
          )
        : Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              brightness: Brightness.dark,
              elevation: 0,
              backgroundColor: Theme.of(context).backgroundColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Center(
                          child: Column(
                        children: [
                          Container(
                            height: alto * 0.25,
                            child: Image.asset('assets/sign_in_vector.png',
                                fit: BoxFit.fitHeight),
                          ),
                          SizedBox(
                            height: alto * 0.05,
                          ),
                          Text(
                            'ToDoApp',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 40,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: alto * 0.05,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            child: Column(
                              children: [
                                TextField(
                                  controller: emailController,
                                  cursorColor: Theme.of(context).accentColor,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).accentColor),
                                    ),
                                    hintText: 'Email',
                                  ),
                                ),
                                SizedBox(
                                  height: alto * 0.05,
                                ),
                                TextField(
                                  controller: passwController,
                                  obscureText: true,
                                  cursorColor: Theme.of(context).accentColor,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).accentColor),
                                    ),
                                    hintText: 'Contraseña',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: alto * 0.05,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              authHelper.logInUser(
                                email: emailController.text,
                                password: passwController.text,
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
                                'Iniciar Sesión',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          )
                        ],
                      )),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
