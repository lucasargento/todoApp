import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/Tools/auth_helper.dart';
import 'package:todo_app/pages/add_todo_screen.dart';
import 'package:todo_app/Components/todo_widget.dart';
import 'package:todo_app/Components/barra_de_busqueda.dart';
import 'package:todo_app/Components/botones_de_estado.dart';
import 'package:todo_app/Tools/firestore_helper.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({this.userName, this.userCredential, this.userID});
  String userName;
  String userID;
  UserCredential userCredential;
  @override
  _AHomeScreenState createState() => _AHomeScreenState();
}

class _AHomeScreenState extends State<HomeScreen> {
  double alto;
  double ancho;
  FirebaseAuth auth;
  bool pressedPendientes = true;
  bool pressedTerminados = false;
  double anchoBusqueda;
  double deltaSize = 0;
  TextEditingController busquedaController = TextEditingController();
  String todoBuscado;
  AuthHelper authHelper;
  Future listaDeTodosFutura;
  String statusActualLista = 'pendientes';
  BotonesDeEstado botonesDeEstado;
  String estadoDeLista = 'pendientes';
  String busqueda = '';

  String capitalize(String string) {
    if (string.isEmpty) {
      return string;
    }
    return string[0].toUpperCase() + string.substring(1);
  }

  @override
  void initState() {
    // clear navigation stack!!! pendiente
    authHelper = AuthHelper(context: context);
    busquedaController.addListener(() {
      setState(() {
        if (busquedaController.text != '') {
          busqueda = busquedaController.text;
        } else {
          busqueda = '';
        }
      });
    });
    super.initState();
  }

  void pendientesCallback() {
    setState(() {
      pressedPendientes = true;
      pressedTerminados = false;
      estadoDeLista = 'pendientes';
    });
  }

  void terminadosCallback() {
    setState(() {
      pressedPendientes = false;
      pressedTerminados = true;
      estadoDeLista = 'terminados';
    });
  }

  void logOut() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        content: Container(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Text(
                  'Esta seguro que quiere cerrar sesión?',
                ),
              ),
              TextButton(
                onPressed: () async {
                  await authHelper.logOutUser().then(
                        (value) =>
                            ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                      );
                },
                child: Text('Si'),
              ),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: Text('No'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ancho = MediaQuery.of(context).size.width;
    alto = MediaQuery.of(context).size.height;
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).backgroundColor,
        actions: [
          BarraDeBusqueda(
              anchoBusqueda: anchoBusqueda,
              ancho: ancho,
              alto: alto,
              busquedaController: busquedaController,
              todoBuscado: todoBuscado),
          IconButton(
            icon: Icon(Icons.logout),
            color: Theme.of(context).primaryColor,
            onPressed: logOut,
          ),
        ],
      ),
      floatingActionButton: keyboardIsOpened
          ? Container()
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTodoScreen(
                      userID: widget.userID,
                    ),
                  ),
                );
              },
              child: Icon(Icons.add),
            ),
      body: SingleChildScrollView(
        child: Container(
          height: alto * 0.9,
          width: ancho,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // header bienvenida
                width: ancho * 0.6,
                height: alto * 0.2,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Hola,',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: alto * 0.08,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          widget.userName != null
                              ? capitalize(widget.userName)
                              : '',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: alto * 0.08,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: alto * 0.025,
              ),
              BotonesDeEstado(
                ancho: ancho,
                alto: alto,
                pressedPendientes: pressedPendientes,
                pressedTerminados: pressedTerminados,
                pendientesCallback: pendientesCallback,
                terminadosCallback: terminadosCallback,
              ),
              SizedBox(
                height: alto * 0.025,
              ),
              Container(
                // container del list view
                width: ancho,
                height: alto * 0.56,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: StreamBuilder(
                  stream: FirestoreHelper.getStreamTodosDelUsuario(
                    userID: widget.userID,
                  ),
                  builder: (context, AsyncSnapshot futureList) {
                    if (!futureList.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        List listaPaCumplir = [];
                        setState(() {});
                        return listaPaCumplir;
                      },
                      child: ListView.builder(
                        itemCount: futureList.data.length,
                        itemBuilder: (context, i) {
                          if (futureList.data.length == 1) {
                            // si solo hay un todo, es el default, el usuario no agrego nada aun
                            return Container(
                              child: Column(children: [
                                Image.asset('assets/sentado_vector.png'),
                                SizedBox(height: alto * 0.05),
                                Text(
                                  'Oh! Todavía no creaste ningún ToDo..',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ]),
                            );
                          } else {
                            // si hay mas de 1, es porque agrego..no queremos buildear el default, asique lo salvamos en el siguiente if
                            if (futureList.data[i]['titulo'] !=
                                'null initial todo') {
                              // chequeo que el todo que vaya a buildear sea acorde a los que quiero ver, pendientes o terminados
                              if (futureList.data[i]['estado'] ==
                                  estadoDeLista) {
                                // analizo si se busco algo en el buscador, en caso afirmativo, solo buildear el widget si su titulo contiene la busqueda
                                if (busqueda != '') {
                                  if (futureList.data[i]['titulo']
                                      .toString()
                                      .toLowerCase()
                                      .contains(busqueda.toLowerCase())) {
                                    // finalmente buildear el widget :)
                                    return ToDoWidget(
                                      alto: alto,
                                      deltaSize: deltaSize,
                                      ancho: ancho,
                                      i: i,
                                      futureList: futureList,
                                      userID: widget.userID,
                                    );
                                  } else {
                                    return Container();
                                  }
                                } else {
                                  // si no hay nada buscado, mostrar todos los ToDos
                                  return ToDoWidget(
                                    alto: alto,
                                    deltaSize: deltaSize,
                                    ancho: ancho,
                                    i: i,
                                    futureList: futureList,
                                    userID: widget.userID,
                                  );
                                }
                              } else {
                                return Container();
                              }
                            } else {
                              return Container();
                            }
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
