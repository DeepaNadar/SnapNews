import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:snapnews/news_model.dart';

Future<List<News>> comingNews() async {
var url = Uri.parse('http://www.mocky.io/v2/5ecfddf13200006600e3d6d0');
  var response=await http.get(url);
  var news = <News>[];
if(response.statusCode==200){
  var notesJson=json.decode(response.body);
  for(var noteJson in notesJson){
    news.add(News.fromJson(noteJson));
  }
}
return news;
}