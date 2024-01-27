import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class newscard extends StatelessWidget {
  newscard(
      {required this.desc,
      required this.image,
      required this.title,
      required this.url,
      super.key});
  String image;
  String desc;
  String title;
  String url;
  Future<void> _launchURL() async {
    launchUrl(Uri.parse(url));
  }

  @override
Widget build(BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(left: 20,right: 20,top: 10),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: _launchURL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
              child: Image.network(
                image,
                height: 150, // Adjust the height as needed
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

}
