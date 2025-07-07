part of 'delete_item_cubit.dart';

@immutable
sealed class DeleteItemState {}

final class DeleteItemInitial extends DeleteItemState {}

class DeleteItemLoading extends DeleteItemState {}

class DeleteItemSuccess extends DeleteItemState {
  final String message;

  DeleteItemSuccess({required this.message});
}

class DeleteItemError extends DeleteItemState {
  final String message;

  DeleteItemError({required this.message});
}
