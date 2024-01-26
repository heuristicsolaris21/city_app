import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class newscard extends StatelessWidget {
  newscard({required this.desc,required this.image,required this.title,required this.url,super.key});
  String image;
  String desc;
  String title;
  String url;
  Future<void> _launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
   @override
Widget build(BuildContext context) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    elevation: 5,
    child: InkWell(
      borderRadius: BorderRadius.circular(15.0),
      onTap: _launchURL,
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
            child: Image.network(image),
          ),
          ListTile(
            title: Text(title),
            subtitle: Text(desc),
          ),
        ],
      ),
    ),
  );
}

}