import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'APIModel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage();
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<ApiDataModel>> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=8274168b191f4f45a40aab04dae0b09a'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['articles'];
      return data.map((json) => ApiDataModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Eighty7 Finance Planners Task")),
        body: FutureBuilder<List<ApiDataModel>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data available.'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          item.title.toString(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        Text(item.description.toString()),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                            child: item.imageUrl != null
                                ? Image.network(item.imageUrl.toString())
                                : const SizedBox(
                                    height: 10,
                                  )),
                        const SizedBox(
                          height: 10,
                        ),
                        Text("Published:- ${item.published}")
                      ],
                    ),
                  );
                },
              );
            }
          },
        ));
  }
}
