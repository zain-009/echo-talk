import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../snackBarController/snackBar_controller.dart';

class StorageController{
  //--------------pick-file------------------------------------------
  static Future <void> pickImage(BuildContext context)async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['png','jpg']
    );
    if (result == null) {
      SnackBarController.showSnackBar(context, "No image picked!");
    }
    final path = result!.files.single.path!;
    final fileName = result.files.single.name;
    await uploadProfileImage(path,fileName,context).then((value) => SnackBarController.showSnackBar(context, "Profile picture updated!"));
  }
  //------------upload-profile-image---------------------------------
  static Future <void> uploadProfileImage(String filePath, String fileName,BuildContext context) async{
    File file = File(filePath);
    try{
      await FirebaseStorage.instance.ref('profilePics/$fileName').putFile(file);
    } catch (e) {
      SnackBarController.showSnackBar(context, e.toString());
    }
  }
}