import 'package:flutter/material.dart';
import 'package:flutter_assignment/screens/home_page.dart';
import 'package:flutter_assignment/widgets/local_auth_api.dart';

class BiometricScreen extends StatefulWidget {
  const BiometricScreen({Key? key}) : super(key: key);

  @override
  State<BiometricScreen> createState() => _BiometricScreenState();
}

class _BiometricScreenState extends State<BiometricScreen> {
  @override
  void initState() {
    callBiometric();
    super.initState();
  }

  Future<void> callBiometric() async {
    final isAuthenticated = await LocalAuthApi.authenticate();

    if (isAuthenticated) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
