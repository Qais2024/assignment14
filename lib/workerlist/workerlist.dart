import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zalal/workerlist/workerpage.dart';

class WorkerList extends StatefulWidget {
  const WorkerList({super.key});
  @override
  State<WorkerList> createState() => _WorkerListState();
}

class _WorkerListState extends State<WorkerList> {
  List<Map<String, dynamic>> workersList = [];

  @override
  void initState() {
    super.initState();
    loadWorkersList();
  }

  Future<void> loadWorkersList() async {
    final box = Hive.box("workerbox");
    setState(() {
      String workersListJson = box.get("workerslist", defaultValue: '[]');
      workersList = List<Map<String, dynamic>>.from(jsonDecode(workersListJson));
    });
  }

  Future<void> saveWorkers() async {
    final box = Hive.box("workerbox");
    box.put("workerslist", jsonEncode(workersList));
  }

  Future<void> addEditWorker({Map<String, dynamic>? worker, int? index}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => workerpage(worker: worker)),
    );
    if (result != null) {
      setState(() {
        if (index != null) {
          workersList[index] = result;
        } else {
          workersList.add(result);
        }
        saveWorkers();
      });
    }
  }

  void deleteWorker(int index) {
    setState(() {
      workersList.removeAt(index);
      saveWorkers();
    });
  }

  Future<void> pickImage(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        workersList[index]["imagePath"] = pickedFile.path;
        saveWorkers();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Center(child: Text("List of Workers")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addEditWorker();
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: workersList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              addEditWorker(worker: workersList[index], index: index);
            },
            onLongPress: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Do you want to delete this worker?"),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            deleteWorker(index);
                          });
                          Navigator.pop(context);
                        },
                        child: Text("Yes"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("No"),
                      ),
                    ],
                  );
                },
              );
            },
            child: Card(
              color: Colors.green,
              child: ListTile(
                leading: GestureDetector(
                  onTap: () {
                    pickImage(index);
                  },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: workersList[index]["imagePath"] != null &&
                        workersList[index]["imagePath"] != ''
                        ? FileImage(File(workersList[index]["imagePath"]))
                        : null,
                    child: workersList[index]["imagePath"] == null
                        ? Icon(Icons.camera_alt)
                        : null,
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("ID: ${workersList[index]["iid"]}"),
                    SizedBox(height: 10),
                    Text("Name: ${workersList[index]["name"]}"),
                    SizedBox(height: 10),
                    Text("Last Name: ${workersList[index]["lastname"]}"),
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
