import 'dart:convert';
import 'dart:developer';

import 'package:flutter_motivation/constants/assets_api.dart';
import 'package:flutter_motivation/data/models/random_quote_model.dart';
import 'package:flutter_motivation/data/models/search_quote_model.dart';
import 'package:flutter_motivation/utils/response_reader.dart';
import 'package:http/http.dart' as http;

class QuoteRepository {
  Future<RandomQuoteModel> getRandomQuotes() async {
    var response = await http.get(Uri.parse(AssetsApi.apiQuoteRandom));
    String res = ResponseHandler.createMessage(response);
    log(res);
    if (response.statusCode != 200) {
      throw res;
    }
    return RandomQuoteModel.fromJson(jsonDecode(response.body));
  }

  Future<SearchQuoteModel> getSearchQuotes(String q, int page) async {
    var response = await http.get(Uri.parse(AssetsApi.apiSearch(q, page)));
    String res = ResponseHandler.createMessage(response);
    log((response.request?.url ?? "").toString());
    if (response.statusCode != 200) {
      throw res;
    }
    return SearchQuoteModel.fromJson(jsonDecode(response.body));
  }
}
