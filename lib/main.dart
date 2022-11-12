import 'package:flutter/material.dart';
import 'package:forev/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:forev/loginscreen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
   runApp( MyApp());
}

class MyApp extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: FutureBuilder(
          future: _initialization,
          builder: (context,snapshot){
            if(snapshot.hasError){
              return Center(child: Text("hata oluştu"));
            }else if(snapshot.hasData){
              return LoginScreen();
            }else{
              return Center(child: CircularProgressIndicator(),);
            }
          }),
    );
  }
}
