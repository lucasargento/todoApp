import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<void> agregarUsuarioRegistrado(
      {@required String userID, String userName}) async {
    /*
    Agregar un nuevo ID de usuario a la base de datos y dar forma a sus carpetas de ToDos
    userId: codigo unico generado por Firebase Auth
    userName: nombre de usuario elegido. Ademas fue guardado como displayName en Auth
    */

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    // creo entrada de usuario y su nombre
    await users
        .doc(userID)
        .set({'userName': userName})
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
    // creo para dicho usuario la collection de todos
    FieldValue timestamp = FieldValue.serverTimestamp();
    users.doc(userID).collection('ToDos').doc('initialNullTodo').set({
      'titulo': 'null initial todo',
      'descripcion': 'descripcion del todo',
      'photo': 'link a la foto',
      'timestamp': timestamp,
      'estado': 'pendientes',
      'tituloOriginal':
          'null initial todo', //inmutable, para poder tener un trackin de los documentos.
    });
  }

  static Stream<List> getStreamTodosDelUsuario({@required String userID}) {
    /*
    Buscar todos del usuario en cuestion de la base de datos y devolverlos en forma de Stream
    */

    Stream<QuerySnapshot> users = FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('ToDos')
        .orderBy('timestamp', descending: true)
        .snapshots();
    return users.map((qShot) => qShot.docs.toList());
  }

  static Future<void> agregarTodo({
    @required String userID,
    @required String titulo,
    @required String descripcion,
    @required String photo,
  }) async {
    /*
    agregar todo a la base de datos
    */

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    FieldValue timestamp = FieldValue.serverTimestamp();
    await users.doc(userID).collection('ToDos').doc(titulo).set({
      'titulo': titulo,
      'descripcion': descripcion,
      'photo': photo,
      'timestamp': timestamp,
      'estado': 'pendientes',
      'tituloOriginal':
          titulo, //inmutable, para poder tener un trackin de los documentos.
    });
  }

  static Future<void> eliminarTodo(
      {@required String userID, @required String titulo}) async {
    /*
   eliminar el todo en cuestion de la base de datos
    */
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    users
        .doc(userID)
        .collection('ToDos')
        .doc(titulo)
        .delete()
        .then((value) => print("Documento Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  static Future<bool> puedeUsarseElTitulo(
      {@required String userID, @required String titulo}) async {
    /*
    Buscar todos del usuario en cuestion de la base de datos y chequear que el titulo que se esta queriendo agregar no exista. Devolver false en caso de que este repetido
    */
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    QuerySnapshot snapshot = await users.doc(userID).collection('ToDos').get();
    List listaDeDocs = snapshot.docs.toList();
    List listaDeTitulos = [];
    listaDeDocs.forEach((documento) {
      listaDeTitulos.add(documento['titulo']);
    });
    if (listaDeTitulos.contains(titulo)) {
      return false;
    } else {
      return true;
    }
  }

  static Future<void> cambiarStatusTodo(
      {@required String userID, @required String titulo}) async {
    /*
        Cambiar el status del Todo en cuestion de pendiente a terminado y viceversa
        */
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    dynamic doc = await users.doc(userID).collection('ToDos').doc(titulo).get();
    String estadoActual = doc['estado'];
    print('estado actual $estadoActual');
    if (estadoActual == 'terminados') {
      users
          .doc(userID)
          .collection('ToDos')
          .doc(titulo)
          .update({'estado': 'pendientes'});
    } else {
      users
          .doc(userID)
          .collection('ToDos')
          .doc(titulo)
          .update({'estado': 'terminados'});
    }
  }

  static Future<void> editarTodo(
      {@required String userID,
      @required String titulo,
      @required String nuevoTitulo,
      @required String descripcion}) async {
    /*
        editar el status del Todo en cuestion 
    */
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    FieldValue timestamp = FieldValue.serverTimestamp();

    if (nuevoTitulo != null && nuevoTitulo != '') {
      users.doc(userID).collection('ToDos').doc(titulo).update({
        'titulo': nuevoTitulo,
        'timestamp': timestamp,
      });
    }
    if (descripcion != null && descripcion != '') {
      users.doc(userID).collection('ToDos').doc(titulo).update({
        'descripcion': descripcion,
        'timestamp': timestamp,
      });
    }
  }
}
