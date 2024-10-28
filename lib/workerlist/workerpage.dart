import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class workerpage extends StatefulWidget {
  final Map<String, dynamic>? worker;
  const workerpage({super.key, this.worker});
  @override
  State<workerpage> createState() => _WorkerPageState();
}
class _WorkerPageState extends State<workerpage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController tazkeraController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.worker != null) {
      idController.text = widget.worker!["iid"] ?? '';
      nameController.text = widget.worker!["name"] ?? '';
      fatherNameController.text = widget.worker!["fathername"] ?? '';
      lastNameController.text = widget.worker!["lastname"] ?? '';
      tazkeraController.text = widget.worker!["tazkera"] ?? '';
      phoneNumberController.text = widget.worker!["phonenumber"] ?? '';
      addressController.text = widget.worker!["address"] ?? '';
      ageController.text = widget.worker!["age"] ?? '';
      dateController.text = widget.worker!["date"] ?? '';
      salaryController.text = widget.worker!["salary"] ?? '';
    }
  }
  Future<void> selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Navigator.pop(context, {
              "iid": idController.text,
              "name": nameController.text,
              "fathername": fatherNameController.text,
              "lastname": lastNameController.text,
              "tazkera": tazkeraController.text,
              "phonenumber": phoneNumberController.text,
              "address": addressController.text,
              "age": ageController.text,
              "date": dateController.text,
              "salary": salaryController.text,
            });
          }
        },
        child: Icon(Icons.save),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Register Worker"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: idController,
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
                  controller: nameController,
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
                  controller: fatherNameController,
                  decoration: InputDecoration(
                    labelText: "Father Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    return value!.isEmpty ? "Please enter Father name" : null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    labelText: "Last Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    return value!.isEmpty ? "Please enter Last name" : null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: tazkeraController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Tazkera number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    return value!.isEmpty ? "Please enter Tazkera number" : null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    return value!.isEmpty ? "Please enter Phone number" : null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: "Address",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    return value!.isEmpty ? "Please enter Address" : null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Age",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    return value!.isEmpty ? "Please enter Age" : null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Date",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    return value!.isEmpty ? "Please enter Date" : null;
                  },
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
                      });
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: salaryController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Salary",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    return value!.isEmpty ? "Please enter Salary" : null;
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
