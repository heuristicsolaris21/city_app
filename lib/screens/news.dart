import 'package:city_app/others/newscard.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsPage extends StatelessWidget {
  const NewsPage({Key? key}) : super(key: key);

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
      ),
      body: FutureBuilder<List<NewsArticle>>(
        future: NewsdataApiService().fetchCoimbatoreNews(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return newscard(
                    desc: snapshot.data![index].description,
                    image: snapshot.data![index].imageUrl,
                    title: snapshot.data![index].title,
                    url: snapshot.data![index].link);
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

class NewsArticle {
  final String title;
  final String description;
  final String imageUrl;
  final String link;

  NewsArticle({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.link,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'No title',
      description: json['description'] ?? 'No description',
      imageUrl: json['image_url'] ??
          'https://miro.medium.com/v2/resize:fit:960/0*lNSWeJsNztTtvaMK.jpg',
      link: json['link'] ?? '',
    );
  }
}

class NewsdataApiService {
  Future<List<NewsArticle>> fetchCoimbatoreNews() async {
    final response = await http.get(
      Uri.parse(
          'https://newsdata.io/api/1/news?apikey=pub_3712399c86fa96a73d94101a0b9c57e5d4b62&q=Coimbatore'),
    );
    if(response.statusCode == 200){
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List<dynamic> articlesJson = jsonResponse['results'];

      return articlesJson.map((json) => NewsArticle.fromJson(json)).toList();
    }else{
      throw Exception('Failed to load news');
    }
  }
}
