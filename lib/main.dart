import 'package:flutter/material.dart';

void main() {
  runApp(const FooBarCounter());
}

class FooBarCounter extends StatelessWidget {
  const FooBarCounter({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foo Bar Counter',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const FooPage(title: 'Foo Bar Counter'),
    );
  }
}

class FooPage extends StatefulWidget {
  const FooPage({super.key, required this.title});

  final String title;
  final int fooCapacity = 149;

  @override
  State<FooPage> createState() => _FooPageState();
}

class _FooPageState extends State<FooPage> {
  // Fields[0]: Members
  // Fields[1]: NonMembers
  // Fields[2]: Smokers
  List<int> fields = [0, 0, 0];
  bool _almostCapacity = false;
  final int _capacityWarning = 135; // Number of ppl in Foo resulting in warning
  final int _fullCapacity = 149;

  int _totGuests() {
    return fields[0] + fields[1];
  }

  void _increase(int field) {
    if (_fullCapacity == _totGuests()) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => WarningDialog(type: "capacity"),
      );
      return;
    }
    if (_totGuests() >= _capacityWarning && !_almostCapacity) {
      setState(() {
        _almostCapacity = true;
      });
    }
    if (field == 1 && fields[0] == fields[1]) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => WarningDialog(type: "nonMemberFull"),
      );
    } else if (field == 2 && _totGuests() <= fields[2]) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => WarningDialog(type: "smokers"),
      );
    } else if (field != 2 || _totGuests() > fields[2]) {
      setState(() {
        if (_totGuests() >= _capacityWarning && !_almostCapacity) {
          _almostCapacity = true;
        }
        fields[field]++;
      });
    }
  }

  void _decrease(int field) {
    if (_totGuests() <= _capacityWarning && _almostCapacity) {
      setState(() {
        _almostCapacity = false;
      });
    }

    if (_totGuests() <= fields[2] && field != 2) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => WarningDialog(type: "smokers"),
      );
    } else if (fields[field] > 0) {
      setState(() {
        fields[field]--;
      });
    }
  }

  void _resetCounter() {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text("Reset the counter?"),
              content:
                  const Text("Are you SURE you want to reset the counter?"),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.blueGrey[50])),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => {
                    setState(() {
                      fields = [0, 0, 0];
                      _almostCapacity = false;
                    }),
                    Navigator.pop(context, 'Reset')
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.red[400])),
                  child: const Text('Reset'),
                ),
              ],
            ));
  }

  Widget _counterField(BuildContext context, int field, String header) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(header, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 7),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => _decrease(field),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                  ),
                  child: const Icon(Icons.remove),
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    '${fields[field]}',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _increase(field),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                  ),
                  child: const Icon(Icons.add),
                )
              ],
            )
          ]),
    );
  }

  Column _totField(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            height: 35,
          ),
          Text("Antal personer i lokalen",
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 10),
          Text('${_totGuests() - fields[2]}',
              style: Theme.of(context).textTheme.headlineLarge),
        ]);
  }

  Widget _warningBar(BuildContext context) {
    return Visibility(
        visible: _almostCapacity,
        maintainSize: true, //NEW
        maintainAnimation: true, //NEW
        maintainState: true, //NEW
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.red,
            width: double.infinity,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Det får plats ',
                style: Theme.of(context).textTheme.headlineSmall,
                children: <TextSpan>[
                  TextSpan(
                      text: '${widget.fooCapacity - _totGuests()}',
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                  const TextSpan(text: ' personer till i Foo'),
                ],
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          title: Text(widget.title),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                  title: Text(
                widget.title,
                style: Theme.of(context).textTheme.titleLarge,
              )),
              ListTile(
                leading: const Icon(Icons.replay_outlined),
                title: const Text('Reset counter'),
                onTap: () {
                  Navigator.pop(context);
                  _resetCounter();
                },
              )
            ],
          ),
        ),
        body: Stack(children: <Widget>[
          _warningBar(context),
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _totField(context),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _counterField(context, 0, "Antal medlemmar"),
                    _counterField(context, 1, "Antal icke-medlemmar"),
                    _counterField(context, 2, "Röker"),
                    const SizedBox(height: 50),
                  ],
                )
              ]),
          Positioned(
            bottom: 5,
            right: 5,
            child: Text("Made by Mallow",
                style: Theme.of(context).textTheme.labelSmall),
          ),
        ]));
  }
}

class WarningDialog extends StatelessWidget {
  final String type;

  static final Map<String, Map> text = {
    "capacity": {
      "title": "FOO BAR ÄR FULLT",
      "content": "Sorry, det finns inte mer plats! Folk får vänta!"
    },
    "nonMemberFull": {
      "title": "Det finns inte plats för fler externa!",
      "content": "Säg åt dom att bli medlemmar eller vänta!!!"
    },
    "smokers": {
      "title": "Är verkligen alla och röker?",
      "content": "Ta bort rökare först"
    }
  };

  WarningDialog({super.key, required this.type})
      : assert(text.keys.contains(type));

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(text[type]?["title"]),
      content: Text(text[type]?["content"]),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
