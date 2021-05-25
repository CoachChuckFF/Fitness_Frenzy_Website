/*
* Christian Krueger Health LLC.
* All Rights Reserved.
*
* Author: Christian Krueger
* Date: 4.16.20
*
*/
//Internal
import 'package:fitnessFrenzyWebsite/Models/models.dart';
import 'package:fitnessFrenzyWebsite/Controllers/controllers.dart';

class YoutubeAggregate{
  static final StaticGlobalData<YoutubeAggregate> firebase = StaticGlobalData(youtubeAggregateCollection, youtubeAggregateDocument);
  static const String youtubeAggregateCollection = "Aggregate";
  static const String youtubeAggregateDocument = "Videos";
  final List<String> urls;

  YoutubeAggregate({this.urls});

  static getThumbnailURL(String url){
    const String thumnail = "https://img.youtube.com/vi/*/hqdefault.jpg";

    List<String> split = url.split("?v=");

    if(split.length != 2){
      LOG.log("Bad YT URL: $url", FoodFrenzyDebugging.crash);
      return "badurl";
    }

    return thumnail.replaceAll("*", split.last);

    // https://www.youtube.com/watch?v=gwfKqPYSGK0

  }

  factory YoutubeAggregate.fromMap(Map data){
    return YoutubeAggregate(
      urls : (data['urls'] is List<dynamic>) ? [
        for (var url in data['urls']) url   
      ] : []
    );
  }
}