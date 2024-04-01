import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_api_app/service/weather_service.dart';
import 'package:weather_api_app/view/home_page.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => WeatherService(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
