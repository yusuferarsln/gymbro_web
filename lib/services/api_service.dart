import 'dart:convert';

import 'package:http/http.dart';

import '../hasura/hasura.dart';

ApiService get api => ApiService.instance;

class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();

  final Uri url = Uri.parse('http://localhost:8080/');

  Future<bool> checkAdmin(String email) async {
    final query = Hasura.queryList(table: 'users', returning: {
      'id',
      'is_gymbro_admin',
    }, where: {
      'user_email': {'_eq': email}
    });

    final response = await post(
      Uri.parse('${url}dbRelay'),
      body: jsonEncode(query.body),
    );

    final data = jsonDecode(response.body);
    List users = data['data']['users'];
    if (users.isNotEmpty) {
      var isAdmin = users[0]['is_gymbro_admin'];
      if (isAdmin == true) {
        return true;
      }
      return false;
    } else {
      return false;
    }
    print(users);
  }
}
