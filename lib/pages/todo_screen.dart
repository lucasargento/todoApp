import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TodoScreen extends StatefulWidget {
  TodoScreen({@required this.todo});
  final dynamic todo;
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  double alto;
  double ancho;
  ScrollController imageListController = ScrollController();
  List listaDeFotos = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (imageListController.hasClients) {
          imageListController
              .animateTo(100,
                  duration: Duration(milliseconds: 300), curve: Curves.linear)
              .then(
                (value) => imageListController.animateTo(0,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.fastOutSlowIn),
              );
        }
      },
    );
    convertirStringDeFotosAList();
    super.initState();
  }

  void convertirStringDeFotosAList() {
    listaDeFotos = widget.todo['photo'].split(',');
  }

  String capitalize(String string) {
    if (string.isEmpty) {
      return string;
    }
    return string[0].toUpperCase() + string.substring(1);
  }

  @override
  void dispose() {
    imageListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    alto = MediaQuery.of(context).size.height;
    ancho = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          capitalize(widget.todo['titulo']),
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
      body: SingleChildScrollView(
        child: Container(
          height: alto,
          width: ancho,
          child: Column(
            children: [
              Container(
                height: alto * 0.25,
                padding: EdgeInsets.all(5),
                child: ListView.builder(
                  controller: imageListController,
                  scrollDirection: Axis.horizontal,
                  itemCount: 1,
                  itemBuilder: (context, i) {
                    return Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            //color: Colors.blue,
                          ),
                          height: alto * 0.2,
                          width: ancho * 0.9,
                          child: ListView.builder(
                            itemCount: listaDeFotos.length != 0
                                ? listaDeFotos.length
                                : 1,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, i) {
                              if (listaDeFotos[0] == '') {
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
                                  child: CachedNetworkImage(
                                    imageUrl: listaDeFotos[i],
                                    placeholder: (context, stringo) =>
                                        Container(
                                      width: ancho * 0.2,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                    fit: BoxFit.fitHeight,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: ancho * 0.05,
                        )
                      ],
                    );
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
                    Text(
                      capitalize(widget.todo['descripcion']),
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
