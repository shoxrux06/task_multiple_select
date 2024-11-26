import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_dropdown/bloc/multiple_select_event.dart';
import 'package:task_dropdown/bloc/multiple_select_state.dart';
import 'package:task_dropdown/models/multiple_item_model.dart';

class MultipleSelectBloc extends Bloc<MultipleSelectEvent, MultipleSelectState> {
  MultipleSelectBloc(List<MultipleItem> items)
      : super(MultipleSelectState(originalItems: items, displayedItems: items)) {

    on<ToggleItemEvent>((event, emit) {
      final updatedOriginalItems = _toggleItem(
          state.originalItems,
          event.item,
          isSelected: event.isSelected,
          recursive: event.recursive
      );

      List<MultipleItem> _updateDisplayedItems(
          List<MultipleItem> items,
          String query
          ) {
        if (query.isEmpty) return items;

        List<MultipleItem> searchRecursive(List<MultipleItem> items) {
          return items.where((item) {
            bool matchesCurrentItem = item.title.toLowerCase().contains(query);

            List<MultipleItem> matchedChildren =
            item.children.isNotEmpty
                ? searchRecursive(item.children)
                : [];

            return matchesCurrentItem || matchedChildren.isNotEmpty;
          }).map((item) {
            return item.copyWith(
                children: item.children.isNotEmpty
                    ? searchRecursive(item.children)
                    : [],
                isExpanded: true
            );
          }).toList();
        }

        return searchRecursive(items);
      }
      final updatedDisplayedItems = _updateDisplayedItems(
          updatedOriginalItems,
          state.searchQuery
      );

      emit(state.copyWith(
          originalItems: updatedOriginalItems,
          displayedItems: updatedDisplayedItems
      ));
    });

    on<ExpandItemEvent>((event, emit) {
      final updatedItems = _toggleExpand(state.displayedItems, event.item);
      emit(state.copyWith(originalItems: updatedItems,displayedItems: updatedItems));
    });

    on<SearchItemsEvent>((event, emit) {
      final query = event.query.toLowerCase();

      List<MultipleItem> searchRecursive(List<MultipleItem> items) {
        return items.where((item) {
          bool matchesCurrentItem = item.title.toLowerCase().contains(query);

          List<MultipleItem> matchedChildren =
          item.children.isNotEmpty
              ? searchRecursive(item.children)
              : [];

          if (matchesCurrentItem || matchedChildren.isNotEmpty) {
            return true;
          }

          return false;
        }).map((item) {
          return item.copyWith(
              children: item.children.isNotEmpty
                  ? searchRecursive(item.children)
                  : [],
              isExpanded: query.isNotEmpty
          );
        }).toList();
      }

      final searchResults = searchRecursive(state.originalItems);

      emit(state.copyWith(
          displayedItems: searchResults,
          searchQuery: query
      ));

      print('serach Res => $searchResults');
    });
  }

  List<MultipleItem> _toggleItem(
      List<MultipleItem> items,
      MultipleItem targetItem,
      {bool? isSelected, bool recursive = false}
      ) {
    return items.map((item) {
      if (item.id == targetItem.id) {
        bool newSelectedState = isSelected ?? !item.isSelected;

        if (recursive) {
          return _recursiveSelect(item, newSelectedState);
        } else {
          return item.copyWith(isSelected: newSelectedState);
        }
      }

      if (item.children.isNotEmpty) {
        return item.copyWith(
            children: _toggleItem(
                item.children,
                targetItem,
                isSelected: isSelected,
                recursive: recursive
            )
        );
      }

      return item;
    }).toList();
  }

  MultipleItem _recursiveSelect(MultipleItem item, bool isSelected) {
    return item.copyWith(
        isSelected: isSelected,
        children: item.children.map((child) =>
            _recursiveSelect(child, isSelected)
        ).toList()
    );
  }

  List<MultipleItem> _toggleExpand(
      List<MultipleItem> items,
      MultipleItem targetItem
      ) {
    return items.map((item) {
      if (item.id == targetItem.id) {
        return item.copyWith(isExpanded: !item.isExpanded);
      }

      if (item.children.isNotEmpty) {
        return item.copyWith(
            children: _toggleExpand(item.children, targetItem)
        );
      }

      return item;
    }).toList();
  }
}
