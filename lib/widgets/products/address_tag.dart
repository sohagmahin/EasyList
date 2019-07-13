import 'package:flutter/material.dart';

class address_tag extends StatelessWidget {
  final String address;
  address_tag(this.address);
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(5.0)),
      child: Text(address),
    );
  }
}
