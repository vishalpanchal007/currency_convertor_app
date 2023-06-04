import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      home: ConverterPage(),
    );
  }
}

class ConverterPage extends StatefulWidget {
  @override
  _ConverterPageState createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  double _amount = 0;
  double _convertedAmount = 0;
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';

  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'JPY'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Currency Converter',
        ),
        centerTitle: true,
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 100,
              color: Colors.white,
              child: TextField(
                decoration: InputDecoration(hintText: "Amount"),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _amount = double.parse(value);
                    _convertCurrency();
                  });
                },
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('From:',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          backgroundColor: Colors.black12)),
                  DropdownButton<String>(
                    value: _fromCurrency,
                    onChanged: (value) {
                      setState(() {
                        _fromCurrency = value!;
                        _convertCurrency();
                      });
                    },
                    items: _currencies
                        .map<DropdownMenuItem<String>>((String currency) {
                      return DropdownMenuItem<String>(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
            Container(
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('To:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  DropdownButton<String>(
                    value: _toCurrency,
                    onChanged: (value) {
                      setState(() {
                        _toCurrency = value!;
                        _convertCurrency();
                      });
                    },
                    items: _currencies
                        .map<DropdownMenuItem<String>>((String currency) {
                      return DropdownMenuItem<String>(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 70),
            Container(
                height: 50,
                width: 320,
                color: Colors.blueAccent,
                child: Center(
                    child: Text(
                  'Converted Amount: $_convertedAmount',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ))),
          ],
        ),
      ),
    );
  }

  void _convertCurrency() async {
    if (_amount == 0) {
      setState(() {
        _convertedAmount = 0;
      });
      return;
    }

    final response = await http.get(
        Uri.parse('https://api.exchangerate-api.com/v4/latest/$_fromCurrency'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final double rate = data['rates'][_toCurrency];
      setState(() {
        _convertedAmount = _amount * rate;
      });
    } else {
      setState(() {
        _convertedAmount = 0;
      });
    }
  }
}
