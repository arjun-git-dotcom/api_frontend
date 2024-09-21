import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:training2/model.dart';

class Api {
  static const baseurl = 'http://192.168.56.243:3000/api/';
  static addDog(Map data) async {
    var url = Uri.parse('${baseurl}add_dog');
    try {
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data));

      if (response.statusCode == 201) {
        // var jsonData = jsonEncode(response.body.toString());
        debugPrint('Posted successfully');
      } else {
        debugPrint('Failed to upload DATA ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<List<Dog>> getDog() async {
    List<Dog> doglist = [];

    var url = Uri.parse('${baseurl}get_person');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        doglist = jsonData['dog'].map((value) {
          return Dog(
              name: value['name'] as String,
              id: value['id'] as int,
              age: value['age'] as int);
        }).toList();
        return doglist;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  static Future<void> deleteDog(int id) async {
    var url = Uri.parse('${baseurl}delete_dog/$id');

    try {
      var response = await http.delete(url);
      if (response.statusCode == 200) {
        debugPrint('successfully deleted ');
      } else {
        debugPrint('failed deletion ${response.statusCode} and $id');
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

  static Future<void> putDog(int id,Map updateddog) async {
    var url = Uri.parse('${baseurl}update_dog/$id');

    try {
      var response = await http.put(url, headers: {"Content-Type": "application/json"},body: jsonEncode(updateddog));
      if (response.statusCode == 200) {
        debugPrint('successfully updated');
      } else {
        debugPrint('updation failed');
      }
    } catch (e) {
      debugPrint('$e');
    }
  }
}
