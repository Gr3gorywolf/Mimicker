import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mimicker/models/scripts_response.dart';
import '../constants/api_path.dart' as Constants;
class ScriptsRepository{
  Future<ScriptResponse> getScripts() async{
      var response = await http.get(Constants.SCRIPTS_URL);
      return ScriptResponse.fromJson(jsonDecode(response.body));
  }

}