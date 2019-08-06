import 'package:flutter/material.dart';

class TitleDefault extends StatelessWidget {
  final String _title;
  TitleDefault(this._title);
  @override
  Widget build(BuildContext context) {
    return Text(
      _title,
      style: TextStyle(
          fontFamily: 'Oswald', fontSize: 25.5, fontWeight: FontWeight.bold),
    );
  }
}
