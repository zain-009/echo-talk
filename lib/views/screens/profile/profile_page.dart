import 'package:echotalk/views/screens/profile/edit_email_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/authController/auth_controller.dart';
import '../../../controllers/dataController/data_controller.dart';
import '../../../controllers/storageController/storage_controller.dart';
import '../../../models/userModel/user_model.dart';
import '../../../widgets/tile/tile.dart';
import 'edit_info_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? uid;
  UserModel? userModel;
  bool load = true;
  User? user = FirebaseAuth.instance.currentUser;

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
        title: Text(
          "Settings",
          style: GoogleFonts.quicksand(
              fontSize: 28,
              color: Colors.deepPurple[400],
              fontWeight: FontWeight.bold),
        ),
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
                  : Column(
                      children: [
                        Row(
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
                                  child: Icon(
                                    Icons.person,
                                    size: 65,
                                    color: Colors.deepPurple,
                                  ),
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  user!.email.toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.person),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Account",
                              style: GoogleFonts.quicksand(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        const Divider(
                          height: 1,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Tile(
                            onPress: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditInfoScreen(
                                          firstname: userModel!.firstName,
                                          lastName: userModel!.lastName,
                                          age: userModel!.age,
                                          email: userModel!.email)));
                            },
                            leading: "Personal Information"),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.lock_outline),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Security",
                              style: GoogleFonts.quicksand(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        const Divider(
                          height: 1,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Tile(
                            onPress: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditEmailPage(email: userModel!.email)));
                            },
                            leading: "Change Email"),
                        const SizedBox(
                          height: 10,
                        ),
                        Tile(onPress: () {}, leading: "Change Password"),
                      ],
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                    content: const Text("Are you sure you want to Logout?"),
                    contentPadding: const EdgeInsets.all(20),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "No",
                            style: TextStyle(color: Colors.black54),
                          )),
                      TextButton(
                          onPressed: () {
                            AuthController.logout(context);
                          },
                          child: const Text(
                            "Yes",
                            style: TextStyle(color: Colors.deepPurple),
                          )),
                    ],
                  ));
        },
        label: Text(
          "Log out",
          style:
              GoogleFonts.quicksand(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
