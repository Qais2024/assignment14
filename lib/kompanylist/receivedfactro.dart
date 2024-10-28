import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class receivedfactor extends StatefulWidget {
  final Map<String, dynamic>? receicedfactor;
  const receivedfactor({super.key,this.receicedfactor});

  @override
  State<receivedfactor> createState() => _NewFactorState();
}

class _NewFactorState extends State<receivedfactor> {
  String? Salectedstaf;
  List<String> staffnameslist = [];
  TextEditingController textEditingController = TextEditingController();
  List<Map<String, dynamic>> productList = [];
  List<String> productNames = [];
  List<TextEditingController> objectControllers = [];
  List<TextEditingController> feelControllers = [];
  List<TextEditingController> priceControllers = [];
  List<TextEditingController> totalControllers = [];

  TextEditingController namelar = TextEditingController();
  TextEditingController numberlar = TextEditingController();
  TextEditingController nolar = TextEditingController();
  TextEditingController usernamelar = TextEditingController();
  TextEditingController paylar = TextEditingController();
  double totalFactorPrice = 0.0;

  @override
  void initState() {
    super.initState();
    loadstafName();
    if (widget.receicedfactor != null) {
      namelar.text = widget.receicedfactor!["name"] ?? "";
      numberlar.text = widget.receicedfactor!["number"] ?? "";
      nolar.text = widget.receicedfactor!["no"] ?? "";
      Salectedstaf = widget.receicedfactor!["username"] ?? "";
      paylar.text = widget.receicedfactor!["totalpay"] ?? "";

      List<String> object = List<String>.from(widget.receicedfactor!["object"] ?? []);
      List<String> fee = List<String>.from(widget.receicedfactor!["feed"] ?? []);
      List<String> price = List<String>.from(widget.receicedfactor!["price"] ?? []);
      List<String> total = List<String>.from(widget.receicedfactor!["total"] ?? []);

      for (int i = 0; i < object.length; i++) {
        TextEditingController objectController = TextEditingController(text: object[i]);
        TextEditingController feelController = TextEditingController(text: fee[i]);
        TextEditingController priceController = TextEditingController(text: price[i]);
        TextEditingController totalController = TextEditingController(text: total[i]);

        objectControllers.add(objectController);
        feelControllers.add(feelController);
        priceControllers.add(priceController);
        totalControllers.add(totalController);

        // Add listeners for live calculation
        feelController.addListener(() => calculate());
        priceController.addListener(() => calculate());
      }
    }
    loadProductNames();
  }

  void loadstafName() async {
    var box = await Hive.openBox("workerbox");
    setState(() {
      String productNameJson = box.get("workerslist", defaultValue: "[]");
      List<dynamic> products = jsonDecode(productNameJson);
      staffnameslist =
          products.map((product) => product["name"].toString()).toList();
    });
  }

  void loadProductNames() async {
    var box = await Hive.openBox("abcbox");
    setState(() {
      String productListJson = box.get("productlist", defaultValue: '[]');
      productList = List<Map<String, dynamic>>.from(jsonDecode(productListJson));
      productNames = productList.map((product) => product["name"].toString()).toList();
    });
  }

  void addRow() {
    setState(() {
      TextEditingController objectController = TextEditingController();
      TextEditingController feelController = TextEditingController();
      TextEditingController priceController = TextEditingController();
      TextEditingController totalController = TextEditingController();

      objectControllers.add(objectController);
      feelControllers.add(feelController);
      priceControllers.add(priceController);
      totalControllers.add(totalController);

      feelController.addListener(() => calculate());
      priceController.addListener(() => calculate());
    });
  }

  void calculate() {
    double newTotal = 0.0;
    for (int i = 0; i < feelControllers.length; i++) {
      double fee = double.tryParse(feelControllers[i].text) ?? 0.0;
      double price = double.tryParse(priceControllers[i].text) ?? 0.0;
      double total = fee * price;
      totalControllers[i].text = total.toStringAsFixed(2);
      newTotal += total;
    }
    setState(() {
      totalFactorPrice = newTotal;
    });
  }

  void updateSales(String productName, int fee) async {
    var salesBox = await Hive.openBox('sales');
    int currentSales = salesBox.get(productName, defaultValue: 0);
    salesBox.put(productName, currentSales + fee);
  }

