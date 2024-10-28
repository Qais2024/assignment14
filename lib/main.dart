import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:zalal/loginpages/bloc/authbloc/authbloc_bloc.dart';
import 'package:zalal/loginpages/databasehelper/repository.dart';
import 'package:zalal/setting/theme_setting/themeprovider.dart';
import 'package:provider/provider.dart';
import 'package:zalal/splashpage/splashpage.dart';

void main() async {
  runApp(
      ChangeNotifierProvider(create: (_) => ThemeProvider(), child: Myapp(),));
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("workerbox");
  await Hive.openBox("factorsbox");
  await Hive.openBox("receivedbox");
  await Hive.openBox('sales');
  await Hive.openBox("abcbox");
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    final themprovider = Provider.of<ThemeProvider>(context);
    return BlocProvider(
      create: (context) => AuthblocBloc(Repository()),
      child: MaterialApp(themeMode: themprovider.themeMode,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.light
        ),
        darkTheme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.dark
        ),
        debugShowCheckedModeBanner: false,
        home: splash_page(),
      ),
    );
  }
}


// localizationsDelegates: [
//   GlobalMaterialLocalizations.delegate,
//   GlobalWidgetsLocalizations.delegate,
//   GlobalCupertinoLocalizations.delegate,
// ],
// supportedLocales: [
//   Locale('en', ''),
//   Locale('fa', ''),
// ],
//   locale: Locale("en"),