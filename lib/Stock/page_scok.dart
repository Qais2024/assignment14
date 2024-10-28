import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Stock_page extends StatefulWidget {
  const Stock_page({super.key});

  @override
  State<Stock_page> createState() => _salesreportsState();
}

class _salesreportsState extends State<Stock_page> {
  List<Map<String, dynamic>> salselist = [];
  List<Map<String, dynamic>> receivedlist = [];
  Map<String, int> productQuantities = {};
  Map<String, int> receivedQuantities = {};

  Future<void> loadFactors() async {
    final box = Hive.box("factorsbox");
    String factorsListJson = box.get("factorslist", defaultValue: "[]");
    salselist = List<Map<String, dynamic>>.from(jsonDecode(factorsListJson));
    calculateProductQuantit();
  }

  Future<void> loadFactorsrecevied() async {
    final box = Hive.box("receivedbox");
    String factorsListJson = box.get("receivedfactorslist", defaultValue: "[]");
    receivedlist = List<Map<String, dynamic>>.from(jsonDecode(factorsListJson));
    calculateProductQuantitreceived();
  }

  void calculateProductQuantitreceived() {
    Map<String, int> tempProductQuantitiesr = {};
    for (var sale in receivedlist) {
      List<String> productNames = sale["object"] is List ? List<String>.from(sale["object"]) : [];
      List<String> feeList = sale["feed"] is List ? List<String>.from(sale["feed"]) : [];

      for (int i = 0; i < productNames.length; i++) {
        String productName = productNames[i];
        String feeText = feeList.length > i ? feeList[i] : "0";
        try {
          int fee = int.parse(feeText);
          if (tempProductQuantitiesr.containsKey(productName)) {
            tempProductQuantitiesr[productName] = tempProductQuantitiesr[productName]! + fee;
          } else {
            tempProductQuantitiesr[productName] = fee;
          }
        } catch (e) {
          print("Error parsing fee: $feeText");
        }
      }
    }
    setState(() {
      receivedQuantities = tempProductQuantitiesr;
    });
  }

  void calculateProductQuantit() {
    Map<String, int> tempProductQuantities = {};
    for (var sale in salselist) {
      List<String> productNames = sale["object"] is List ? List<String>.from(sale["object"]) : [];
      List<String> feeList = sale["fee"] is List ? List<String>.from(sale["fee"]) : [];

      for (int i = 0; i < productNames.length; i++) {
        String productName = productNames[i];
        String feeText = feeList.length > i ? feeList[i] : "0";
        try {
          int fee = int.parse(feeText); // تبدیل به عدد
          if (tempProductQuantities.containsKey(productName)) {
            tempProductQuantities[productName] = tempProductQuantities[productName]! + fee;
          } else {
            tempProductQuantities[productName] = fee;
          }
        } catch (e) {
          print("Error parsing fee: $feeText");
        }
      }
    }
    setState(() {
      productQuantities = tempProductQuantities;
    });
  }
  @override
  void initState() {
    super.initState();
    loadFactors();
    loadFactorsrecevied();
  }
  @override
  Widget build(BuildContext context) {
    if (salselist.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue,
      title: Text("Stock list"),),
      body: ListView.builder(
        itemCount: productQuantities.length,
        itemBuilder: (context, index) {
          String productName = productQuantities.keys.elementAt(index);
          int totalFee = productQuantities[productName] ?? 0;
          int receivedQty = receivedQuantities[productName] ?? 0;
          int totalobject=receivedQty-totalFee;
          return Card(
            color: Colors.blue,
            child: ListTile(
              title: Row(
                children: [
                  Text("Item name: ",),
                  Text("$productName", style: TextStyle(color: Colors.blue,fontSize: 15)),
                ],
              ),
              subtitle: Row(
                children: [
                  Text("Sales object: ",),
                  Text("$totalFee", style: TextStyle(color: Colors.red)),
                  SizedBox(width: 20),
                  Text("Received object: ",),
                  Text("$receivedQty", style: TextStyle(color: Colors.black87)),
                ],
              ),
              trailing: Column(children: [
                Text("Total",),
                Text( "$totalobject",
                    style: TextStyle(
                        color: totalobject < 0 ? Colors.red : totalobject > 0 ? Colors.white : Colors.black,fontSize: 15)),
              ],),
            ),
          );
        },
      ),
    );
  }
}
