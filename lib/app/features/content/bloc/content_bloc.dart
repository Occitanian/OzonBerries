import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/domain.dart';

part 'content_event.dart';
part 'content_state.dart';

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  final ContentRepositoryInterface repository;

  ContentBloc(this.repository) : super(ContentInitial()) {
    on<LoadContent>(_onLoadContent);
  }

  Future<void> _onLoadContent(LoadContent event, Emitter<ContentState> emit) async {
    // Если ID отрицательный (наши локальные карточки), не идём в сеть
    if (event.id < 0 && event.initialContent != null) {
      emit(ContentLoaded(event.initialContent!));
      return;
    }

    emit(ContentLoading());
    try {
      final content = await repository.getContentById(event.id);
      emit(ContentLoaded(content));
    } catch (e) {
      emit(ContentError(e.toString()));
    }
  }
}