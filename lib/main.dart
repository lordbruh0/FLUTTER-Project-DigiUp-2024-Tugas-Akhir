import 'package:data_sponsor/input_usaha_page.dart';
import 'package:data_sponsor/list_usaha_page.dart';
import 'package:data_sponsor/usaha_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:data_sponsor/input_usaha_page.dart';
import 'package:data_sponsor/list_usaha_page.dart';
import 'package:data_sponsor/usaha_model.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UsahaAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lapor App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Key reportListKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Data Usaha',
          style: TextStyle(
              color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ListUsahaPage(
          key: reportListKey,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () async {
          // Wait for InputTodoPage to complete
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InputUsahaPage()),
          );

          // Check if a new todo was added or an existing one was edited
          if (result == true) {
            setState(() {
              reportListKey = UniqueKey(); // Update key to refresh TodoListPage
            });
          }
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ), //Change Icon
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .endFloat, //Change for different locations
    );
  }
}
