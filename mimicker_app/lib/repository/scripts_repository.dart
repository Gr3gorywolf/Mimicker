import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mimicker_core/constants/api_path.dart' as Constants;
import 'package:mimicker_core/models/scripts_response.dart';
class ScriptsRepository{
  Future<ScriptResponse> getScripts() async{
      var response = await http.get(Constants.SCRIPTS_URL);
      return ScriptResponse.fromJson(jsonDecode(response.body));
  }

}