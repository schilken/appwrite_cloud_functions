import 'dart:convert' as convert;

import 'package:appwrite_function/main.dart';
import 'package:test/test.dart';

const appwriteUrl = 'http://192.168.2.23/v1';
const projectId = 'events_explorer';
const apiKey =
    'dea41bbe35fe813f1e67e3ec9dd8b23bb46e7d93f85276046ea4739b3bbde6f7f109e580bf3129afd4e2576bf0cd1d44d2a82ca2e37fb7cb5bafa5e1b2f976ae4eb043d54c7e02cfad6a50734662f215b1560e61754650161c93e92039cdc92a01cf29d1332b37bb4c944e4af56e6c913c2abfcbd561acafa6fea32298588fda';

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
  test('call remote function with users.create event', () async {
    final req = Request();
    req.variables['APPWRITE_FUNCTION_EVENT'] =
        'users.634d2b1eeb3cc427de27.create';
    req.variables['APPWRITE_FUNCTION_EVENT_DATA'] = convert.json.encode({
      'name': 'user1',
      'email': 'user1@example.com',
    });
    final res = Response();
    await start(req, res);
    expect(res.statusCode, 200);
    expect(res.responseAsString, '{"success":true,"message":"OK"}');
  });
}
