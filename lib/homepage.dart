import 'package:flutter/material.dart';
import 'package:forev/seperated.dart';
import 'package:forev/toplamgider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  int currenIndex =0;
  DateTime dateTime = DateTime.now();
  final screens = [
    GiderWidget(dateTime: DateTime.now()),
    AyrikGiderler(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currenIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 15,
        onTap: (index)=> setState(()=>currenIndex=index) ,
          currentIndex: currenIndex,
          items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "home"
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.grade_sharp),
            label: "Seperated"
        ),
      ]),
    );
  }
}

