import 'package:flutter/material.dart';
import 'package:todo_app/pages/todo_screen.dart';
import 'package:todo_app/Tools/firestore_helper.dart';
import 'package:todo_app/pages/edit_todo_screen.dart';

class ToDoWidget extends StatefulWidget {
  ToDoWidget({
    Key key,
    @required this.alto,
    @required this.deltaSize,
    @required this.ancho,
    @required this.futureList,
    @required this.i,
    @required this.userID,
  }) : super(key: key);

  final double alto;
  double deltaSize;
  final double ancho;
  AsyncSnapshot futureList;
  int i;
  String userID;

  @override
  _ToDoWidgetState createState() => _ToDoWidgetState();
}

class _ToDoWidgetState extends State<ToDoWidget> {
  String capitalize(String string) {
    if (string.isEmpty) {
      return string;
    }
    return string[0].toUpperCase() + string.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: UniqueKey(),
      children: [
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TodoScreen(
                    todo: widget.futureList.data[widget.i],
                  ),
                ),
              );
            },
            highlightColor: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            child: Dismissible(
              key: Key('item'),
              background: Container(
                color: Theme.of(context).backgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.delete,
                          color: Theme.of(context).accentColor),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.delete,
                        color: Theme.of(context).accentColor,
                      ),
                    )
                  ],
                ),
              ),
              onDismissed: (direction) async {
                await FirestoreHelper.eliminarTodo(
                    userID: widget.userID,
                    titulo: widget.futureList.data[widget.i]['tituloOriginal']);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    content: Text(
                      "ToDo eliminado",
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
                height: widget.alto * 0.2 + widget.deltaSize,
                width: widget.ancho + widget.deltaSize * 0.5,
                padding: EdgeInsets.symmetric(
                    vertical: 2, horizontal: widget.ancho * 0.05),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  color: Theme.of(context).cardColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.futureList.data[widget.i]['titulo'].length < 10
                              ? capitalize(
                                  widget.futureList.data[widget.i]['titulo'])
                              : capitalize(widget.futureList.data[widget.i]
                                          ['titulo'])
                                      .substring(0, 10) +
                                  '...',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Theme.of(context).primaryColor,
                                ),
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditTodoScreen(
                                        userID: widget.userID,
                                        todo: widget.futureList.data[widget.i],
                                      ),
                                    ),
                                  );
                                }),
                            IconButton(
                              icon: Icon(Icons.delete),
                              padding: EdgeInsets.zero,
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(seconds: 2),
                                    content: Container(
                                      height: widget.alto * 0.15,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Esta seguro que quiere eliminar el ToDo?',
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await FirestoreHelper
                                                  .eliminarTodo(
                                                userID: widget.userID,
                                                titulo: widget.futureList
                                                        .data[widget.i]
                                                    ['tituloOriginal'],
                                              );
                                            },
                                            child: Text('Si'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              ScaffoldMessenger.of(context)
                                                  .hideCurrentSnackBar();
                                            },
                                            child: Text('No'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            Checkbox(
                              value: widget.futureList.data[widget.i]
                                          ['estado'] ==
                                      'pendientes'
                                  ? false
                                  : true,
                              activeColor: Theme.of(context).primaryColor,
                              checkColor: Theme.of(context).accentColor,
                              onChanged: (value) async {
                                await FirestoreHelper.cambiarStatusTodo(
                                  userID: widget.userID,
                                  titulo: widget.futureList.data[widget.i]
                                      ['tituloOriginal'],
                                ).then(
                                  (value) => ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(widget.futureList
                                                  .data[widget.i]['estado'] ==
                                              'pendientes'
                                          ? 'ToDo marcado como terminado. Felicitaciones!'
                                          : 'ToDo marcado como incompleto. A trabajar!'),
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: widget.alto * 0.005,
                    ),
                    Container(
                      height: widget.alto * 0.1 + widget.deltaSize,
                      child: Text(
                        widget.futureList.data[widget.i]['descripcion'],
                        softWrap: true,
                        textScaleFactor: MediaQuery.of(context).textScaleFactor,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: widget.alto * 0.02,
        ),
      ],
    );
  }
}
