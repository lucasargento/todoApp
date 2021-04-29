import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:typed_data' show Uint8List;

class StorageHelper {
  // Clase encargada de manejar todo lo relacionado a Firebase Storage.

  static Future<String> cargarFotosAStorage({
    @required List listaDeFotos,
    @required String userID,
    @required var time,
  }) async {
    /*
    subir cada una de las fotos de la lista a storage. devolver una lista (un string con los links separados por comas para guardarlo en un unico
    campo en firestore) con los links de cada una de estas en el bucket
    */

    List listaDeLinksBucket = [];
    int counter = 0;
    String linksAsStrings = '';
    // subir las imagenes como data
    for (int x = 0; x < listaDeFotos.length; x++) {
      Uint8List data = Uint8List.fromList(listaDeFotos[x]);
      // creo reference. si no existe carpeta del user la crea
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref('$userID/$userID at $time numero $counter.png');
      // aumento el counter para no repetir nombres y sobreescribir en caso de estar subiendo mas de una foto
      counter = counter + 1;
      try {
        // guardo data
        await ref.putData(data);
        // busco su link
        String downloadedData = await ref.getDownloadURL();
        // lo agrego a la lista
        listaDeLinksBucket.add(downloadedData);
      } catch (e) {
        print('algo salio mal ==> $e');
      }
    }
    // para cada uno de los links en listaDeLinks, lo convierto a strings para guardarlo compacto en firestore. devuelvo esa variable string
    for (int y = 0; y < listaDeLinksBucket.length; y++) {
      if (listaDeLinksBucket.indexOf(listaDeLinksBucket[y]) ==
          listaDeLinksBucket.length - 1) {
        linksAsStrings = linksAsStrings + listaDeLinksBucket[y];
      } else {
        linksAsStrings = linksAsStrings + listaDeLinksBucket[y] + ',';
      }
    }

    return linksAsStrings;
  }
}
