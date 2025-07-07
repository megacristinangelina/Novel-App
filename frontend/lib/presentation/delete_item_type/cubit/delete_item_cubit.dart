import 'package:bloc/bloc.dart';
import 'package:flutter_pos/core/item_type_repository.dart';
import 'package:meta/meta.dart';

part 'delete_item_state.dart';

class DeleteItemCubit extends Cubit<DeleteItemState> {
  final ItemTypeRepository repository;

  DeleteItemCubit({required this.repository}) : super(DeleteItemInitial());

  Future<void> delete(int id) async {
    emit(DeleteItemLoading());
    try {
      final result = await repository.delete(id);
      emit(DeleteItemSuccess(message: result.message));
    } catch (e) {
      emit(DeleteItemError(message: e.toString()));
    }
  }
}