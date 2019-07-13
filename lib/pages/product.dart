import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import '../widgets/ui_elements/title_Default.dart';

//single product page
class productPages extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String description;
  final double priceTag;
  productPages(this.title, this.imageUrl, this.description, this.priceTag);

  _buildAddressPiceRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Union Square, San Francisco',
          style: TextStyle(color: Colors.grey, fontFamily: 'Oswald'),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            '|',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Text(
          '\$' + priceTag.toString(),
          style: TextStyle(color: Colors.grey, fontFamily: 'Oswald'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          print("Back button pressed!");
          Navigator.pop(context, false);
          return Future.value(false);
        },
        child: Scaffold(
            appBar: new AppBar(
              title: Text(title),
            ),
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(imageUrl),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: title_Default(title),
                  ),
                  _buildAddressPiceRow(context),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            )));
  }
}
