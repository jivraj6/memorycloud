import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GalleryScreen extends StatefulWidget {
  final String userId;
  const GalleryScreen(this.userId);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List media = [];
  Future<void> fetchMedia() async {
    var url = Uri.parse("https://yourdomain.com/api/list_media.php?user_id=${widget.userId}");
    var res = await http.get(url);
    setState(() => media = jsonDecode(res.body));
  }

  @override
  void initState() {
    super.initState();
    fetchMedia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Gallery")),
      body: GridView.builder(
        itemCount: media.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (_, i) {
          var m = media[i];
          return m["type"] == "photo"
              ? Image.network("https://yourdomain.com/" + m["filepath"])
              : Text(m["filename"]); // video thumbnail later
        },
      ),
    );
  }
}
