part of 'search_page_bloc.dart';

abstract class SearchPageState extends Equatable {
  const SearchPageState();

  @override
  List<Object> get props => [];
}

class SearchPageInitial extends SearchPageState {}

class SearchPageLoading extends SearchPageState {}

class SearchPageError extends SearchPageState {}

class SearchPageSuccess extends SearchPageState {
  const SearchPageSuccess({required this.data});
  final SearchQuoteModel data;
  @override
  List<Object> get props => [data];
}