  @override
  void dispose() {
    objectControllers.forEach((controller) => controller.dispose());
    feelControllers.forEach((controller) => controller.dispose());
    priceControllers.forEach((controller) => controller.dispose());
    totalControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            Text("Total: "),
            Text("${totalFactorPrice.toStringAsFixed(0)} Af"),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (namelar.text.isNotEmpty &&
                  numberlar.text.isNotEmpty &&
                  nolar.text.isNotEmpty &&
                  Salectedstaf != null) {
                bool allRowsValid = true;
                for (int i = 0; i < objectControllers.length; i++) {
                  if (objectControllers[i].text.isEmpty ||
                      feelControllers[i].text.isEmpty ||
                      priceControllers[i].text.isEmpty ||
                      totalControllers[i].text.isEmpty) {
                    allRowsValid = false;
                    break;
                  }
                }
                if (allRowsValid) {
                  for (int i = 0; i < objectControllers.length; i++) {
                    String productName = objectControllers[i].text;
                    int fee = int.parse(feelControllers[i].text);
                    updateSales(productName, fee);
                  }

                  DateTime now = DateTime.now();
                  Navigator.pop(context, {
                    "name": namelar.text,
                    "number": numberlar.text,
                    "no": nolar.text,
                    "username": Salectedstaf,
                    "totalpay": paylar.text,
                    "object": objectControllers.map((e) => e.text).toList(),
                    "feed": feelControllers.map((e) => e.text).toList(),
                    "price": priceControllers.map((e) => e.text).toList(),
                    "total": totalControllers.map((e) => e.text).toList(),
                    "date": "${now.day}/${now.month}/${now.year}",
                    "time": "${now.hour}:${now.minute}:${now.second}",
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("All fields must be filled out.")),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please fill out all required fields.")),
                );
              }
            },
            icon: Icon(Icons.check),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addRow,
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              // Main Form Fields
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: namelar,
                      decoration: InputDecoration(
                        labelText: "Deliverezssdss name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: numberlar,
                      decoration: InputDecoration(
                        labelText: "Number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButton2<String>(
                      value: Salectedstaf,
                      isExpanded: true,
                      hint: const Row(
                        children: [
                          Icon(
                            Icons.list,
                            size: 20,
                            color: Colors.blueAccent,
                          ),
                          Text("Seller"),
                        ],
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          Salectedstaf = newValue;
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 50,
                        width: 160,
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all()),
                      ),
                      dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                          )),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                        padding: const EdgeInsets.only(left: 14, right: 14),
                      ),
                      items: staffnameslist
                          .map<DropdownMenuItem<String>>((String name) {
                        return DropdownMenuItem<String>(
                          value: name,
                          child: Text(name),
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: nolar,
                      decoration: InputDecoration(
                        labelText: "Factor number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Column(
                    children: [
                      Text("Products: ${objectControllers.length}"),
                    ],
                  ),
                  SizedBox(width:70 ,),
                  Column(
                    children: [
                    Text("Factor",style: TextStyle(color: Colors.blue,fontSize: 24,),),
                  ],)
                ],
              ),
              SizedBox(height: 10),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1),
                  4: FlexColumnWidth(1),
                },
                children: [
                  for (int i = 0; i < objectControllers.length; i++)
                    TableRow(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                       border: Border.fromBorderSide(BorderSide(color: Colors.blue,strokeAlign: 0))
                      ),
                      children: [
                        Expanded(
                          child: DropdownButton2<String>(
                            value: objectControllers[i].text.isNotEmpty ? objectControllers[i].text : null, // مقدار اولیه
                            items: productNames
                                .map((name) => DropdownMenuItem<String>(
                              value: name,
                              child: Text(name),
                            ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                objectControllers[i].text = value ?? '';
                              });
                            },
                            hint: Text('Product'),
                            dropdownSearchData: DropdownSearchData(
                              searchController: textEditingController,
                              searchInnerWidgetHeight: 50,
                              searchInnerWidget: Container(
                                height: 60,
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 4,
                                  right: 8,
                                  left: 8,
                                ),
                                child: TextFormField(
                                  expands: true,
                                  maxLines: null,
                                  controller: textEditingController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    hintText: 'Search for an item...',
                                    hintStyle: const TextStyle(fontSize: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              searchMatchFn: (item, searchValue) {
                                return item.value
                                    .toString()
                                    .contains(searchValue);
                              },
                            ),
                            onMenuStateChange: (isOpen) {
                              if (!isOpen) {
                                textEditingController.clear();
                              }
                            },
                          ),
                        ),
                        TextFormField(
                          controller: feelControllers[i],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Qty",
                            hintStyle: TextStyle(fontSize: 14),
                          ),
                        ),
                        TextFormField(
                          controller: priceControllers[i],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Price",
                            hintStyle: TextStyle(fontSize: 14),
                          ),
                        ),
                        TextFormField(
                          controller: totalControllers[i],
                          readOnly: true,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Total",
                            hintStyle: TextStyle(fontSize: 14),
                          ),
                        ),
                        IconButton(onPressed:(){
                          setState(() {
                            objectControllers[i].dispose();
                            feelControllers[i].dispose();
                            priceControllers[i].dispose();
                            totalControllers[i].dispose();

                            objectControllers.removeAt(i);
                            feelControllers.removeAt(i);
                            priceControllers.removeAt(i);
                            totalControllers.removeAt(i);

                            // به روزرسانی محاسبه کل پس از حذف
                            calculate();
                          });
                        }, icon: Icon(Icons.delete))
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}