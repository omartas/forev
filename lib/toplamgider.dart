import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forev/colors.dart' as AppColors;
import 'package:forev/homepage.dart';
import 'package:forev/loginscreen.dart';
import 'package:intl/intl.dart';

class GiderWidget extends StatefulWidget {
  const GiderWidget({
    Key? key,
    required this.dateTime,
  }) : super(key: key);

  final DateTime dateTime;

  @override
  State<GiderWidget> createState() => _GiderWidgetState();
}

class _GiderWidgetState extends State<GiderWidget> {


  final user = FirebaseAuth.instance.currentUser;
  late String alanKisi = user!.email!.toString().split("@")[0];
  String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  CollectionReference collection = FirebaseFirestore.instance.collection("hane1");
  late var ref1= FirebaseFirestore.instance.collection("hane1").orderBy("tarih",descending: true);


  TextEditingController nesneController = TextEditingController();
  TextEditingController fiyatController = TextEditingController();




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: [
          Text(alanKisi),
          IconButton(onPressed: (){
            FirebaseAuth.instance.signOut();
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                LoginScreen()), (Route<dynamic> route) => false);
          },
              icon: Icon(Icons.exit_to_app))
        ],
        title: Text(
          "Hane - Giderler",
        ),
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: ref1.snapshots(),
            builder:(BuildContext context,AsyncSnapshot asyncsnapshot) {
              if(asyncsnapshot.hasError){
                return Center(child: Text("bir hata oldu"),);
              }else{
                if(asyncsnapshot.hasData){
                  List<DocumentSnapshot>listOfDocumentSnap = asyncsnapshot.data
                      .docs;
                  return EkranWidget(listOfDocumentSnap: listOfDocumentSnap);
                }else{
                  return Center(child: CircularProgressIndicator(),);
                }
              }


            }
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    width: 60,
                    child: TextField(
                      decoration: InputDecoration(hintText: "Ne ald??n"),
                      controller: nesneController,
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Container(
                  width: 50,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: fiyatController,
                    decoration: InputDecoration(hintText: "TL"),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                IconButton(
                    onPressed: () {

                      if (nesneController.text.isNotEmpty &&
                          fiyatController.text.isNotEmpty) {

                        collection.add({
                          "alan": alanKisi,
                          "al??nan": nesneController.text.toString(),
                          "tarih": formattedDate,
                          "fiyat": fiyatController.text
                        });
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                            HomePage()), (Route<dynamic> route) => false);
                      } else {}
                    },
                    icon: Icon(Icons.add)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EkranWidget extends StatefulWidget {


  EkranWidget({Key? key,required this.listOfDocumentSnap}) : super(key: key);

  final List<DocumentSnapshot<Object?>> listOfDocumentSnap;

  @override
  State<EkranWidget> createState() => _EkranWidgetState();
}

class _EkranWidgetState extends State<EkranWidget> {
  late List<String> strFiyat=[];

  late double genelKullanim=0;



  @override
  Widget build(BuildContext context) {
    strFiyat=[];
    int i =1;
    return Expanded(
      child: ListView.builder(
        shrinkWrap: false,
        itemCount: widget.listOfDocumentSnap.length,
        itemBuilder: (context, index) {
          List<int> fiyatInt =[];
          print("Listview ??al????t??");
          strFiyat.add(widget.listOfDocumentSnap[index]["fiyat"]);
          print(widget.listOfDocumentSnap.length);
          fiyatInt = strFiyat.map(int.parse).toList();
          if(widget.listOfDocumentSnap.length>=i){
            genelKullanim = fiyatInt.fold(0, (previousValue, element) => previousValue+element);
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
                title: Text(widget.listOfDocumentSnap[index]["al??nan"]+" : "+widget.listOfDocumentSnap[index]["fiyat"]+" TL  "),
                leading: Text(
                  widget.listOfDocumentSnap[index]["alan"],
                  textAlign: TextAlign.center,

                ),
                trailing: Text(
                  genelKullanim.toString().split(".")[0] +" TL  "+
                  widget.listOfDocumentSnap[index]["tarih"].toString(),
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


