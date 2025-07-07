

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/core/item_type_repository.dart';

part 'add_item_state.dart';

class AddItemCubit extends Cubit<AddItemState> {
  final itemTypeRepository = ItemTypeRepository();

  AddItemCubit() : super(AddItemInitial());

  void submit(String title, String author, String gendre) async {
    emit(AddItemLoading());
    try {
      final params = {"author": author, "title": title, "gendre": gendre};
      final result = await itemTypeRepository.create(params);

      emit(AddItemSuccess(message: result.message));
    } on DioError catch (_) {
      emit(AddItemError(message: "Masalah Koneksi"));
    } catch (e) {
      emit(AddItemError(message: e.toString()));
    }
  }
}
