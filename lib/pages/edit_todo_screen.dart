import 'package:flutter/material.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:todo_app/Tools/firestore_helper.dart';

class EditTodoScreen extends StatefulWidget {
  EditTodoScreen({@required this.userID, @required this.todo});
  String userID;
  dynamic todo;
  @override
  _EditTodoScreenState createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  double alto;
  double ancho;
  TextEditingController titleController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();

  void triggerEditTodo() async {
    bool tituloValido = await FirestoreHelper.puedeUsarseElTitulo(
        userID: widget.userID, titulo: titleController.text);
    if (tituloValido) {
      await FirestoreHelper.editarTodo(
        userID: widget.userID,
        titulo: widget.todo['tituloOriginal'],
        nuevoTitulo: titleController.text,
        descripcion: descripcionController.text,
      ).then(
        (value) {
          Navigator.pop(context);
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Los titulos de los Todos no pueden estar repetidos!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    alto = MediaQuery.of(context).size.height;
    ancho = MediaQuery.of(context).size.width;
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          'Editando: ${widget.todo['titulo']}',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
              fontSize: 25),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      floatingActionButton: keyboardIsOpened
          ? Container()
          : FloatingActionButton(
              onPressed: () {
                print('~~apretamos el boton animado :)~~');
              },
              child: ProgressButton(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                strokeWidth: 2,
                color: Theme.of(context).accentColor,
                progressIndicatorColor: Theme.of(context).primaryColor,
                child: Icon(Icons.check, color: Theme.of(context).primaryColor),
                onPressed: (AnimationController controller) {
                  triggerEditTodo();
                  if (controller.isCompleted) {
                    controller.reverse();
                  } else {
                    controller.forward();
                  }
                },
              ),
            ),
      body: SingleChildScrollView(
        child: Container(
          height: alto,
          width: ancho,
          child: Column(
            children: [
              Container(
                height: alto * 0.25,
                padding: EdgeInsets.all(5),
                child: Image.asset('assets/sentado_vector.png'),
              ),
              SizedBox(height: alto * 0.01),
              Container(
                height: alto * 0.74,
                padding: EdgeInsets.all(20),
                width: ancho,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleController,
                      cursorColor: Theme.of(context).primaryColor,
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
                          hintText: 'Nuevo Titulo'),
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: alto * 0.025,
                    ),
                    Container(
                      height: alto * 0.35,
                      child: TextField(
                        controller: descripcionController,
                        maxLines: (alto * 0.35).toInt(),
                        cursorColor: Theme.of(context).primaryColor,
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
                            hintText: 'Nueva Descripción'),
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: alto * 0.025,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
