part of 'content_bloc.dart';

sealed class ContentEvent extends Equatable {
  const ContentEvent();

  @override
  List<Object> get props => [];
}

class LoadContent extends ContentEvent {
  final int id;
  final Content? initialContent; // Передаём то, что пришло с главного экрана

  const LoadContent({required this.id, this.initialContent});

  @override
  List<Object> get props => [id];
}