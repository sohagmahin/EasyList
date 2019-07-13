import 'package:flutter/material.dart';

class price_tag extends StatelessWidget {
  final String price;
  price_tag(this.price);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
      decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        '\$$price',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
