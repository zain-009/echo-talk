import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echotalk/controllers/authController/auth_controller.dart';
import 'package:echotalk/controllers/snackBarController/snackBar_controller.dart';
import 'package:echotalk/controllers/storageController/storage_controller.dart';
import 'package:echotalk/models/postModel/post_model.dart';
import 'package:echotalk/views/screens/profile/profile_page.dart';
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
  void dispose() {
    super.dispose();
    _postController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              "Feed",
              style: GoogleFonts.quicksand(
                  fontSize: 36,
                  color: Colors.deepPurple[400],
                  fontWeight: FontWeight.bold),
            ),
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
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                load ? const CircularProgressIndicator(color: Colors.deepPurple,) : Container(
                  height: size.height * 0.65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.deepPurple[100],
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('posts').snapshots(),
                    builder: (context,snapshot){
                      if(!snapshot.hasData){
                        return const CircularProgressIndicator(color: Colors.white,);
                      }
                      if(userModel == null){
                        return const CircularProgressIndicator(color: Colors.deepPurple,);
                      }
                      final posts = snapshot.data?.docs;
                      return ListView.builder(
                          itemCount: posts?.length,
                          itemBuilder: (context,index){
                            final post = PostModel.fromSnap(posts![index]);
                            return ListTile(
                              title: Text('post'),
                              subtitle: Text('username'),
                              trailing: Text('time'),
                            );
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                    border: Border.all(width: 1, color: Colors.grey),
                  ),
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
                        onPressed: () async {
                          await StorageController.createPost(_postController.text.trim(), context);
                          _postController.clear();
                          SnackBarController.showSnackBar(context, "Post Successful");
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ))),
              ],
            ),
          ),
        ));
  }
}
