import 'package:flutter_motivation/data/models/quotes.dart';

class RandomQuoteModel {
  bool? success;
  String? message;
  List<Quotes>? data;

  RandomQuoteModel({this.success, this.message, this.data});

  RandomQuoteModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Quotes>[];
      json['data'].forEach((v) {
        data!.add(Quotes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
