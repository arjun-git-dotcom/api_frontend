import 'package:training2/api.dart';
import 'package:training2/main.dart';
import 'package:training2/model.dart';

addfn(Dog dog) {
  noti.value = [...noti.value, dog];
  Api.addDog({'name': dog.name, "age": dog.age, 'id': dog.id});
}

deletefn(Dog dog) {
  noti.value.remove(dog);
  noti.notifyListeners();
}

updatefn(Dog dog) {
  int index = noti.value.indexWhere((id) => id.id == dog.id);
  noti.value[index] = dog;
  noti.notifyListeners();
}
