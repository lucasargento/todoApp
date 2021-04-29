import 'package:flutter/material.dart';

class BotonesDeEstado extends StatefulWidget {
  BotonesDeEstado({
    Key key,
    @required this.ancho,
    @required this.alto,
    @required this.pressedPendientes,
    @required this.pressedTerminados,
    @required this.pendientesCallback,
    @required this.terminadosCallback,
  }) : super(key: key);

  final double ancho;
  final double alto;
  final bool pressedPendientes;
  final bool pressedTerminados;
  Function pendientesCallback;
  Function terminadosCallback;

  @override
  _BotonesDeEstadoState createState() => _BotonesDeEstadoState();
}

class _BotonesDeEstadoState extends State<BotonesDeEstado> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // row de botones
      width: widget.ancho * 0.7,
      height: widget.alto * 0.04,
      constraints: BoxConstraints(minHeight: 40, minWidth: 240),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Material(
            color: widget.pressedPendientes
                ? Theme.of(context).cardColor
                : Theme.of(context).accentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              side: BorderSide(color: Colors.transparent),
            ),
            child: Container(
              child: InkWell(
                onTap: widget.pendientesCallback,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: widget.alto * 0.01,
                      horizontal: widget.ancho * 0.04),
                  child: Text(
                    'Pendientes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Material(
            color: widget.pressedTerminados
                ? Theme.of(context).cardColor
                : Theme.of(context).accentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              side: BorderSide(color: Colors.transparent),
            ),
            child: InkWell(
              onTap: widget.terminadosCallback,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: widget.alto * 0.01,
                    horizontal: widget.ancho * 0.04),
                child: Text(
                  'Terminados',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
