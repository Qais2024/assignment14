import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:zalal/splashpage/splashpage.dart';
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("workerbox");
  await Hive.openBox("factorsbox");
  await Hive.openBox("receivedbox");
  await Hive.openBox('sales');
  await Hive.openBox("abcbox");
runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: splash_page(),
));
}

