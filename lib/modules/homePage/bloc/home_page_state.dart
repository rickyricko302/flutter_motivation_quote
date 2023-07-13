part of 'home_page_bloc.dart';

abstract class HomePageState extends Equatable {
  const HomePageState({required this.status, required this.model});
  final Status status;
  final RandomQuoteModel model;
  @override
  List<Object> get props => [status, model];
}

class HomePageStates extends HomePageState {
  const HomePageStates({required super.status, required super.model});
}
