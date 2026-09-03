import '../../data/models/item_model.dart';


class ManagementItemsState {
  final bool? isLoading;
  final bool? isActive;
  final String? selectedItem;
  final List<List<HeirModel>> selectedItems;

  const ManagementItemsState({
    this.isLoading = false,
    this.isActive = false,
    this.selectedItem = 'أختر',
    this.selectedItems = const[],
  });

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