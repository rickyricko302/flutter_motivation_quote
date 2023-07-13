import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_motivation/data/models/random_quote_model.dart';
import 'package:flutter_motivation/data/models/status.dart';

import '../../../data/repositories/quote_repository.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final QuoteRepository repository;
  HomePageBloc(this.repository)
      : super(
            HomePageStates(model: RandomQuoteModel(), status: Status.LOADING)) {
    on<GetRandomQuoteEvent>(_getRandomEvent);
  }

  _getRandomEvent(
      GetRandomQuoteEvent event, Emitter<HomePageState> emit) async {
    try {
      RandomQuoteModel model = RandomQuoteModel();
      emit(HomePageStates(status: Status.LOADING, model: model));
      model = await repository.getRandomQuotes();
      emit(HomePageStates(status: Status.SUCCESS, model: model));
    } catch (e) {
      print(e);
      emit(HomePageStates(status: Status.ERROR, model: RandomQuoteModel()));
    }
  }
}
