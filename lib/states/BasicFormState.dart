import 'dart:convert';
import 'package:dnstask/constructor/BasicForm.dart';
import 'package:dnstask/constructor/SecondRoute.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BasicFormState extends State<BasicForm> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: TextFormField(
              controller: firstNameController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Пожалуйста введите имя';
                }
                return null;
              },
              decoration: InputDecoration(hintText: 'Имя'),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: TextFormField(
              controller: lastNameController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Пожалуйста введите фамилию';
                }
                return null;
              },
              decoration: InputDecoration(hintText: 'Фамилия'),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: TextFormField(
              controller: emailController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Пожалуйста введите e-mail';
                }
                return null;
              },
              decoration: InputDecoration(hintText: 'e-mail'),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: TextFormField(
              controller: phoneController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Пожалуйста введите телефон';
                }
                return null;
              },
              decoration: InputDecoration(hintText: 'Телефон'),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    final firstName = firstNameController.text.trim();
                    final lastName = lastNameController.text.trim();
                    final phone = phoneController.text.trim();
                    final email = emailController.text.trim();

                    http
                        .post(
                      'https://vacancy.dns-shop.ru/api/candidate/token',
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: jsonEncode(<String, dynamic>{
                        'firstName': firstName,
                        'lastName': lastName,
                        'phone': phone,
                        'email': email
                      }),
                    )
                        .then((response) {
                      print(json.decode(response.body)['data']);

                      Navigator.pushNamed(
                        context,
                        SecondRoute.routeName,
                        arguments: ScreenArguments(firstName, lastName, phone,
                            email, json.decode(response.body)['data']),
                      );
                    }).catchError((error) {
                      print("Error: $error");
                    });
                  }
                },
                color: Color.fromRGBO(237, 142, 0, 1),
                child: Text(
                  'ПОЛУЧИТЬ КЛЮЧ',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScreenArguments {
  final firstName;
  final lastName;
  final phone;
  final email;
  final data;

  ScreenArguments(
      this.firstName, this.lastName, this.phone, this.email, this.data);
}
