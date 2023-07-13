part of 'search_page_bloc.dart';

abstract class SearchPageEvent extends Equatable {
  const SearchPageEvent();
}

class SearchQuoteEvent extends SearchPageEvent {
  const SearchQuoteEvent(this.q);
  final String q;
  @override
  List<Object?> get props => [q];
}
