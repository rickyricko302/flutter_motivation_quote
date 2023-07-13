import 'package:http/http.dart';

class ResponseHandler {
  static String createMessage(Response response) {
    String message =
        "- url : ${response.request?.url}\n- status code : ${response.statusCode}\n- response : ${response.body}";
    return message;
  }
}
