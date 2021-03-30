import 'dart:convert';

import 'package:http/http.dart' as http;

void runCommand(String command, {String url = 'localhost:9090'}) {
  http.post(Uri.http(url, '/api'), body: json.encode({'command': command}));
}
