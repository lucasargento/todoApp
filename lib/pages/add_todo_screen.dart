import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:image_picker/image_picker.dart';

import 'package:todo_app/Tools/firestore_helper.dart';
import 'package:todo_app/Tools/storage_helper.dart';

class AddTodoScreen extends StatefulWidget {
  AddTodoScreen({@required this.userID});
  String userID;
  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  double alto;
  double ancho;
  TextEditingController titleController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  List listaDeFotos = [];
  dynamic _image;
  final picker = ImagePicker();

  Future getImage({@required String type}) async {
    var pickedFile;
    if (type == 'gallery') {
      pickedFile = await picker.getImage(source: ImageSource.gallery);
    } else {
      pickedFile = await picker.getImage(source: ImageSource.camera);
    }

    if (pickedFile != null) {
      _image = await pickedFile.readAsBytes();
      listaDeFotos.add(_image);
      // _image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    setState(() {});
  }

  void cargarTodoAFirestore() async {
    bool tituloValido = await FirestoreHelper.puedeUsarseElTitulo(
        userID: widget.userID, titulo: titleController.text);
    if (tituloValido) {
      var now = DateTime.now();
      // agregar fotos a storage
      String listaDeFotosString = await StorageHelper.cargarFotosAStorage(
          listaDeFotos: listaDeFotos, userID: widget.userID, time: now);
      // cargar toda la data a firestore
      await FirestoreHelper.agregarTodo(
        userID: widget.userID,
        titulo: titleController.text,
        descripcion: descripcionController.text,
        photo: listaDeFotosString,
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
          'Agregar un nuevo ToDo',
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
                  cargarTodoAFirestore();
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
                child: ListView.builder(
                  itemCount: listaDeFotos.length != 0 ? listaDeFotos.length : 1,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {
                    if (listaDeFotos.length < 1) {
                      return Container(
                        width: ancho,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: alto * 0.25,
                              padding: EdgeInsets.all(5),
                              child: Image.asset(
                                'assets/escritorio_vector.png',
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container(
                        height: alto * 0.25,
                        padding: EdgeInsets.all(5),
                        child: Stack(
                          children: [
                            Image.memory(
                              listaDeFotos[i],
                              fit: BoxFit.fitHeight,
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      listaDeFotos.removeAt(i);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete_rounded,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: alto * 0.01),
              Container(
                height: alto * 0.74,
                padding: EdgeInsets.all(20),
                width: ancho,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: kIsWeb
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Theme.of(context).accentColor;
                                return Theme.of(context).cardColor;
                              },
                            ),
                          ),
                          onPressed: () async {
                            await getImage(type: 'gallery');
                          },
                          child: Text('Imágen de Galería'),
                        ),
                        kIsWeb
                            ? Container(
                                width: 0,
                              )
                            : ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.pressed))
                                        return Theme.of(context).accentColor;
                                      return Theme.of(context).accentColor;
                                    },
                                  ),
                                ),
                                onPressed: () async {
                                  await getImage(type: 'camera');
                                },
                                child: Text('Hacer una Foto'),
                              ),
                      ],
                    ),
                    SizedBox(
                      height: alto * 0.025,
                    ),
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
                          hintText: 'Titulo'),
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
                            hintText: 'Descripción'),
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
