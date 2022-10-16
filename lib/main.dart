import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  final String _projectId = 'events_explorer';
  final String _backendUrl = "https://192.168.2.23";
// const String _email = 'user@appwrite.io';
// const String _password = 'password';
// const _databaseId = 'db1';
// const _collectionId = 'c1';
//const _bucketId = 'testbucket';
  final Client _client = Client();
  late Functions _functions;
  final _functionId = 'eventListener';

  @override
  void initState() {
    super.initState();
    _client
            .setEndpoint(
                '$_backendUrl/v1') // Make sure your endpoint is accessible from your emulator, use IP if needed
            .setProject(_projectId) // Your project ID
            .setSelfSigned() // Do not use this in production
        ;
    _functions = Functions(_client);
  }

  Future<void> _callRemoteFunction() async {
    try {
      final execution = await _functions.createExecution(
          functionId: _functionId, data: "arg1:string-argument");
      print('execution.status: ${execution.status}');
      print('execution.response: ${execution.response}');
    } on AppwriteException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 10.0),
            ElevatedButton(
                child: Text(
                  "Call Cloud Function",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.all(16),
                  minimumSize: Size(280, 50),
                ),
                onPressed: () {
                  _callRemoteFunction();
                }),
          ],
        ),
      ),
    );
  }
}
