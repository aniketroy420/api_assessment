import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//ignore_for_file: avoid_print
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List _listResponse = [];
  var _isLoading = true;

  final url = Uri.parse('https://reqres.in/api/users?page=2');

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    loadUsers();
  }

  void postData() async {
    try {
      final response =
          await http.post(url, body: {"name": "morpheus", "job": "leader"});
      print(response.body);
      print(response.statusCode);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Status code:${response.statusCode} \n Body: ${response.body} '),
        ),
      );
    } catch (error) {
      print('There was an error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('There was an error'),
        ),
      );
    }
  }

  void loadUsers() async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map listData = json.decode(response.body);
      setState(() {
        _listResponse = listData['data'];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: postData,
        backgroundColor:Colors.green.shade800,
        child: const Icon(Icons.add),
      ),
      backgroundColor: const Color.fromARGB(255, 20, 24, 27),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Ziggy Assessment'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _listResponse.isEmpty
              ? const Center(
                  child: Text(
                  'The list is empty',
                  style: TextStyle(color: Colors.white, fontSize: 36),
                ))
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: _listResponse.length,
                  itemBuilder: (context, index) => Card(
                    color: const Color.fromARGB(255, 29, 36, 41),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.5, color: Colors.yellow),
                          ),
                          child: Image.network(
                            _listResponse[index]['avatar'],
                          ),
                        ),
                        Text(
                          '${_listResponse[index]['first_name']} ${_listResponse[index]['last_name']}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          '${_listResponse[index]['email']}',
                          style: const TextStyle(color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
