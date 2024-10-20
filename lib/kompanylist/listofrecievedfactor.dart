import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zalal/kompanylist/receivedfactro.dart';
import '../reports/receivedreports.dart';
class receivedlist extends StatefulWidget {
  const receivedlist({super.key});
  @override
  State<receivedlist> createState() => _SalesFactorsState();
}
class _SalesFactorsState extends State<receivedlist> {

  List<Map<String, dynamic>> receivedlist = [];
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

  Future<void> loadFactors() async {
    final box = Hive.box("receivedbox");
    setState(() {
      String factorsListJson = box.get("receivedfactorslist", defaultValue: "[]");
      try {
        receivedlist = List<Map<String, dynamic>>.from(jsonDecode(factorsListJson));
      } catch (e) {
        print("Error decoding JSON: $e");
        receivedlist = [];
      }
      filteredFactorss = receivedlist;
    });
  }
  void filterFactorss() {
    String searchText = searchControllers.text.toLowerCase();
    setState(() {
      filteredFactorss = receivedlist.where((factor) {
        String driverName = (factor["name"] ?? "").toLowerCase();
        String carNumber = (factor["number"] ?? "").toLowerCase();
        return driverName.contains(searchText) || carNumber.contains(searchText);
      }).toList();
    });
  }

  Future<void> saveFactors() async {
    final box = Hive.box("receivedbox");
    box.put("receivedfactorslist", jsonEncode(receivedlist));
  }


  Future<void> addFactor() async {

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => receivedfactor(receicedfactor: null),
      ),
    );

    if (result != null) {
      setState(() {
        receivedlist.add(result);
        saveFactors();
        filterFactorss();
      });
    }
  }



  Future<void> editFactor({required Map<String, dynamic> factors, required int index}) async {

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => receivedfactor(receicedfactor:factors)),
    );
    if (result != null) {
      setState(() {
        receivedlist[index] = result;
        saveFactors();
        filterFactorss();
      });
    }
  }
  void deleteFactor(int index) {
    setState(() {
      receivedlist.removeAt(index);
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
        child: Icon(Icons.add),
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => receivedreports(),));
            });
          },icon:Icon(Icons.list_alt),)
        ],
      ),
      body: ListView.builder(
        itemCount: filteredFactorss.length,
        itemBuilder: (context, index) {
          List<dynamic> totalPrice = filteredFactorss[index]["total"] is List<dynamic> ? filteredFactorss[index]["total"] : [];
          double totalBell = calculateTotal(totalPrice);
          return GestureDetector(
            onTap:(){
              editFactor(factors: receivedlist[index], index: index);
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
              color: Colors.white,
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10),
                    Text("Customer: ${filteredFactorss[index]["name"]}"),
                    SizedBox(height: 10),
                    Text("Total Bell: ${totalBell.toStringAsFixed(1)}",
                      style: TextStyle(
                        color: totalBell > (double.tryParse(filteredFactorss[index]["total"].toString()) ?? 0)
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                  ],
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
