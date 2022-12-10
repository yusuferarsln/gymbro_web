import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymbro_web/enums/accoun_type.dart';
import 'package:gymbro_web/model/basic_user_model.dart';
import 'package:gymbro_web/model/image_model.dart';
import 'package:gymbro_web/model/m_user_model.dart';
import 'package:gymbro_web/model/registered_gym_model.dart';
import 'package:gymbro_web/model/request_model.dart';
import 'package:gymbro_web/model/s_user_model.dart';
import 'package:gymbro_web/model/workout_model.dart';
import 'package:http/http.dart';

import '../hasura/hasura.dart';
import '../model/move_model.dart';

ApiService get api => ApiService.instance;

class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();

  final Uri url = Uri.parse('http://141.147.30.156:5050/');

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
    gym_tool_count
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

  Future<bool> addGym(String gymAdress, String gymImage, int gymMemberCount,
      String gymName, int gymToolCount) async {
    print('sss');
    final query = Hasura.insert(
      table: 'gym_records',
      object: {
        'gym_address': gymAdress,
        'gym_image': gymImage,
        'gym_member_count': gymMemberCount,
        'gym_name': gymName,
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

  Future<Map<String, dynamic>?> get currentUserClaims async {
    final user = FirebaseAuth.instance.currentUser;

    // If refresh is set to true, a refresh of the id token is forced.
    final idTokenResult = await user?.getIdTokenResult(true);

    return idTokenResult!.claims;
  }

  Future<List<BasicUserModel>> getUserDetail() async {
    var result = await api.currentUserClaims;
    var uuid = result!['sub'];

    final queryx = Hasura.queryList(table: 'users', returning: {
      'id',
      'user_email'
    }, where: {
      'uuid': {'_eq': uuid}
    });
    final response = await post(
      Uri.parse('${url}dbRelay'),
      body: jsonEncode(queryx.body),
    );

    print(response.body);
    final data = jsonDecode(response.body)['data']['users'];

    return List.from(data).map((e) => BasicUserModel.fromJson(e)).toList();
  }

  Future<int> getUserID() async {
    var result = await api.currentUserClaims;
    var uuid = result!['sub'];

    final queryx = Hasura.queryList(table: 'users', returning: {
      'id',
    }, where: {
      'uuid': {'_eq': uuid}
    });
    final response = await post(
      Uri.parse('${url}dbRelay'),
      body: jsonEncode(queryx.body),
    );

    print(response.body);
    final data = jsonDecode(response.body)['data']['users'][0]['id'];

    return data;
  }

  Future<int> getGymID(int userID) async {
    final queryx = Hasura.queryList(table: 'gym_admins', returning: {
      'gym_id',
    }, where: {
      'admin_id': {'_eq': userID}
    });
    final response = await post(
      Uri.parse('${url}dbRelay'),
      body: jsonEncode(queryx.body),
    );

    print(response.body);
    final data = jsonDecode(response.body)['data']['gym_admins'][0]['gym_id'];

    return data;
  }

  Future<List<RequestModel>> getRequests(int gymID) async {
    var query = ''' 
  query MyQuery {
  user_gyms(where: {gym_id: {_eq: $gymID}, _and: {status: {_eq: 0}}}) {
    is_active
    status
    user {
      user_email
      user_name
      id
    }
  }
}

''';
    final response = await post(
      Uri.parse('${url}dbRelay'),
      body: jsonEncode({'query': query}),
    );

    print(response.body);
    final data = jsonDecode(response.body)['data']['user_gyms'];

    print(data);

    return List.from(data).map((e) => RequestModel.fromJson(e)).toList();
  }

  Future<int> handleRequest(int userID, int status) async {
    var query = ''' 
  
mutation MyMutation {
  update_user_gyms(where: {user_id: {_eq: $userID}}, _set: {status: $status}) {
    returning {
      status
    }
  }
}

''';
    final response = await post(
      Uri.parse('${url}dbRelay'),
      body: jsonEncode({'query': query}),
    );

    print(response.body);
    final data = jsonDecode(response.body)['data']['user_gyms'];

    print(data);
    if (status == 1) {
      return 1;
    } else {
      return 2;
    }
  }

  Future<List<MUsermodel>> getGymUsers(int gymID) async {
    print('starting');
    var query = ''' 
  query MyQuery {
  user_gyms(where: {gym_id: {_eq: "$gymID"}, _and: {status: {_eq: 1}}}) {
    user {
      id
      user_email
      user_name
    }
  }
}


''';

    final response = await post(
      Uri.parse('${url}dbRelay'),
      body: jsonEncode({'query': query}),
    );

    final data = jsonDecode(response.body)['data']['user_gyms'];

    return List.from(data).map((e) => MUsermodel.fromJson(e)).toList();
  }

  Future<List<MoveModel>> getMoves(String moveArea) async {
    final query = Hasura.queryList(table: 'gym_moves', returning: {
      'id',
      'move_name',
      'move_area',
    }, where: {
      'move_area': {'_eq': moveArea}
    });

    final response = await post(
      Uri.parse('${url}dbRelay'),
      body: jsonEncode(query.body),
    );

    final data = jsonDecode(response.body)['data']['gym_moves'];
    print(data);
    print(query.body);

    return List.from(data).map((e) => MoveModel.fromJson(e)).toList();
  }

  Future addWorkout(List<Map> workouts, int userID, int gymID) async {
    final query = Hasura.insert(
      table: 'user_workouts_relation',
      object: {'chest': '\$education', 'user_id': userID, 'gym_id': gymID},
      returning: {'id'},
      variables: {'education': workouts},
    );

    final response = await post(
      Uri.parse('${url}dbRelay'),
      body: jsonEncode(query.body),
    );

    print(response.body);
    print(query.body);
  }

  Future<List<WorkoutModel>> getWorkouts(int gymID, int userID) async {
    print('starting');
    var query = ''' 
  query MyQuery {
  user_gyms(where: {_and: {gym_id: {_eq: "$gymID"}}, user_id: {_eq: "$userID"}}) {
    user_workouts_relations {
      chest
      id
    }
  }
}



''';

    final response = await post(
      Uri.parse('${url}dbRelay'),
      body: jsonEncode({'query': query}),
    );

    final data = jsonDecode(response.body)['data']['user_gyms'][0]
        ['user_workouts_relations'];
    print(data);

    return List.from(data).map((e) => WorkoutModel.fromJson(e)).toList();
  }

  Future<List<ImageModel>> getMoveImg(int moveID) async {
    print('starting');
    var query = ''' 
  query MyQuery {
  gym_moves(where: {id: {_eq: "$moveID"}}) {
    move_img
  }
}
''';

    final response = await post(
      Uri.parse('${url}dbRelay'),
      body: jsonEncode({'query': query}),
    );

    final data = jsonDecode(response.body)['data']['gym_moves'];
    print(data);

    return List.from(data).map((e) => ImageModel.fromJson(e)).toList();
  }
}
