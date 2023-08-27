import 'package:flutter/material.dart';
import 'package:sat_tracker/presentation/screens/downloadScreen.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {

  const MyApp({Key? key,}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Satellite Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DownloadScreen()
      );
  }
}