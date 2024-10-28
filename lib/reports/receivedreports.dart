import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
class receivedreports extends StatefulWidget {
  const receivedreports({super.key});
  @override
  State<receivedreports> createState() => _receivedreportsState();
}
class _receivedreportsState extends State<receivedreports> {
  List<Map<String,dynamic>>receviedlist=[];
  Map<String,int > productquantities={};

  @override
  void initState() {
    super.initState();
    loadreceived();
  }
  Future<void>loadreceived()async{
    final box=Hive.box("receivedbox");
    String receivedlistjson=box.get("receivedfactorslist",defaultValue: "[]");
    receviedlist=List<Map<String,dynamic>>.from(jsonDecode(receivedlistjson));
    calculatereceivedquaintite();
  }

  void calculatereceivedquaintite(){
    Map<String,int>tempprodectquantitereceived={};
    for(var received in receviedlist){
      List<String> productnames=received["object"] is List? List<String>.from(received["object"]):[];
      List<String> feed=received["feed"] is List? List<String>.from(received["feed"]):[];

      for(int i=0; i<productnames.length;i++){
        String productname=productnames[i];
        String feedtext=feed.length> i? feed[i]:"0";
        try{
          int fee =int.parse(feedtext);
          if(tempprodectquantitereceived.containsKey(productname)){
            tempprodectquantitereceived[productname]=tempprodectquantitereceived[productname]!+fee;
          }else{
            tempprodectquantitereceived[productname]=fee;
          }
        }catch(e){
          print("error $feedtext");
        }
      }
    }
    setState(() {
      productquantities=tempprodectquantitereceived;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (receviedlist.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.blue,
        title: Text("Received list"),
      ),
      body: ListView.builder(
        itemCount: productquantities.length,
        itemBuilder: (context, index) {
          String producname=productquantities.keys.elementAt(index);
          int totalfeed=productquantities[producname]!;
        return Card(
          color: Colors.blue,
          child:ListTile(
            title: Row(
              children: [
                Text("Item name: ",style: TextStyle(color: Colors.black87),),
                Text("$producname",style: TextStyle(color: Colors.black87),),
              ],
            ),
            subtitle:Row(
              children: [
                Text("Received: ",style: TextStyle(color: Colors.black87),),
                Text("$totalfeed",style: TextStyle(color: Colors.black87),),
              ],
            ),
          )
          ,);
      },
      ),
    );
  }
}
