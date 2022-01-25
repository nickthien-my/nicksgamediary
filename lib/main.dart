import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nick\'s Game Journal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Nick\'s Game Journal')),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent Games'),
            Text('2022'),
            Card(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text('Earned "Legendary" trophy.'),
                    Image.asset(
                        'assets/screenshots/Rayman Legends_20220123160500.png'),
                    Text('Win all trophies in the game!'),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
