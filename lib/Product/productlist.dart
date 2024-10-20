import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zalal/Product/productpage.dart';

class objectlist extends StatefulWidget {
  const objectlist({super.key});
  @override
  State<objectlist> createState() => _salesfacorsState();
}
class _salesfacorsState extends State<objectlist> {
  List<Map<String, dynamic>> productlist = [];
  List<Map<String, dynamic>> filteredFactorss = [];
  TextEditingController searchControllers = TextEditingController();
  @override
  void initState() {
    super.initState();
    filteredFactorss = [];
    laodworkerslist();
    searchControllers.addListener(() {
      filterFactorss();
    });
  }

  Future<void>pickimage(int index)async{
    final picker=ImagePicker();
    final pickedfile=await picker.pickImage(source: ImageSource.gallery);
    if(pickedfile!=null){
      setState(() {
        productlist[index]["imagePath"]=pickedfile.path;
        saveproduct();
      });
    }
  }
  void filterFactorss() {
    String searchText = searchControllers.text.toLowerCase();
    setState(() {
      filteredFactorss = productlist.where((factor) {
        String productName = (factor["name"] ?? "").toLowerCase();
        String totalprice = (factor["totalprice"] ?? "").toLowerCase();
        return productName.contains(searchText) || totalprice.contains(searchText);
      }).toList();
    });
  }
  Future<void> laodworkerslist() async {
    final box = Hive.box("abcbox");
    setState(() {
      String factorsListJson = box.get("productlist", defaultValue: '[]');
      productlist = List<Map<String, dynamic>>.from(jsonDecode(factorsListJson));
      filteredFactorss = productlist;
    });
  }
  Future<void> saveproduct() async {
    final box = Hive.box("abcbox");
    box.put("productlist", jsonEncode(productlist));
  }
  Future<void> addeditelist({Map<String, dynamic>? object, int? index}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => objectpage(products: object),
      ),
    );
    if (result != null) {
      setState(() {
        if (index != null) {
          productlist[index] = result;
        } else {
          productlist.add(result);
        }
        saveproduct();
      });
    }
  }

  void deleteproducts(int index) {
    setState(() {
      productlist.removeAt(index);
      saveproduct();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title:TextField(
          controller: searchControllers,
          decoration: InputDecoration(
            hintText: "Search...",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.black87),
          ),
          style: TextStyle(color: Colors.black87),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addeditelist();
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: filteredFactorss.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap:(){ addeditelist(object: filteredFactorss[index], index: index);},
            onLongPress:(){
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title: Text("Do you wanto delete thhis factor?"),
                  actions: [
                    ElevatedButton(onPressed:(){
                      setState(() { deleteproducts(index);});
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
              color: Colors.lightBlue,
              child: ListTile(
                leading: GestureDetector(
                  onTap: (){pickimage(index);},
                  child: CircleAvatar(
                    radius: 40,
                  backgroundImage: productlist[index]["imagePath"]!=null&&
                      productlist[index]["imagePath"] !=""
                      ? FileImage(File(productlist[index]["imagePath"]))
                      :null,
                  ),
                ),
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name: ${filteredFactorss[index]["name"]}"),
                        SizedBox(height: 10),
                        Text("Price: ${filteredFactorss[index]["totalprice"]}"),
                        SizedBox(height: 10),
                        Text("Salse Price: ${filteredFactorss[index]["salse"]} af"),
                      ],
                    ),
                    SizedBox(width: 50),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
