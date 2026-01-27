import '../../data/models/item_model.dart';


class ManagementItemsState {
  bool? isLoading;
  bool? isActive;
  String? selectedItem;
  List<List<HeirModel>>? selectedItems;


  ManagementItemsState({
    this.isLoading,
    this.isActive,
    this.selectedItem,
    this.selectedItems,
  }) {
    isLoading = isLoading ?? false;
    isActive = isActive ?? false;
    selectedItem = selectedItem ?? 'أختر';
    selectedItems = selectedItems ?? [];
  }


  ManagementItemsState copyWith({
    bool? isLoading,
    bool? isActive,
    String? selectedItem,
    List<List<HeirModel>>? selectedItems
  }) {
    return ManagementItemsState(
      isLoading: isLoading ?? this.isLoading,
      isActive: isActive ?? this.isActive,
      selectedItem: selectedItem ?? this.selectedItem,
      selectedItems: selectedItems ?? this.selectedItems
    );
  }
}