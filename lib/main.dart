import 'package:flutter/material.dart';
import 'package:training2/api.dart';
import 'package:training2/functions.dart';
import 'package:training2/model.dart';

void main() {
  runApp(const MyWidget());
}

TextEditingController nameController = TextEditingController();
TextEditingController ageController = TextEditingController();
ValueNotifier<List<Dog>> noti = ValueNotifier([]);

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Homepage());
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  getfn() async {
    List<Dog> fetchData = await Api.getDog();

    noti.value = fetchData;
  }

  @override
  initState() {
    super.initState();

    getfn();
  }

  show({dog}) {
    if (dog != null) {
      nameController.text = dog.name;
      ageController.text = dog.age.toString();
    } else {
      nameController.clear();
      ageController.clear();
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(label: Text('name')),
              ),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(label: Text('age')),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (dog == null) {
                      Dog dog = Dog(
                          id: DateTime.now().millisecondsSinceEpoch,
                          name: nameController.text,
                          age: int.parse(ageController.text));
                      addfn(dog);
                      Navigator.pop(context);
                    } else {
                      dog.name = nameController.text;
                      dog.age = int.parse(ageController.text);
                      updatefn(dog);
                      Api.putDog(dog.id,
                          {'name': dog.name, 'age': dog.age, 'id': dog.id});
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('add'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          show();
        },
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
          valueListenable: noti,
          builder: (context, noti, _) {
            return ListView.builder(
                itemCount: noti.length,
                itemBuilder: (context, index) {
                  Dog dog = noti[index];
                  return ListTile(
                    title: Text(dog.name),
                    subtitle: Text(dog.age.toString()),
                    trailing: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              deletefn(dog);
                              Api.deleteDog(dog.id);
                            },
                            icon: const Icon(Icons.delete)),
                        IconButton(
                            onPressed: () {
                              show(dog: dog);
                            },
                            icon: const Icon(Icons.edit))
                      ],
                    ),
                  );
                });
          }),
    );
  }
}
