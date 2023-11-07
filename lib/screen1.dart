import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> data = []; // List to store fetched data

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      setState(() {
        data = json.decode(response.body);
      });
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('API Data Fetching Example'),
      ),
      body: Center(
        child: data.isEmpty
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('close'))
                                  ],
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Street: ${data[index]["address"]["street"]}'),
                                      Text(
                                          'Suite: ${data[index]["address"]["suite"]}'),
                                      Text(
                                          'City: ${data[index]["address"]["city"]}'),
                                      Text(
                                          'zip Code : ${data[index]["address"]["zipcode"]}')
                                    ],
                                  ),
                                ));
                      },
                      child: Card(
                        child: ListTile(
                          leading: Text((1 + index).toString()),
                          title: Text(data[index]['name']),
                          subtitle: Text(data[index]['email']),
                          trailing: Icon(Icons.person),
                          // Customize the widget based on your API response structure
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
