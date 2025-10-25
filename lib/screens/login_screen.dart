import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> login() async {
    var url = Uri.parse("https://yourdomain.com/api/login.php");
    var res = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email.text,
          "password": password.text,
        }));
    var data = jsonDecode(res.body);
      Navigator.pushReplacementNamed(context, "/",
          arguments: data["user"]);
    if (data["status"] == "success") {
      Navigator.pushReplacementNamed(context, "/dashboard",
          arguments: data["user"]);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid login credentials")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: email, decoration: InputDecoration(labelText: "Email")),
          TextField(controller: password, obscureText: true, decoration: InputDecoration(labelText: "Password")),
          ElevatedButton(onPressed: login, child: Text("Login"))
        ]),
      ),
    );
  }
}
