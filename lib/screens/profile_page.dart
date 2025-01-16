import 'dart:developer';
import 'package:cabzing/app_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/service_page.dart';
import 'loggin_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userProfile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getProfileDetails();
  }

  Future<void> getProfileDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');
      if (userId == null) {
        throw Exception('User ID not found');
      }

      var response = await ServicePage.getProfileDetails(userId);
      print('profile........$response');

      setState(() {
        userProfile = {
          "first_name": response['data']['first_name'] ?? '',
          "last_name": response['data']['last_name'] ?? '',
          "email": response['data']['email'] ?? '',
          "photo": response['customer_data']['photo'] ?? '',
          "phone": response['customer_data']['Phone']?.toString() ?? '',
          "address": response['customer_data']['Address'] ?? '',
        };
        isLoading = false;
      });
    } catch (e) {
      log('Error fetching profile details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoading
          ? Center(
              child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Center(
                    child: LoadingAnimationWidget.hexagonDots(
                      color: Colors.white,
                      size: 35,
                    ),
                  )),
            )
          : userProfile == null
              ? const Center(
                  child: AppText(
                      text: 'Error loading profile details',
                      size: 18,
                      weight: FontWeight.w600,
                      textColor: Colors.white))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      const SizedBox(height: 70),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(44),
                          color: const Color(0xff0F0F0F),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(33),
                                      image: DecorationImage(
                                        image:
                                            NetworkImage(userProfile!['photo']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ListTile(
                                      title: Text(
                                        '${userProfile!['first_name']} ${userProfile!['last_name']}',
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text(
                                        '${userProfile!['email']}',
                                        style: GoogleFonts.poppins(
                                            color: const Color(0xffB5CDFE),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14),
                                      ),
                                      trailing: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 107,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(33),
                                          color: Colors.black),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 38,
                                              height: double.infinity,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(90),
                                                  color:
                                                      const Color(0xffB5CDFE)),
                                              child: Center(
                                                child: SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child: Image.asset(
                                                        'assets/images/Vector (1).png')),
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            const Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    AppText(
                                                        text: '4.3 ',
                                                        size: 18,
                                                        weight: FontWeight.w400,
                                                        textColor:
                                                            Colors.white),
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.white,
                                                      size: 15,
                                                    ),
                                                  ],
                                                ),
                                                AppText(
                                                    text: '2,211',
                                                    size: 14,
                                                    weight: FontWeight.w400,
                                                    textColor:
                                                        Color(0xff565656)),
                                                AppText(
                                                    text: 'rides',
                                                    size: 14,
                                                    weight: FontWeight.w400,
                                                    textColor: Colors.white),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Container(
                                      height: 107,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(33),
                                          color: Colors.black),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 38,
                                              height: double.infinity,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(90),
                                                  color:
                                                      const Color(0xffB5CDFE)),
                                              child: Center(
                                                child: SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child: Image.asset(
                                                        'assets/images/shield-tick.png')),
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            const Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    AppText(
                                                        text: 'KYC ',
                                                        size: 18,
                                                        weight: FontWeight.w400,
                                                        textColor:
                                                            Colors.white),
                                                    Icon(
                                                      Icons.done,
                                                      color: Colors.white,
                                                      size: 15,
                                                    ),
                                                  ],
                                                ),
                                                AppText(
                                                    text: 'Verified',
                                                    size: 14,
                                                    weight: FontWeight.w400,
                                                    textColor: Colors.white),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              GestureDetector(
                                onTap: _logout,
                                child: Container(
                                  height: 67,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(90),
                                      color: Colors.black),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.logout,
                                        color: Color(0xffEA6262),
                                      ),
                                      AppText(
                                          text: '  Logout',
                                          size: 15,
                                          weight: FontWeight.w400,
                                          textColor: Color(0xffEA6262))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            final icons = [
                              Icons.help_outline,
                              Icons.search,
                              Icons.person_add_alt,
                              Icons.search_off,
                              Icons.privacy_tip_outlined,
                            ];
                            final texts = [
                              'Help',
                              'FAQ',
                              'Invite Friends',
                              'Terms of service',
                              'Privacy Policy',
                            ];
                            return ListTile(
                              leading: Icon(icons[index], color: Colors.white),
                              title: AppText(
                                  text: texts[index],
                                  size: 15,
                                  weight: FontWeight.w400,
                                  textColor: Colors.white),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
