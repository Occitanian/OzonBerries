import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/domain.dart';
import '../../../../di/di.dart';
import '../mock_data.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ContentRepositoryInterface contentRepository;

  HomeBloc(this.contentRepository) : super(HomeInitial()) {
    on<HomeLoad>(_homeLoad);
  }

  Future<void> _homeLoad(HomeLoad event, Emitter<HomeState> emit) async {
    try {
      if (state is! HomeLoadSuccess) {
        emit(HomeLoadInProgress());
      }

      final apiContent = await contentRepository.getContent();

      // 🔹 Сначала локальные карточки, потом данные из API
      final content = <Content>[...mockItems, ...apiContent];

      emit(HomeLoadSuccess(content: content));
    } catch (exception, stackTrace) {
      emit(HomeLoadFailure(exception: exception));
      talker.handle(exception, stackTrace);
    } finally {
      event.completer?.complete();
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    talker.handle(error, stackTrace);
  }
}