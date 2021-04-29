import 'package:flutter/material.dart';

class BarraDeBusqueda extends StatefulWidget {
  BarraDeBusqueda({
    Key key,
    @required this.anchoBusqueda,
    @required this.ancho,
    @required this.alto,
    @required this.busquedaController,
    @required this.todoBuscado,
  }) : super(key: key);

  double anchoBusqueda;
  final double ancho;
  final double alto;
  final TextEditingController busquedaController;
  String todoBuscado;

  @override
  _BarraDeBusquedaState createState() => _BarraDeBusquedaState();
}

class _BarraDeBusquedaState extends State<BarraDeBusqueda> {
  FocusNode busquedaFocusNode;
  bool keyboardIsOpened = false;
  @override
  void initState() {
    super.initState();
    busquedaFocusNode = FocusNode();
  }

  @override
  void dispose() {
    widget.busquedaController.dispose();
    busquedaFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    if (keyboardIsOpened && busquedaFocusNode.hasFocus) {
      widget.anchoBusqueda = widget.ancho * 0.8;
    }
    return AnimatedContainer(
      // container de la busqueda
      duration: Duration(milliseconds: 250),
      curve: Curves.fastOutSlowIn,
      width: widget.anchoBusqueda != null
          ? widget.anchoBusqueda
          : widget.ancho * 0.1,
      height: widget.alto * 0.1,
      child: TextField(
        focusNode: busquedaFocusNode,
        cursorColor: Theme.of(context).primaryColor,
        controller: widget.busquedaController,
        onChanged: (busqueda) {
          setState(() {
            widget.todoBuscado = busqueda;
            print(widget.todoBuscado);
          });
        },
        onSubmitted: (value) {
          setState(
            () {
              widget.anchoBusqueda = widget.ancho * 0.1;
            },
          );
        },
        style: TextStyle(color: Theme.of(context).primaryColor),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              setState(() {
                widget.anchoBusqueda = widget.ancho * 0.8;
              });
            },
            icon: Icon(
              Icons.search,
              color: Theme.of(context).primaryColor,
            ),
          ),
          hintText: 'Buscar por título',
          hintStyle: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
