import 'package:flutter/material.dart';

class title_Default extends StatelessWidget {
  final String _title;
  title_Default(this._title);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(
      _title,
      style: TextStyle(
          fontFamily: 'Oswald', fontSize: 25.5, fontWeight: FontWeight.bold),
    );
  }
}
