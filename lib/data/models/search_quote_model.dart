import 'package:flutter_motivation/data/models/quotes.dart';

class SearchQuoteModel {
  bool? success;
  String? message;
  SearchModel? data;

  SearchQuoteModel({this.success, this.message, this.data});

  SearchQuoteModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? SearchModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class SearchModel {
  int? currentPaginate;
  int? lastPaginate;
  String? paginate;
  bool? next;
  List<Quotes>? result;

  SearchModel(
      {this.currentPaginate,
      this.lastPaginate,
      this.paginate,
      this.next,
      this.result});

  SearchModel.fromJson(Map<String, dynamic> json) {
    currentPaginate = json['currentPaginate'];
    lastPaginate = json['lastPaginate'];
    paginate = json['paginate'];
    next = json['next'];
    if (json['result'] != null) {
      result = <Quotes>[];
      json['result'].forEach((v) {
        result!.add(Quotes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currentPaginate'] = currentPaginate;
    data['lastPaginate'] = lastPaginate;
    data['paginate'] = paginate;
    data['next'] = next;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
