import 'package:echotalk/controllers/authController/auth_controller.dart';
import 'package:echotalk/views/screens/profile_page.dart';
import 'package:echotalk/views/screens/search_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/dataController/data_controller.dart';
import '../../models/userModel/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? uid;
  UserModel? userModel;
  bool load = true;
  final _postController = TextEditingController();

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
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text("Feed",style: GoogleFonts.quicksand(fontSize: 36,color: Colors.deepPurple[400],fontWeight: FontWeight.bold),),
          ),
          backgroundColor: Colors.white12,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchPage()));
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 25,
                )),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilePage()));
                },
                icon: const Icon(
                  Icons.settings,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title: const Text(
                              "Logout",
                              style: TextStyle(color: Colors.deepPurple),
                            ),
                            content:
                                const Text("Are you sure you want to Logout?"),
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
                icon: const Icon(
                  Icons.logout,
                  color: Colors.black,
                )),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: size.height * 0.70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[200],
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      height: size.height * 0.08,
                      width: size.width * 0.92,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextField(
                          textInputAction: TextInputAction.next,
                          controller: _postController,
                          decoration: const InputDecoration(
                            hintText: 'what are you thinking about?',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: size.height * 0.065,
                  width: size.height * 0.065,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[400],
                    borderRadius: BorderRadius.circular(15),
                  ),
                    child: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.add,color: Colors.white,))),
              ],
            ),
          ),
        ));
  }
}
