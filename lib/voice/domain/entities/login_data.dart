import 'package:voice_note/voice/domain/entities/data_entities.dart';
import 'package:voice_note/voice/domain/use_cases/constant_data.dart';



class LoginData {

 late String password;
 late String email;
 late List<DataEntities> voices;
  late LoginType type ;

  LoginData({this.password ="", required this.email,this.voices = const [],this.type = LoginType.normal});

  LoginData.fromJson(Map<String, dynamic> data) {
    password = data['password'];
    email = data['email'];
    type = data['type'] == "normal"?LoginType.normal:LoginType.social;
  }

  toJson() {
    Map<String, dynamic> data = Map();
    data['password'] = password;
    data['email'] = email;
    data['type'] = type == LoginType.normal ?"normal":"social";
    return data;
  }
}

