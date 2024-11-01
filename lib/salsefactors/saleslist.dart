import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zalal/reports/salsereportes.dart';
import 'package:zalal/salsefactors/factor.dart';
import 'package:url_launcher/url_launcher.dart';
class factors_page extends StatefulWidget {
  const factors_page({super.key});
  @override
  State<factors_page> createState() => _SalesFactorsState();
}
class _SalesFactorsState extends State<factors_page> {
  List<Map<String, dynamic>> factorsList = [];
  List<Map<String, dynamic>> filteredFactorss = [];
  TextEditingController searchControllers = TextEditingController();
  @override
  void initState() {
    super.initState();
    filteredFactorss = [];
    loadFactors();
    searchControllers.addListener(() {
      filterFactorss();
    });
  }

  Future<void> _callcustomer(String number) async {
    final Uri launcher = Uri(scheme: 'tel', path: number);
    await launchUrl(launcher);
  }


  void filterFactorss() {
    String searchText = searchControllers.text.toLowerCase();
    setState(() {
      filteredFactorss = factorsList.where((factor) {
        String driverName = (factor["name"] ?? "").toLowerCase();
        String carNumber = (factor["number"] ?? "").toLowerCase();
        String factornumber = (factor["no"] ?? "").toLowerCase();
        String username = (factor["username"] ?? "").toLowerCase();
        return driverName.contains(searchText) || carNumber.contains(searchText)||factornumber.contains(searchText)||username.contains(searchText);
      }).toList();
    });
  }
  Future<void> loadFactors() async {
    final box = Hive.box("factorsbox");
    setState(() {
      String factorsListJson = box.get("factorslist", defaultValue: "[]");
      try {
        factorsList = List<Map<String, dynamic>>.from(jsonDecode(factorsListJson));
      } catch (e) {
        print("Error decoding JSON: $e");
        factorsList = [];
      }
      filteredFactorss = factorsList; // همگام‌سازی با لیست اصلی
    });
  }

  Future<void> saveFactors() async {
    final box = Hive.box("factorsbox");
    box.put("factorslist", jsonEncode(factorsList));
  }


  Future<void> addFactor() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => newfactor(factors: null),
      ),
    );

    if (result != null) {
      setState(() {
        factorsList.add(result);
        saveFactors();
        filterFactorss();
      });
    }
  }
  Future<void> editFactor({required Map<String, dynamic> factors, required int index}) async {

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => newfactor(factors: factors)),
    );
    if (result != null) {
      setState(() {
        factorsList[index] = result;
        saveFactors();
        filterFactorss();
      });
    }
  }
  void deleteFactor(int index) {
    setState(() {
      factorsList.removeAt(index);
      saveFactors();
      filterFactorss();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addFactor();
        },
        child: Icon(Icons.add,color: Colors.white,),
        backgroundColor: Colors.blue,
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: TextField(
          controller: searchControllers,
          decoration: InputDecoration(
            hintText: "Search...",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.black87),
          ),
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          IconButton(onPressed: (){
            setState(() {
              Navigator.push(context, MaterialPageRoute(builder: (context) => salesreports(),));
            });
          },icon:Icon(Icons.list_alt,color: Colors.yellowAccent,),)
        ],
      ),
      body: ListView.builder(
        itemCount: filteredFactorss.length,
        itemBuilder: (context, index) {
          List<dynamic> totalPrice = filteredFactorss[index]["total"] is List<dynamic> ? filteredFactorss[index]["total"] : [];
          double totalBell = calculateTotal(totalPrice);
          return GestureDetector(
            onTap:(){
              editFactor(factors: factorsList[index], index: index);
            },
            onLongPress:(){
            showDialog(context: context, builder: (context) {
              return AlertDialog(
                title: Text("Do you wanto delete thhis factor?"),
              actions: [
                ElevatedButton(onPressed:(){
                  setState(() {deleteFactor(index);});
                  Navigator.pop(context);
                }, child: Text("Yes")),
                ElevatedButton(onPressed:(){
                  setState(() {
                    Navigator.pop(context);
                  });
                }, child: Text("No")),
              ],
              );
            },);
            },
            child: Card(
              color: Colors.blue,
              child: Container(
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10),
                      Text("Customer: ${filteredFactorss[index]["name"]}"),
                      SizedBox(height: 10),
                      Text("Total Bell: ${totalBell.toStringAsFixed(0)}",
                        style: TextStyle(
                          color: (double.tryParse(filteredFactorss[index]["totalpay"].toString()) ?? 0) < totalBell
                              ? Colors.red // اگر total payment کمتر از total Bell باشد
                              : Colors.black, // در غیر این صورت رنگ سیاه
                        ),
                      ),

                      SizedBox(height: 10),
                      Text("Total payment: ${filteredFactorss[index]["totalpay"]}"),
                    ],
                  ),
                  trailing: IconButton(onPressed:()=>_callcustomer(filteredFactorss[index]["number"]),
                      icon: Icon(Icons.call))
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  double calculateTotal(List<dynamic> totalPrice) {
    return totalPrice.fold(0, (sum, price) => sum + double.parse(price.toString()));
  }
}
