import 'package:echotalk/controllers/authController/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CloseAccountPage extends StatefulWidget {
  final String email;
  const CloseAccountPage({super.key, required this.email});

  @override
  State<CloseAccountPage> createState() => _CloseAccountPageState();
}

class _CloseAccountPageState extends State<CloseAccountPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;
  bool isObscure = true;

  @override
  void initState() {
    _emailController.text = widget.email;
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white12,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              Text(
                "Close Account",
                style: GoogleFonts.quicksand(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "We are sorry to see you go!",
                style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black45),
              ),
              const SizedBox(
                height: 40,
              ),
              TextFormField(
                controller: _emailController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: "Current Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                obscureText: isObscure,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                      icon: isObscure
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility)),
                  prefixIcon: const Icon(Icons.lock_outline),
                  hintText: "Password",
                ),
                controller: _passwordController,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "By clicking on close, your account and all information will be deleted permanently!",
                style: GoogleFonts.quicksand(
                    fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: size.height * 0.33,
              ),
              Center(
                  child: SizedBox(
                      height: 40,
                      width: 100,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text(
                                    "Logout",
                                    style: TextStyle(color: Colors.deepPurple),
                                  ),
                                  content: const Text("Are you sure you want to close this account?"),
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
                                        onPressed: () async {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          await AuthController.closeAccount(context, _emailController.text.trim(), _passwordController.text.trim());
                                          setState(() {
                                            isLoading = false;
                                          });
                                          },
                                        child: const Text(
                                          "Yes",
                                          style: TextStyle(color: Colors.deepPurple),
                                        )),
                                  ],
                                ));
                          },
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "Close",
                                  style: GoogleFonts.quicksand(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ))))
            ],
          ),
        ),
      ),
    );
  }
}
