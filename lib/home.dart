import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snapnews/news_api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'news_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

String defaultImageUrl =
    'https://www.middleweb.com/wp-content/uploads/2017/08/breaking-news-blue-600.jpg';
String getImageUrlOrFallback(String image) {
  if (image.isNotEmpty) {
    return image;
  } else {
    return defaultImageUrl;
  }
}

class _HomeState extends State<Home> {
  static List<News> _news = <News>[];
  static List<News> _newsInApp = <News>[];
  @override
  void initState() {
    comingNews().then((value) {
      setState(() {
        _news.addAll(value);
        _newsInApp = _news;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("SnapNews",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w400)),
          centerTitle: true,
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return _listitem(index);
          },
          itemCount: _newsInApp.length,
        ));
  }

  _listitem(index) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                title: Text(
                  _newsInApp[index].title,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400, color: Colors.black),
                ),
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        getImageUrlOrFallback(_newsInApp[index].image),
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        _newsInApp[index].title,
                        style: GoogleFonts.poppins(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        _newsInApp[index].publisher,
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        _newsInApp[index].text,
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "Date: ",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54),
                          ),
                          Text(
                            _newsInApp[index].date,
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Full story at: ",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      InkWell(
                          child: Text(
                            _newsInApp[index].url,
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.blue),
                          ),
                          onTap: () async {
                            final uri = Uri.parse(_newsInApp[index].url);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri,mode: LaunchMode.inAppWebView);
                            } else {
                              throw Exception('Could not launch $uri');
                            }
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }));
      },
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                getImageUrlOrFallback(_newsInApp[index].image),
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      _newsInApp[index].title,
                      softWrap: true,
                      maxLines: 2,
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                _newsInApp[index].publisher,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
