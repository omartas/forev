import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forev/colors.dart' as AppColors;

class AyrikGiderler extends StatefulWidget {


  @override
  State<AyrikGiderler> createState() => _AyrikGiderlerState();
}

class _AyrikGiderlerState extends State<AyrikGiderler> {
  DateTime focusedDay=DateTime.now();

  final user = FirebaseAuth.instance.currentUser;

  late String alanKisi = user!.email!.toString().split("@")[0];

  late var ref1= FirebaseFirestore.instance.collection("hane1").where("alan",isEqualTo: alanKisi).orderBy("tarih",descending: true);

  late var reftarih= FirebaseFirestore.instance.collection("hane1").where("tarih",isGreaterThan: "2022-09").where("tarih",isLessThanOrEqualTo: "2022-12").orderBy("tarih",descending: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(
          "Ayrık - Giderler",
        ),
      ),
      body: Column(
        children:<Widget> [

          StreamBuilder(

              stream: ref1.snapshots(),
              builder:(BuildContext context,AsyncSnapshot asyncsnapshot) {
                if(asyncsnapshot.hasError){
                  return Center(child: Text(asyncsnapshot.error.toString()),);
                }else{
                  if(asyncsnapshot.hasData){
                    List<DocumentSnapshot>listOfDocumentSnap = asyncsnapshot.data
                        .docs;
                    return AyrikEkran(listOfDocumentSnap: listOfDocumentSnap);
                  }else{
                    return Center(child: CircularProgressIndicator(),);
                  }
                }
              }
          ),
        ],
      ),
    );
  }
}

class AyrikEkran extends StatelessWidget {
  int i = 1;

  late List<String> strFiyat=[];

  late double kisiselKullanim=0;

   AyrikEkran({Key? key,required this.listOfDocumentSnap}) : super(key: key);

  final List<DocumentSnapshot<Object?>> listOfDocumentSnap;


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: listOfDocumentSnap.length,
        itemBuilder: (context, index) {
          strFiyat.add(listOfDocumentSnap[index]["fiyat"]);
          List<int> fiyatInt =[];
          fiyatInt = strFiyat.map(int.parse).toList();
          print(listOfDocumentSnap.length);
          if(listOfDocumentSnap.length>=i){
            kisiselKullanim = fiyatInt.fold(0, (previousValue, element) => previousValue+element);
            i++;
          }
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(

              decoration: BoxDecoration(
                color: AppColors.audioGreyBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: ListTile(
                title: Text(listOfDocumentSnap[index]["alınan"]+" : "+listOfDocumentSnap[index]["fiyat"]+" TL"),
                leading: Text(
                  listOfDocumentSnap[index]["alan"],
                  textAlign: TextAlign.center,
                ),
                trailing: Text(kisiselKullanim.toString().split(".")[0]+" TL   "+
                  listOfDocumentSnap[index]["tarih"],
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
