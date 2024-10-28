import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class salesreports extends StatefulWidget {
  const salesreports({super.key});

  @override
  State<salesreports> createState() => _salesreportsState();
}
class _salesreportsState extends State<salesreports> {
  List<Map<String, dynamic>> salselist = [];
  Map<String, int> productQuantities = {};

  Future<void> loadFactors() async {
    final box = Hive.box("factorsbox");
    String factorsListJson = box.get("factorslist", defaultValue: "[]");
    salselist = List<Map<String, dynamic>>.from(jsonDecode(factorsListJson));
    calculateProductQuantit();
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
          int fee = int.parse(feeText);
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
  }

  @override
  Widget build(BuildContext context) {
    if (salselist.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue,
      title: Text("Sales list"),
      ),
      body: ListView.builder(
        itemCount: productQuantities.length,
        itemBuilder: (context, index) {
          String productName = productQuantities.keys.elementAt(index);
          int totalFee = productQuantities[productName]!;
          return Card(
            color: Colors.blue,
            child: ListTile(
              title: Row(
                children: [
                  Text("Item name: ",style: TextStyle(color: Colors.black87),),
                  Text("$productName",style: TextStyle(color: Colors.black87),),
                ],
              ),
              subtitle:Row(
                children: [
                  Text("Salse : ",style: TextStyle(color: Colors.black87),),
                  Text("$totalFee",style: TextStyle(color: Colors.black87),),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
