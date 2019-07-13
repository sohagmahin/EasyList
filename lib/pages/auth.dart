import 'package:flutter/material.dart';
import './products.dart';

class auth extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _auth();
  }
}

class _auth extends State<auth> {
  String _emailValue;
  String _passwordValue;
  bool _acceptingSwitch = false;
  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      image: AssetImage('assets/background.jpg'),
      fit: BoxFit.cover,
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
    );
  }

  Widget _buildEmailTextField() {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          labelText: 'Email', filled: true, fillColor: Colors.white),
      onChanged: (String value) {
        setState(() {
          _emailValue = value;
        });
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextField(
      decoration: InputDecoration(
          labelText: 'Password', filled: true, fillColor: Colors.white),
      obscureText: true,
      onChanged: (String value) {
        setState(() {
          _passwordValue = value;
        });
      },
    );
  }

  Widget _buildAcceptSwitch() {
    return SwitchListTile(
      value: _acceptingSwitch,
      onChanged: (bool value) {
        setState(() {
          _acceptingSwitch = value;
        });
      },
      title: Text('Accept terms'),
    );
  }

  @override
  Widget build(BuildContext context) {
    //take pixels of width of our screen
    final double deviceWidth = MediaQuery.of(context).size.width;
    /*(deviceWidth * 0.95 ) means set Container width 95% of our screen . device width compare 768.
    because 768 is break point of mobile screen. In range of high mainly use for table device*/
    final double targetWidth= deviceWidth > 768.0 ? 500 : deviceWidth * 0.95;
    return Scaffold(
        appBar: AppBar(title: Text('LOGIN PANNEL')),
        body: Container(
            decoration: BoxDecoration(image: _buildBackgroundImage()),
            padding: EdgeInsets.all(10.0),
            child: Center(
                child: SingleChildScrollView(
              child: Container(
                width: targetWidth,
                child: Column(
                  children: <Widget>[
                    _buildEmailTextField(),
                    SizedBox(height: 10.0),
                    _buildPasswordTextField(),
                    _buildAcceptSwitch(),
                    SizedBox(height: 10),
                    RaisedButton(
                      child: Text('Login'),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () => {
                        print(_emailValue),
                        print(_passwordValue),
                        Navigator.pushReplacementNamed(context, '/products'),
                      },
                    ),
                  ],
                ),
              ),
            ))));
  }
}
