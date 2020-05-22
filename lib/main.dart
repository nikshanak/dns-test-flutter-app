import 'package:flutter/material.dart';
import 'constructor/BasicForm.dart';
import 'package:dnstask/constructor/SecondRoute.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Ввод данных';

    return MaterialApp(
        title: appTitle,
        home: Scaffold(
          appBar: AppBar(
            title: Text(appTitle),
            backgroundColor: Color.fromRGBO(237, 142, 0, 1),
          ),
          body: BasicForm(),
        ),
        routes: {
          SecondRoute.routeName: (context) => SecondRoute(),
        });
  }
}
