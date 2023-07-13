import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_motivation/data/models/search_quote_model.dart';

import '../../../data/repositories/quote_repository.dart';

part 'search_page_event.dart';
part 'search_page_state.dart';

class SearchPageBloc extends Bloc<SearchPageEvent, SearchPageState> {
  final QuoteRepository repository;
  String world = "";
  int page = 1;
  SearchPageBloc(this.repository) : super(SearchPageInitial()) {
    on<SearchQuoteEvent>(_searchQuote);
  }

  _searchQuote(SearchQuoteEvent event, Emitter<SearchPageState> emit) async {
    try {
      emit(SearchPageLoading());
      world = event.q;
      SearchQuoteModel model = await repository.getSearchQuotes(event.q, page);
      emit(SearchPageSuccess(data: model));
    } catch (e) {
      emit(SearchPageError());
    }
  }
}

class PaginationCubit extends Cubit<int> {
  final SearchPageBloc searchPageBloc;
  PaginationCubit({required this.searchPageBloc})
      : super(searchPageBloc.page - 1);

  void changePage(int page, String world) {
    emit(page);
    searchPageBloc.page = page;
    searchPageBloc.add(SearchQuoteEvent(world));
  }
}
