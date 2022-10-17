import 'package:dart_appwrite/dart_appwrite.dart';
import 'dart:convert' as convert;

/*
  'req' variable has:
    'headers' - object with request headers
    'payload' - request body data as a string
    'variables' - object with function variables

  'res' variable has:
    'send(text, status: status)' - function to return text response. Status code defaults to 200
    'json(obj, status: status)' - function to return JSON response. Status code defaults to 200
  
  If an error is thrown, a response with code 500 will be returned.
*/

 
Client? mockClient;
Databases? mockDatabases;

Future<void> start(final req, final res) async {
//  print('req: ${req.variables}');

  Client client = mockClient ?? Client();

  Databases database = mockDatabases ?? Databases(client);

  bool resultCode = true;
  String message = 'OK';

  if (req.variables['APPWRITE_FUNCTION_ENDPOINT'] == null ||
      req.variables['APPWRITE_FUNCTION_API_KEY'] == null) {
    print(
        "Environment variables are not set. Function cannot use Appwrite SDK.");
  } else {
    client
        .setEndpoint(req.variables['APPWRITE_FUNCTION_ENDPOINT'])
        .setProject(req.variables['APPWRITE_FUNCTION_PROJECT_ID'])
        .setKey(req.variables['APPWRITE_FUNCTION_API_KEY'])
        .setSelfSigned(status: true);
    final data = {
      'type': req.variables['APPWRITE_FUNCTION_EVENT'],
      'timestamp': DateTime.now().toIso8601String(),
      'data':
          convert.json.encode(req.variables['APPWRITE_FUNCTION_EVENT_DATA']),
    };
    try {
      final document = await database.createDocument(
          databaseId: '634aefe8638b2f1f5404',
          collectionId: 'event_log',
          documentId: 'unique()',
          data: data);
      message = 'document created with id:${document.$id}';
    } on Exception catch (e) {
      resultCode = false;
      message = e.toString();
      print(e.toString());
    }
  }

  res.json({
    'success': resultCode,
    'message': message,
  });
}
