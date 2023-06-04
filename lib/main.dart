import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  List<Product> _apiData = List.empty();

  void _incrementCounter() async {
    setState(() {
      _counter++;
    });

    final dio = Dio();
    final response = await dio.get('https://dummyjson.com/products');
    print(response.data['products']);

    setState(() {
      Map<String, dynamic> productsMap = jsonDecode(response.data['products']);
      //_apiData =
      productsMap.entries
          .map((e) => {print(Product.fromJson(e.value))})
          .toList(growable: false);
      //_apiData = response.data['products'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _apiData.isEmpty
          ? Container()
          : ListView.builder(
              itemCount: _apiData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_apiData[index].title),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Product {
  final String id;
  final String title;

  Product(this.id, this.title);

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
      };
}
