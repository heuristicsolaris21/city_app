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
    final response = await http
        .get(Uri.parse('https://kovai-news-api.onrender.com/getNews'));
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
            return Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Container(
                child: Center(
                  child: Card(
                    elevation: 5, // Add elevation for a shadow effect
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Add rounded corners
                    ),
                    child: InkWell(
                      onTap: () async {
                        if (await canLaunchUrl(
                            Uri.parse(newsData[index]['pdfLink']))) {
                          await launchUrl(
                              Uri.parse(newsData[index]['pdfLink']));
                        } else {
                          throw 'Could not launch';
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                            child: newsData[index]['image'] != null &&
                                    newsData[index]['image'].isNotEmpty
                                ? Image.network(
                                    newsData[index]['image'],
                                    height: 150, // Adjust the height as needed
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/cityapplogo.png', // Replace with your default image asset
                                    height: 150, // Adjust the height as needed
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8),
                                Text(
                                  newsData[index]['headline'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  newsData[index]['content'],
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'PDF',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.picture_as_pdf),
                                  onPressed: () async {
                                    if (await canLaunchUrl(Uri.parse(
                                        newsData[index]['pdfLink']))) {
                                      await launchUrl(Uri.parse(
                                          newsData[index]['pdfLink']));
                                    } else {
                                      throw 'Could not launch';
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
