// ignore_for_file: constant_identifier_names

class AssetsApi {
  static const String _BASE_URL = "https://jkscrapper.vercel.app";

  static const String apiQuoteRandom = "$_BASE_URL/acak";

  static String apiSearch(String q, int page) {
    return "$_BASE_URL/cari?q=$q&page=$page";
  }
}
