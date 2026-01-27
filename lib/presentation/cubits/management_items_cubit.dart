import '../../data/models/item_model.dart';
import '../states/management_items_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/useCasese/items_operators.dart';
import '../../domain/useCasese/update_heir_count.dart';


class ManagementItemsCubit extends Cubit<ManagementItemsState> {
  final UpdateHeirCount _updateItem;
  final ItemsOperators _itemsOperators;

  ManagementItemsCubit({
    required UpdateHeirCount updateItem,
    required ItemsOperators itemsOperators,
  })
      :
        _updateItem = updateItem,
        _itemsOperators = itemsOperators,
        super(ManagementItemsState());


  static ManagementItemsCubit get(context) => BlocProvider.of(context);

  void addHeir(String value) {
    final newState = _itemsOperators.addItem(value)!;
    emit(state.copyWith(
        isActive: newState.isActive,
        selectedItem: newState.selectedItem,
        selectedItems: [...state.selectedItems!, ...newState.selectedItems!]));
  }

  void updateHeir(HeirModel heirModel) {
    _updateItem.updateItem(heirModel);
  }

  void removeHeir(HeirModel item) {
    final newState = _itemsOperators.removeItem(item);
    emit(state.copyWith(
        isActive: newState.isActive,
        selectedItems: [...state.selectedItems!, ...newState.selectedItems!]));
  }
}
