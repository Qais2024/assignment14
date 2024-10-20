import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:zalal/firstpage/firstpage.dart';
class splash_page extends StatefulWidget {
  const splash_page({super.key});
  @override
  State<splash_page> createState() => _splash_pageState();
}
class _splash_pageState extends State<splash_page> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => firstpage(),));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: CircleAvatar(
                backgroundImage:AssetImage("image/splash.jpg") ,
                radius: 150,
              ),
            ),
            Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Center(child: Text("V 0.0.1")))
          ],
        ),
      )
    );
  }
}
