import 'dart:convert';

import 'package:gymbro_web/enums/accoun_type.dart';
import 'package:gymbro_web/model/registered_gym_model.dart';
import 'package:gymbro_web/model/s_user_model.dart';
import 'package:http/http.dart';

import '../hasura/hasura.dart';

ApiService get api => ApiService.instance;

class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();

  final Uri url = Uri.parse('http://localhost:8080/');

  Future<AccountType> checkAdmin(String email) async {
    final query = Hasura.queryList(table: 'users', returning: {
      'id',
      'is_gymbro_admin',
      'is_gym_owner'
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
      var isGymOwner = users[0]['is_gym_owner'];

      if (isAdmin == true) {
        return AccountType.broAdmin;
      }
      if (isGymOwner == true) {
        return AccountType.gymAdmin;
      }
      return AccountType.nonUser;
    } else {
      return AccountType.nonUser;
    }
    print(users);
  }

  Future<List<RecordedGymsModel>> getGyms() async {
    print('sss');
    const query = ''' 
    query MyQuery {
  gym_records {
    gym_address
    gym_image
    gym_member_count
    gym_name
    gym_password
    gym_tool_count
    gym_user
    id
    users {
      user {
        is_gymbro_admin
        user_name
        user_email
        id
      }
    }
  }
}
''';

    final response = await post(
      Uri.parse('${url}dbRelay'),
      body: jsonEncode({'query': query}),
    );

    final data = jsonDecode(response.body)['data']['gym_records'];

    print(data);
    return List.from(data).map((e) => RecordedGymsModel.fromJson(e)).toList();
  }

  Future<bool> addGym(
      String gymAdress,
      String gymImage,
      int gymMemberCount,
      String gymName,
      String gymUser,
      String gymPassword,
      int gymToolCount) async {
    print('sss');
    final query = Hasura.insert(
      table: 'gym_records',
      object: {
        'gym_address': gymAdress,
        'gym_image': gymImage,
        'gym_member_count': gymMemberCount,
        'gym_name': gymName,
        'gym_user': gymUser,
        'gym_password': gymPassword,
        'gym_tool_count': gymToolCount
      },
      returning: {'id'},
    );

    final response = await post(
      Uri.parse('${url}dbRelay'),
      body: jsonEncode(query.body),
    );

    final data = jsonDecode(response.body);

    print(data);
    return true;
  }

  Future<bool> deleteGym(int gymID) async {
    final query =
        Hasura.deleteById(table: 'gym_records', id: gymID, returning: {'id'});

    final response = await post(
      Uri.parse('${url}dbRelay'),
      body: jsonEncode(query.body),
    );

    final data = jsonDecode(response.body);

    print(data);
    return true;
  }

  Future<List<SUserModel>> getSpecificUser(String email) async {
    print('sss');
    final query = Hasura.queryList(table: 'users', returning: {
      'id',
      'user_name',
      'user_email'
    }, where: {
      'user_email': {'_eq': email}
    });

    final response = await post(
      Uri.parse('${url}dbRelay'),
      body: jsonEncode(query.body),
    );

    final data = jsonDecode(response.body)['data']['users'];

    print(data);
    return List.from(data).map((e) => SUserModel.fromJson(e)).toList();
  }

  Future<bool> setAdmin(int ID) async {
    print('sss');
    var query = ''' 
    

mutation MyMutation {
  update_users(where: {id: {_eq: $ID}}, _set: {is_gym_owner: true}) {
    returning {
      id
    }
  }
}

''';

    final response = await post(
      Uri.parse('${url}dbRelay'),
      body: jsonEncode({'query': query}),
    );

    final data = jsonDecode(response.body)['data']['update_users'];

    print(data);

    if (data != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> registerAdmin(int userID, int gymID) async {
    print('sss');
    var query = ''' 
    mutation MyMutation {
  insert_gym_admins(objects: {admin_id: $userID, gym_id: $gymID}) {
    returning {
      admin_id
      gym_id
    }
  }
}


''';

    final response = await post(
      Uri.parse('${url}dbRelay'),
      body: jsonEncode({'query': query}),
    );

    final data = jsonDecode(response.body)['data']['update_gym_records'];

    print(data);

    if (data != null) {
      return true;
    } else {
      return false;
    }
  }
}
