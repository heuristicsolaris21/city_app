import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class press extends StatefulWidget {
  const press({super.key});
  @override
  State<press> createState() => _pressState();
}

class _pressState extends State<press> {
  List<dynamic> newsData = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  fetchNews() async {
    final response = await http.get(Uri.parse('https://kovai-news-api.onrender.com/getNews'));
    if (response.statusCode == 200) {
      setState(() {
        newsData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 11, 51, 83),
          title: Row(
            children: [
              Text("Press Release"),
              Spacer(),
              Image.asset(
                'assets/cityapplogo.png',
                width: 80,
                height: 100,
              ),
            ],
          ),
        ),
        body: ListView.builder(
          itemCount: newsData.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Image.network(newsData[index]['image']),
              title: Text(newsData[index]['headline']),
              subtitle: Text(newsData[index]['content']),
              trailing: IconButton(
                icon: Icon(Icons.picture_as_pdf),
                onPressed: () async {
                  if (await canLaunch(newsData[index]['pdfLink'])) {
                    await launch(newsData[index]['pdfLink']);
                  } else {
                    throw 'Could not launch PDF';
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
