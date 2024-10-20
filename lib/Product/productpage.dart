import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class objectpage extends StatefulWidget {
  final Map<String, dynamic>? products;
  const objectpage({super.key, this.products});
  @override
  State<objectpage> createState() => _productspageState();
}

class _productspageState extends State<objectpage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController idlar = TextEditingController();
  TextEditingController namelar = TextEditingController();
  TextEditingController perpaklar = TextEditingController();
  TextEditingController totalprice = TextEditingController();
  TextEditingController perprice = TextEditingController();
  TextEditingController salselae = TextEditingController();
  @override
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
  }

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
        backgroundColor: Colors.amberAccent,
        title: Text("Registar product"),
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
                    labelText: "Every pack",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    return value!.isEmpty ? "Please enter Per pack" : null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: totalprice,
                  decoration: InputDecoration(
                    labelText: "Total price",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    return value!.isEmpty ? "Please enter Total price" : null;
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
                  validator: (value) {
                    return value!.isEmpty ? "Please enter Per price" : null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: salselae,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Salse ",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    return value!.isEmpty ? "Please enter Salse" : null;
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
