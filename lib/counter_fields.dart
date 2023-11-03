/* import 'package:flutter/material.dart';
import 'package:foo_counter/counter_fields.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foo Bar counter',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const MyHomePage(title: 'Foo Bar counter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int members = 0;
  int nonMembers = 0;
  int smokers = 0;

  void _increaseMember() {
    setState(() {
      members++;
    });
  }

  void _decreaseMember() {
    if (members > 0) {
      setState(() {
        members--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Antal medlemmar"),
                    Row(
                      children: <Widget>[
                        IconButton(
                            onPressed: _increaseMember, icon: Icon(Icons.add)),
                        Expanded(child: members),
                        IconButton(
                            onPressed: _decreaseMember, icon: Icon(Icons.add)),
                      ],
                    )
                  ]),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ));
  }
}
 */