import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> authenticate() async {
    try {
      final available = await _auth.canCheckBiometrics;
      return await _auth.authenticate(
          localizedReason: "Scan FingerPrint to Authenticate",
          options: const AuthenticationOptions(
              biometricOnly: true, useErrorDialogs: true, stickyAuth: true));
    } on PlatformException catch (err) {
      return false;
    }
  }
}
