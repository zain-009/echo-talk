import 'dart:async';
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
import 'package:intl/intl.dart';
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
  PostModel? postModel;
  bool load = true;
  final _postController = TextEditingController();
  final _postFocusNode = FocusNode();

  final StreamController<List<PostModel>> _postStreamController =
  StreamController<List<PostModel>>.broadcast();

  @override
  void initState() {
    getData();
    super.initState();
    _startListeningToPosts();
  }

  Future<UserModel> getData() async {
    setState(() {
      load = true;
    });
    userModel = await DataController.getUserModelById(
        FirebaseAuth.instance.currentUser!.uid);

    setState(() {
      load = false;
    });
    return userModel!;
  }

  void _startListeningToPosts() {
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('timestamp',descending: true)
        .snapshots()
        .listen((snapshot) {
      final posts = snapshot.docs.map((postDoc) => PostModel.fromSnapshot(postDoc)).toList();
      _postStreamController.add(posts);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _postStreamController.close();
    _postController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    User? user = FirebaseAuth.instance.currentUser;
    bool isPhoneNumberUser = user?.providerData.any((info) => info.providerId == 'phone') ?? false;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Feed",
          style: GoogleFonts.quicksand(
            fontSize: 36,
            color: Colors.deepPurple[400],
            fontWeight: FontWeight.bold,
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
                  builder: (context) => const SearchPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.search,
              color: Colors.black,
              size: 25,
            ),
          ),
          isPhoneNumberUser ? IconButton(onPressed: (){AuthController.logout(context);}, icon: const Icon(Icons.logout,color: Colors.black,)) :
          IconButton(
            onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              },
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (load) ...[
                Container(
                  alignment: Alignment.center,
                  height: 100,
                  width: 100,
                  child: const CircularProgressIndicator(
                    color: Colors.deepPurple,
                  ),
                ),
              ],
              StreamBuilder<List<PostModel>>(
                stream: _postStreamController.stream,
                builder: (context, snapshot) {
                  if (load) {
                    return const SizedBox.shrink();
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(
                      color: Colors.deepPurple,
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final allPosts = snapshot.data ?? [];
                    return Container(
                      height: size.height * 0.78,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.deepPurple[100],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          reverse: true,
                          itemCount: allPosts.length,
                          itemBuilder: (context, index) {
                            final post = allPosts[index];
                            return Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          post.name,
                                          style: const TextStyle(
                                            color: Colors.black45,
                                          ),
                                        ),
                                        Text(
                                          post.content,
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      DateFormat('hh:mm a').format(post.timestamp),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                },
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
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          enabled: isPhoneNumberUser ? false : true,
                          focusNode: _postFocusNode,
                          textInputAction: TextInputAction.next,
                          controller: _postController,
                          decoration: const InputDecoration(
                            hintText: 'what are you thinking about?',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          if (!isPhoneNumberUser) {
                            await StorageController.tryAddPost(
                              _postController.text,
                              userModel!.firstName,
                              context,
                            );
                            _postController.clear();
                          } else {
                            SnackBarController.showSnackBar(context, "Guests cannot post, Please make an account with email!");
                          }
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.deepPurple,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
