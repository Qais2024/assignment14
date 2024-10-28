import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class objectpage extends StatefulWidget {
  final Map<String, dynamic>? products;
  const objectpage({super.key, this.products});

  @override
  State<objectpage> createState() => _ObjectPageState();
}

class _ObjectPageState extends State<objectpage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController idlar = TextEditingController();
  TextEditingController namelar = TextEditingController();
  TextEditingController perpaklar = TextEditingController();
  TextEditingController totalprice = TextEditingController();
  TextEditingController perprice = TextEditingController();
  TextEditingController salselae = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.products != null) {
      idlar.text = widget.products!["iid"]!;
      namelar.text = widget.products!["name"]!;
      perpaklar.text = widget.products!["perpak"]!;
      totalprice.text = widget.products!["totalprice"]!;
      perprice.text = widget.products!["perprice"]!;
      salselae.text = widget.products!["salse"]!;
    }

    // افزودن لیسنر به totalprice
    totalprice.addListener(() {
      calculatePerPrice();
    });

    // افزودن لیسنر به perpaklar
    perpaklar.addListener(() {
      calculatePerPrice();
    });
  }

  void calculatePerPrice() {
    // تبدیل مقادیر به double
    double totalPriceValue = double.tryParse(totalprice.text) ?? 0;
    double perPackValue = double.tryParse(perpaklar.text) ?? 1; // به‌منظور جلوگیری از تقسیم بر صفر

    // محاسبه perprice
    if (perPackValue > 0) {
      double calculatedPerPrice = totalPriceValue / perPackValue;
      perprice.text = calculatedPerPrice.toStringAsFixed(2); // دو رقم اعشار
    } else {
      perprice.text = '0'; // در صورت صفر بودن perpak
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Navigator.pop(context, {
              "iid": idlar.text,
              "name": namelar.text,
              "perpak": perpaklar.text,
              "totalprice": totalprice.text,
              "perprice": perprice.text,
              "salse": salselae.text,
            });
          }
        },
        child: Icon(Icons.save),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Register Product"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                child: TextFormField(
                  controller: idlar,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "ID",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    return value!.isEmpty ? "Please enter ID" : null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: namelar,
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    return value!.isEmpty ? "Please enter Name" : null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: perpaklar,
                  decoration: InputDecoration(
                    labelText: "Every Pack",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    return value!.isEmpty ? "Please enter Per Pack" : null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: totalprice,
                  decoration: InputDecoration(
                    labelText: "Total Price",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    return value!.isEmpty ? "Please enter Total Price" : null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: perprice,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Per Price",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  readOnly: true, // غیر قابل ویرایش
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: salselae,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Sales",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    return value!.isEmpty ? "Please enter Sales" : null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
