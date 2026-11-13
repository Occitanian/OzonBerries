part of 'content_bloc.dart';

sealed class ContentState extends Equatable {
  const ContentState();

  @override
  List<Object> get props => [];
}

final class ContentInitial extends ContentState {}

final class ContentLoading extends ContentState {}

final class ContentLoaded extends ContentState {
  final Content content;
  const ContentLoaded(this.content);

  @override
  List<Object> get props => [content];
}

final class ContentError extends ContentState {
  final String message;
  const ContentError(this.message);

  @override
  List<Object> get props => [message];
}