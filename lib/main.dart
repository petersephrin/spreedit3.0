import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spreedit/firebase_options.dart';
import 'package:spreedit/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //syncfusion
  //Ngo9BigBOggjHTQxAR8/V1NCaF1cWWhBYVZpR2Nbe05zflVEal9VVAciSV9jS3pTcUdqWXxecndRRmVeUg==
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SpreedIt',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 7, 51, 145)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'SpreedIt'),
    );
  }
}
