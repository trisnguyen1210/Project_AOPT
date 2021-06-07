import 'package:beans/model/user.dart';
import 'package:beans/provider/auth_provider.dart';
import 'package:flutter/material.dart';

class RegistrationProvider with ChangeNotifier {
  String _name = '';

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  String get name => _name;

  String _email = '';

  set email(String value) {
    _email = value;
    notifyListeners();
  }

  String get email => _email;

  String _pin = '';

  set pin(String value) {
    _pin = value;
    notifyListeners();
  }

  String get pin => _pin;

  String _retypePin = '';

  set retypePin(String value) {
    _retypePin = value;
    notifyListeners();
  }

  String get retypePin => _retypePin;

  String _bod = '';

  set bod(String value) {
    _bod = value;
    notifyListeners();
  }

  String get bod => _bod;

  bool _acceptTerm = false;

  set acceptTerm(bool value) {
    _acceptTerm = value;
    notifyListeners();
  }

  bool get acceptTerm => _acceptTerm;

  bool get isValid {
    return email.isNotEmpty &&
        name.isNotEmpty &&
        bod.isNotEmpty != null &&
        pin.isNotEmpty &&
        pin == retypePin &&
        acceptTerm;
  }

  final AuthProvider _authProvider;

  RegistrationProvider(this._authProvider);

  register() async {
    final user = User(
        name: name, pin: pin, bod: bod, email: email);

    await _authProvider.register(user);
  }
}
