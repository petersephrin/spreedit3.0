import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:flutter/material.dart';

class Storage {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadFile(String filePath, String fileName) async {
    Reference ref = _storage.ref().child(fileName);
    try {
      await ref.putFile(File(filePath));
      debugPrint('File Uploaded');

      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
    }
    return "";
  }
}
