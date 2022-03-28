import 'package:leadoneattendance/models/posts.dart';
import 'package:http/http.dart' as http;
import 'package:leadoneattendance/models/recent_records.dart';
class RemoteService{
  Future<List<RecentRecords>?> getPosts() async{
    var client = http.Client();

    var uri = Uri.parse('http://3052-45-65-152-57.ngrok.io/FiveRecords');
    var response = await client.get(uri);
    if (response.statusCode == 200){
      var json = response.body;
      return postsFromJson(json);
    }
  }
}