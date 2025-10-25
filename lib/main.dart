import 'package:flutter/material.dart';
import 'package:memorycloud/screens/login_screen.dart';
import 'package:memorycloud/screens/gallery.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Web App',
      debugShowCheckedModeBanner: false,

      // Initial route
      initialRoute: '/',

      // Routes map
      routes: {
        '/': (context) => LoginScreen(),
      },

      // Optional: unknown route fallback
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) =>
              Scaffold(body: Center(child: Text('Page not found!'))),
        );
      },
    );
  }
}
