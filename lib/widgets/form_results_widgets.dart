/*
    @author Marlvin Chihota
    Email marlvinchihota@gmail.com
    Created on 20/11/2022
*/

import 'package:flutter/material.dart';

class ResultWidget extends StatelessWidget {

  final String text;
  final String title;

  const ResultWidget({Key? key, required this.text, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.blue)),
      subtitle: Text(text, style: const TextStyle(color: Colors.blueGrey)),
    );
  }
}
