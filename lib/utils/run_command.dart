
import 'dart:convert';

import 'package:http/http.dart' as http;

runCommand(String command,{String url = "localhost:9090"}){
  http.Client().post("http://" + url + "/api",body:json.encode({"command":command}));
}