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
      title: 'Foo Bar counter',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const FooPage(title: 'Foo Bar counter'),
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
  final int _capacityWarning = 25; // Number of ppl in Foo resulting in warning

  void _increase(int field) {
    int tot = fields[0] + fields[1];
    if (tot >= _capacityWarning && !_almostCapacity) {
      setState(() {
        _almostCapacity = true;
      });
    }
    if (field != 2 || tot > fields[2]) {
      setState(() {
        if (tot >= _capacityWarning && !_almostCapacity) {
          _almostCapacity = true;
        }
        fields[field]++;
      });
    }
  }

  void _decrease(int field) {
    int totGuests = fields[0] + fields[1];
    if (totGuests <= _capacityWarning && _almostCapacity) {
      setState(() {
        _almostCapacity = false;
      });
    }

    if (totGuests <= fields[2] && field != 2) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Är verkligen alla och röker?'),
          content: const Text('Ta bort rökare först'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else if (fields[field] > 0) {
      setState(() {
        fields[field]--;
      });
    }
  }

  Column _counterField(BuildContext context, int field, String header) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(header, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => _increase(field),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(5),
                ),
                child: const Icon(Icons.add),
              ),
              Text(
                '${fields[field]}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              ElevatedButton(
                onPressed: () => _decrease(field),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(5),
                ),
                child: const Icon(Icons.remove),
              )
            ],
          )
        ]);
  }

  Column _totField(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Antal personer i lokalen",
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 5),
          Text('${fields[0] + fields[1] - fields[2]}',
              style: Theme.of(context).textTheme.headlineMedium),
        ]);
  }

  Widget _warningBar(BuildContext context) {
    return Visibility(
        visible: _almostCapacity,
        maintainSize: true, //NEW
        maintainAnimation: true, //NEW
        maintainState: true, //NEW
        child: ListTile(
            tileColor: Colors.red,
            title: Text(
              "Det får plats ${widget.fooCapacity - (fields[0] + fields[1])} till i lokalen",
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
            margin: EdgeInsets.only(bottom: 120),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _warningBar(context),
                  Expanded(flex: 3, child: _totField(context)),
                  Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _counterField(context, 0, "Antal medlemmar"),
                          _counterField(context, 1, "Antal icke-medlemmar"),
                          _counterField(context, 2, "Röker")
                        ],
                      ))
                ])));
  }
}
