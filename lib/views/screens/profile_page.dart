import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/dataController/data_controller.dart';
import '../../controllers/storageController/storage_controller.dart';
import '../../models/userModel/user_model.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? uid;
  UserModel? userModel;
  bool load = true;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        load = false;
      });
    });
    getData();
    super.initState();
  }

  Future<UserModel> getData() async {
    userModel = await DataController.getUserModelById(
        FirebaseAuth.instance.currentUser!.uid);
    return userModel!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white12,
        elevation: 0,
        title: Text("My Profile",style: GoogleFonts.quicksand(fontSize: 28,color: Colors.deepPurple[400],fontWeight: FontWeight.bold),),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              load
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              StorageController.pickImage(context);
                            },
                            child: const CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 45,
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.white,
                              ),
                            ),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${userModel!.firstName} ${userModel!.lastName}",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              userModel!.email,
                              style: const TextStyle(fontSize: 16),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditProfilePage(
                                              firstname: userModel!.firstName,
                                              lastName: userModel!.lastName,
                                              age: userModel!.age,
                                              email: userModel!.email,
                                            )));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.deepPurple, // Background color
                              ),
                              child: const Text("Edit Profile"),
                            ),
                          ],
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
