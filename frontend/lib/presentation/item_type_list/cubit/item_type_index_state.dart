part of 'item_type_index_cubit.dart';

@immutable
sealed class ItemTypeIndexState {}

final class ItemTypeIndexInitial extends ItemTypeIndexState {}

final class ItemTypeIndexLoaded extends ItemTypeIndexState {
  final List<ItemType> itemTypes;
  ItemTypeIndexLoaded({required this.itemTypes});
}


