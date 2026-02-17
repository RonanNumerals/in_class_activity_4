import 'package:flutter/material.dart';
void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    // Application name
    title: 'Stateful Widget',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    // A widget that will be started on the application startup
    home: CounterWidget(),
    );
  }
}

class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  //initial couter value
  int _counter = 0;
  bool invalid = false;
  final List<int> _history = [];

  final _textController = TextEditingController();

  void _decrement() {
    setState(() {
      _counter--;
      if (_counter < 0) {
        _counter = 0;
      }
    });
  }

  void _increment() {
    setState(() {
      _counter++;
      if (_counter > 100) {
        _counter = 100;
      }
    });
  }

  void _reset() {
    setState(() {
      _counter = 0;
    });
  }

  void _undo() {
    setState(() {
      if (_history.length > 1) {
        _history.removeLast();
        _counter = _history.last;
      } else if (_history.length == 1) {
        _history.removeLast();
        _counter = 0;
      }
    });
  }

  void _saveInput() {
    setState(() {
      _history.add(_counter);
    });
  }

  void _customUserInput(){
    int? value = int.tryParse(_textController.text);
    if (value != null) {
        setState(() {
          invalid = false;
          _counter += value;
          if (_counter > 100) {
            _counter = 100;
          }
          _saveInput();
        }
      );
    }else{
      setState(() {
        invalid = true;
      });
    }
  }

  Color counterColor() {
    if (_counter > 50) {
      return Colors.green;
    } else if (_counter == 0) {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stateful Widget'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2.0),
              ),
              child: Text(
                //displays the current number
                '$_counter',
                style: TextStyle(fontSize: 50.0, color: counterColor()),
              ),
            ),
          ),
          if (_counter == 100)
            Text(
              'Maximum limit reached!',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          Slider(
            min: 0,
            max: 100,
            value: _counter.toDouble(),
            onChanged: (double value) {
              setState(() {
                _counter = value.toInt();
              });
            },
            onChangeEnd: (double value) {
              setState(() {
                _history.add(_counter);
              });
            },
            activeColor: Colors.blue,
            inactiveColor: Colors.red,
          ),
          const SizedBox(height: 12),
          Row (
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _increment();
                  _saveInput();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text('Increment', style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  _decrement();
                  _saveInput();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Decrement', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row (
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _reset,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                ),
                child: const Text('Reset', style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _undo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: const Text('Undo', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 300,
            height: 50,
            child: TextField (
              controller: _textController,
              decoration : InputDecoration (
                labelText : 'Enter value (0-100)',
                border : OutlineInputBorder (),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              _customUserInput();
            },
            child: const Text('Enter'),
          ),
          if (invalid == true)
            Text(
              'Invalid user input!',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "History:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.1),
                  child: ListTile(
                    title: Text(
                      _history[index].toString(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}