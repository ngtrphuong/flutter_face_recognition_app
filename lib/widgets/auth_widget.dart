import 'package:face_app/models/app_exception.dart';
import 'package:face_app/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWidget extends StatefulWidget {
  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  String _email;
  String _password;

  var _isLoading = false;
  var _isObscure = true;
  TextStyle field = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 22,
    letterSpacing: 1.0,
  );

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Email Id',
        labelStyle: field,
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is Required';
        }

        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email Address';
        }

        return null;
      },
      onSaved: (String value) {
        _email = value;
      },
    );
  }

  Widget _buildPassword() {
    return Stack(
      children: <Widget>[
        Container(
          height: 60,
          alignment: Alignment.center,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: field,
            ),
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            obscureText: _isObscure,
            validator: (String value) {
              if (value.isEmpty) {
                return 'Password is Required';
              }
              return null;
            },
            onSaved: (String value) {
              _password = value;
            },
          ),
        ),
        Positioned(
            right: 0,
            child: Container(
              height: 60,
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(
                  !_isObscure ? Icons.visibility : Icons.visibility_off,
                  size: 20,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              ),
            ))
      ],
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).authenticate(
        _email,
        _password,
      );
      Navigator.of(context).pushReplacementNamed('/home');
    } on AppException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog(error.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      // margin: EdgeInsets.all(24),
      padding: EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Login to get your attendance and profile details.',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                  color: Theme.of(context).primaryColor,
                  letterSpacing: 1.0,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              _buildEmail(),
              _buildPassword(),
              SizedBox(height: 30),
              ButtonTheme(
                minWidth: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.08,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    // side: BorderSide(color: Colors.purple),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  color: Theme.of(context).primaryColor,
                  child: _isLoading
                      ? CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        )
                      : Text(
                          'Login Now',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                  onPressed: _submit,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
