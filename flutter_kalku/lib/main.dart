import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator 2 Halaman',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    CalculatorPage(),
    ProfilePage(),
  ];

  void _onTapNavBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<String> _titles = ['Kalkulator', 'Profil Pengguna'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTapNavBar,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.calculate), label: 'Kalkulator'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _input = '';
  String _result = '';
  List<String> _history = [];

  void _numClick(String text) {
    setState(() {
      _input += text;
    });
  }

  void _clearInput() {
    setState(() {
      _input = '';
      _result = '';
    });
  }

  void _calculateResult() {
    try {
      final expression = _input.replaceAll('x', '*').replaceAll('÷', '/');
      final result = _evaluateExpression(expression);
      setState(() {
        _result = '= $result';
        _history.insert(0, '$_input = $result');
        _input = '';
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  String _evaluateExpression(String expression) {
    final parsed = RegExp(r'([\d.]+|[*/+\-])')
        .allMatches(expression)
        .map((m) => m.group(0)!)
        .toList();

    List<String> ops = [];
    List<double> nums = [];

    for (var item in parsed) {
      if ('+-*/'.contains(item)) {
        ops.add(item);
      } else {
        nums.add(double.parse(item));
      }

      if (nums.length == 2 && ops.isNotEmpty) {
        final b = nums.removeLast();
        final a = nums.removeLast();
        final op = ops.removeLast();
        nums.add(_applyOp(a, b, op));
      }
    }

    return nums.isNotEmpty ? nums.first.toString() : '0';
  }

  double _applyOp(double a, double b, String op) {
    switch (op) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '*':
        return a * b;
      case '/':
        return b == 0 ? 0 : a / b;
      default:
        return 0;
    }
  }

  void _deleteHistory() {
    setState(() {
      _history.clear();
    });
  }

  Widget _buildButton(String text, {Color color = Colors.black}) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => _onButtonPressed(text),
        child: Text(text, style: TextStyle(fontSize: 24, color: color)),
      ),
    );
  }

  void _onButtonPressed(String text) {
    if (text == 'C') {
      _clearInput();
    } else if (text == '=') {
      _calculateResult();
    } else {
      _numClick(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          alignment: Alignment.centerRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(_input, style: TextStyle(fontSize: 32)),
              Text(_result, style: TextStyle(fontSize: 24, color: Colors.grey)),
            ],
          ),
        ),
        Column(
          children: [
            Row(children: [
              _buildButton('7'),
              _buildButton('8'),
              _buildButton('9'),
              _buildButton('÷')
            ]),
            Row(children: [
              _buildButton('4'),
              _buildButton('5'),
              _buildButton('6'),
              _buildButton('x')
            ]),
            Row(children: [
              _buildButton('1'),
              _buildButton('2'),
              _buildButton('3'),
              _buildButton('-')
            ]),
            Row(children: [
              _buildButton('0'),
              _buildButton('.'),
              _buildButton('C'),
              _buildButton('+')
            ]),
            Row(children: [_buildButton('=', color: Colors.blue)]),
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(padding: EdgeInsets.all(8), child: Text('Riwayat')),
            TextButton.icon(
              onPressed: _deleteHistory,
              icon: Icon(Icons.delete, size: 18),
              label: Text("Hapus"),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _history.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(_history[index]),
            ),
          ),
        ),
      ],
    );
  }
}

class ProfilePage extends StatelessWidget {
  final String name = 'Sava si Pembelah Rathian';
  final String email = 'sava@example.com';
  final String description = 'Pengguna setia kalkulator Flutter.';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(24),
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.account_circle, size: 100, color: Colors.blue),
              SizedBox(height: 16),
              Text(name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(email, style: TextStyle(color: Colors.grey[700])),
              SizedBox(height: 8),
              Text(description, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
