import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/api_service.dart';
import 'screens/search_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ApiService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Movie App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        
        ),
        home: SearchScreen(),
      ),
    );
  }
}
