import 'package:cabzing/app_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/service_page.dart';
import 'dashboard_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final data = {
      "username": _usernameController.text.trim(),
      "password": _passwordController.text.trim(),
      "is_mobile": true
    };

    try {
      final response = await ServicePage.login(data);
      debugPrint('...........$response');
      if (response["success"] == 6000) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', response["data"]["access"]);
        await prefs.setInt('user_id', response["data"]["user_id"]);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const DashboardScreen(),
            ),
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: response["error"] ?? "An unexpected error occurred",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (error) {
      debugPrint('error........${error.toString()}');
      Fluttertoast.showToast(
        msg:  "An unexpected error occurred",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/loggingBg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          'assets/images/language-hiragana.png',
                          height: 24,
                          width: 24,
                        ),
                        const AppText(
                            text: '  English',
                            size: 14,
                            weight: FontWeight.w400,
                            textColor: Colors.white),
                      ],
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    const Center(
                      child: AppText(
                          text: 'Login',
                          size: 21,
                          weight: FontWeight.w500,
                          textColor: Colors.white),
                    ),
                    const Center(
                      child: AppText(
                          text: 'Login to your vikn account',
                          size: 15,
                          weight: FontWeight.w400,
                          textColor: Color(0xff838383)),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(color: const Color(0xff1C3347)),
                          color: const Color(0xff08131E),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextFormField(
                                controller: _usernameController,
                                decoration: const InputDecoration(
                                  prefixIcon: Padding(
                                    padding:
                                        EdgeInsets.only(left: 13, right: 13),
                                    child: ImageIcon(
                                      AssetImage('assets/images/Vector.png'),
                                      color: Color(0xff0A9EF3),
                                    ),
                                  ),
                                  labelText: 'Username',
                                  labelStyle: TextStyle(color: Colors.white),
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(color: Colors.white),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your username';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const Divider(
                              color: Color(0xff1C3347),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  prefixIcon: const Padding(
                                    padding:
                                        EdgeInsets.only(left: 12, right: 12),
                                    child: ImageIcon(
                                      AssetImage('assets/images/key-round.png'),
                                      color: Color(0xff0A9EF3),
                                    ),
                                  ),
                                  labelText: 'Password',
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  border: InputBorder.none,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: const Color(0xff0A9EF3),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                                style: const TextStyle(color: Colors.white),
                                obscureText: !_isPasswordVisible,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(height: 30),
                    const Center(
                      child: AppText(
                          text: 'Forgotten Password?',
                          size: 16,
                          weight: FontWeight.w400,
                          textColor: Color(0xff0A9EF3)),
                    ),
                    const SizedBox(height: 20),
                    _isLoading
                        ?  Center(
                      child: LoadingAnimationWidget.hexagonDots(
                        color: Colors.white,
                        size: 35,
                      ),
                    )
                        : Center(
                            child: GestureDetector(
                              onTap: _login,
                              child: Container(
                                width: 125,
                                height: 48,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(90),
                                    color: const Color(0xff0E75F4)),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AppText(
                                        text: 'Sign in  ',
                                        size: 16,
                                        weight: FontWeight.w400,
                                        textColor: Colors.white),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 100),
                    const Center(
                      child: AppText(
                          text: 'Don’t have an Account?',
                          size: 15,
                          weight: FontWeight.w400,
                          textColor: Colors.white),
                    ),
                    const Center(
                      child: AppText(
                          text: 'Sign up now!',
                          size: 16,
                          weight: FontWeight.w500,
                          textColor: Color(0xff0A9EF3)),
                    ),
                    const SizedBox(height: 30)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
