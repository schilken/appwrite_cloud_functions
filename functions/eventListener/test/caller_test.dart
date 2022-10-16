import 'dart:convert' as convert;

import 'package:appwrite_function/main.dart';
import 'package:test/test.dart';

const appwriteUrl = 'http://192.168.2.23/v1';
const projectId = 'events_explorer';
const apiKey = '';

class Request {
  Map<String, String> headers = {};
  String payload = '';
  Map<String, String> variables = {
    'APPWRITE_FUNCTION_ENDPOINT': appwriteUrl,
    'APPWRITE_FUNCTION_PROJECT_ID': projectId,
    'APPWRITE_FUNCTION_API_KEY': apiKey,
  };
}

class Response {
  String responseAsString = '';
  int statusCode = 0;
  void send(text, {int status = 200}) {
    responseAsString = text;
    statusCode = status;
  }

  void json(obj, {int status = 200}) {
    responseAsString = convert.json.encode(obj);
    statusCode = status;
  }
}

void main() {
  test('call remote function', () async {
    final req = Request();
    final res = Response();
    await start(req, res);
    expect(res.statusCode, 201);
    expect(res.responseAsString, '{"areDevelopersAwesome":true}');
  });
}
