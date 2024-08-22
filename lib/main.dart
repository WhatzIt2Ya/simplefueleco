import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Fuel Economy Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final _distanceController = TextEditingController();
  final _litresController = TextEditingController();
  double _averageResult = 0;
  final List<double> _results = [];
  final List<String> _log = [];

  @override
  void dispose() {
    _distanceController.dispose();
    _litresController.dispose();
    super.dispose();
  }

  void _calculateResult() {
    if (_distanceController.text.isNotEmpty &&
        _litresController.text.isNotEmpty) {
      double distance = double.tryParse(_distanceController.text) ?? 0.0;
      double litres = double.tryParse(_litresController.text) ?? 1.0;
      double result = distance / litres;

      DateTime now = DateTime.now();
      String dateTimeString =
          '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}';

      String logEntry =
          '$dateTimeString - $distance km / $litres L = ${result.toStringAsFixed(1)} km/L';

      setState(() {
        _results.add(result);
        _averageResult = _results.reduce((a, b) => a + b) / _results.length;
        _log.insert(0, logEntry);
      });
    }
  }

  void _showAboutPage() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About this app'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'This is a simple Fuel Economy Calculator app. Calculate your fuel efficiency and keep track of your vehicle\'s fuel consumption overtime.',
              ),
              const SizedBox(height: 20), // Increased spacing
              const Text(
                'About me',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20), // Increased spacing
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  children: [
                    const TextSpan(
                      text:
                          'This application was created by XDA user Jt380p. You can discover my other work and help support me by clicking the link below. \n',
                    ),
                    const TextSpan(text: '\n'),
                    WidgetSpan(
                      child: InkWell(
                        onTap: () async {
                          const url =
                              'https://xdaforums.com/m/jt380p.9057547/#recent-content';
                          await launchUrlString(url);
                        },
                        child: const Text(
                          'Visit my XDA page',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const TextSpan(text: '\n'),
                    const TextSpan(text: '\n'),
                    WidgetSpan(
                      child: InkWell(
                        onTap: () async {
                          const url = 'https://linktr.ee/JUSTaFlyer_au';
                          await launchUrlString(url);
                        },
                        child: const Text(
                          'See all my other work here',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Fuel Economy Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              _showAboutPage();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextFormField(
                controller: _distanceController,
                autofocus: true,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: 'Enter distance in kilometres',
                  prefixIcon: const Icon(Icons.straighten),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => _distanceController.clear(),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: const TextStyle(fontSize: 20),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const Align(
              alignment: AlignmentDirectional(0, -1),
              child: Text(
                '÷',
                style: TextStyle(fontSize: 50),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextFormField(
                controller: _litresController,
                autofocus: true,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: 'Enter litres',
                  prefixIcon: const Icon(Icons.local_gas_station),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => _litresController.clear(),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: const TextStyle(fontSize: 20),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _calculateResult();
                });
              },
              child: const Text('Calculate'),
            ),
            Text(_averageResult.toStringAsFixed(1),
                style: const TextStyle(fontSize: 100)),
            const Align(
              alignment: AlignmentDirectional(0, -1),
              child: Text(
                'km/L (Average)',
                style: TextStyle(fontSize: 50),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: AlignmentDirectional(-1, -1),
              child: Text(
                ' Log history',
                style: TextStyle(fontSize: 30),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                showConfirmationDialog(context);
              },
              child: const Text('Clear Log History'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _log.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_log[index]),
                  );
                },
                reverse: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Log History'),
          content:
              const Text('Are you sure you want to clear the log history?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _log.clear();
                  _results.clear(); // Clear the results list
                  _averageResult = 0; // Reset the average result
                });
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
