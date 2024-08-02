import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_service.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<HomeScreen>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              // await authService.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome!'),
      ),
    );
  }
}
