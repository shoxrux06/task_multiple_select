import 'package:task_dropdown/models/multiple_item_model.dart';

class MultipleSelectState {
  final List<MultipleItem> originalItems;
  final List<MultipleItem> displayedItems;
  final String searchQuery;

  MultipleSelectState({
    required this.originalItems,
    required this.displayedItems,
    this.searchQuery = '',
  });

  List<MultipleItem> getSelectedItems() {
    List<MultipleItem> selected = [];

    void collectSelected(MultipleItem item) {
      if (item.isSelected) selected.add(item);
      for (var child in item.children) {
        collectSelected(child);
      }
    }

    for (var item in originalItems) {
      collectSelected(item);
    }

    return selected;
  }

  MultipleSelectState copyWith({
    List<MultipleItem>? originalItems,
    List<MultipleItem>? displayedItems,
    String? searchQuery,
  }) {
    return MultipleSelectState(
      originalItems: originalItems ?? this.originalItems,
      displayedItems: displayedItems ?? this.displayedItems,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
