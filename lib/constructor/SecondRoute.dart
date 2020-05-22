import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dnstask/states/BasicFormState.dart';

class SecondRoute extends StatelessWidget {
  static const routeName = '/secondRoute';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Отправка данных"),
        backgroundColor: Color.fromRGBO(237, 142, 0, 1),
      ),
      body: SecondRouteForm(),
    );
  }
}

class SecondRouteForm extends StatefulWidget {
  @override
  SecondRouteFormState createState() {
    return SecondRouteFormState();
  }
}

class SecondRouteFormState extends State<SecondRouteForm> {
  final _formKey = GlobalKey<FormState>();
  final gitLink = new TextEditingController();
  final summaryLink = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: TextFormField(
              controller: gitLink,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Пожалуйста введите ссылку на профиль GitHub';
                }

                Pattern pattern = '(http(s)?)(:(\/\/)?)(github\.com\/.+)';
                RegExp regex = new RegExp(pattern);

                if (!regex.hasMatch(value)) {
                  return 'Введите корректную ссылку';
                }

                return null;
              },
              decoration: InputDecoration(hintText: 'ссылка на github'),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: TextFormField(
              controller: summaryLink,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Пожалуйста введите ссылку на резюме';
                }
                return null;
              },
              decoration: InputDecoration(hintText: 'ссылка на резюме'),
            ),
          ),
          RaisedButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                http
                    .post(
                  'https://vacancy.dns-shop.ru/api/candidate/test/summary',
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                    'authorization': 'Bearer ' + args.data,
                  },
                  body: jsonEncode(<String, dynamic>{
                    'firstName': args.firstName,
                    'lastName': args.lastName,
                    'phone': args.phone,
                    'email': args.email,
                    'githubProfileUrl': gitLink.text.trim(),
                    'summary': summaryLink.text.trim(),
                  }),
                )
                    .then((response) {
                  var parsedJson = json.decode(response.body);
                  var code = parsedJson['code'];
                  var message = parsedJson['message'];
                  var data = parsedJson['data'];
                  print('$code, $message, $data');
                }).catchError((error) {
                  print("Error: $error");
                });
              }
            },
            color: Color.fromRGBO(237, 142, 0, 1),
            child: Text(
              'ЗАРЕГИСТРИРОВАТЬСЯ',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
