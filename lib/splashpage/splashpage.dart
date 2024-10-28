import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zalal/firstpage/girdtilepage.dart';
import 'package:zalal/loginpages/views/loginpage.dart';

class splash_page extends StatefulWidget {
  const splash_page({super.key});
  @override
  State<splash_page> createState() => _splash_pageState();
}

class _splash_pageState extends State<splash_page> {
  @override
  void initState() {
    super.initState();
    startSplashScreen();
  }

  void startSplashScreen() async {
    // مدت زمان تأخیر ۳ ثانیه
    await Future.delayed(Duration(seconds: 3));
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // اگر کاربر قبلاً وارد شده بود، به صفحه اصلی بروید، در غیر این صورت به صفحه لاگین
    if (isLoggedIn) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const gridepage()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const loginscresn()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: CircleAvatar(
                backgroundImage: AssetImage("image/factor.jpg"),
                radius: 150,
              ),
            ),
            Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Center(child: Text("V 0.1.0"))),
          ],
        ),
      ),
    );
  }
}
