import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-model/main.dart';

enum AuthMode { SignUp, Login }

class Auth extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Auth();
  }
}

class _Auth extends State<Auth> {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'acceptSwitch': false
  };
  // String _emailValue;
  // String _passwordValue;
  // bool _acceptingSwitch = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _passwordEditingController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      image: AssetImage('assets/background.jpg'),
      fit: BoxFit.cover,
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
    );
  }

  String validatorEmail(String value) {
    return value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)
        ? 'Please enter a valid email!'
        : null;
  }

  String validatorPassword(String value) {
    return value.isEmpty || value.length < 5
        ? 'Password should not be empty & required more than 5!'
        : null;
  }

  String validatorConfirmPassword(String value) {
    return _passwordEditingController.text != value ? 'Do not match!' : null;
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          labelText: 'Email', filled: true, fillColor: Colors.white),
      validator: validatorEmail,
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Password', filled: true, fillColor: Colors.white),
      obscureText: true,
      controller: _passwordEditingController,
      validator: validatorPassword,
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildConfirmPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Confirm Password', filled: true, fillColor: Colors.white),
      obscureText: true,
      validator: validatorConfirmPassword,
    );
  }

  Widget _buildAcceptSwitch() {
    return SwitchListTile(
      value: _formData['acceptSwitch'],
      onChanged: (bool value) {
        setState(() {
          _formData['acceptSwitch'] = value;
        });
      },
      title: Text('Accept terms'),
    );
  }

  void _submitForm(Function login, Function signup) async {
    if (!_formKey.currentState.validate() || !_formData['acceptSwitch']) {
      return;
    }
    _formKey.currentState.save();
    if (_authMode == AuthMode.Login) {
      login(_formData['email'], _formData['password']);
      Navigator.pushReplacementNamed(context, '/products');
    } else {
      Map<String, dynamic> successInformation =
          await signup(_formData['email'], _formData['password']);
      if (successInformation['success']) {
        Navigator.pushReplacementNamed(context, '/products');
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('An Error occurred'),
                content: Text('Email has already exists!'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Okay'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //take pixels of width of our screen
    final double deviceWidth = MediaQuery.of(context).size.width;
    /*(deviceWidth * 0.95 ) means set Container width 95% of our screen . device width compare 768.
    because 768 is break point of mobile screen. In range of high mainly use for table device*/
    final double targetWidth = deviceWidth > 768.0 ? 500 : deviceWidth * 0.95;
    return Scaffold(
        appBar: AppBar(title: Text('LOGIN PANNEL')),
        body: GestureDetector(
            onTap: () {
              //for disable keybord
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
                decoration: BoxDecoration(image: _buildBackgroundImage()),
                padding: EdgeInsets.all(10.0),
                child: Center(
                    child: SingleChildScrollView(
                  child: Container(
                    width: targetWidth,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          _buildEmailTextField(),
                          SizedBox(height: 10.0),
                          _buildPasswordTextField(),
                          SizedBox(height: 10.0),
                          _authMode == AuthMode.SignUp
                              ? _buildConfirmPasswordTextField()
                              : Container(),
                          _buildAcceptSwitch(),
                          SizedBox(
                            height: 10,
                          ),
                          FlatButton(
                            child: Text(
                                "Switch to ${AuthMode.Login == _authMode ? 'SignUp' : 'Login'}"),
                            onPressed: () {
                              setState(() {
                                _authMode = _authMode == AuthMode.SignUp
                                    ? AuthMode.Login
                                    : AuthMode.SignUp;
                              });
                            },
                          ),
                          SizedBox(height: 10),
                          ScopedModelDescendant<MainModel>(
                            builder: (BuildContext context, Widget child,
                                MainModel model) {
                              return RaisedButton(
                                child: Text('Login'),
                                color: Theme.of(context).primaryColor,
                                textColor: Colors.white,
                                onPressed: () =>
                                    _submitForm(model.login, model.signup),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )))));
  }
}
