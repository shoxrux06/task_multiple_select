import 'package:task_dropdown/models/multiple_item_model.dart';

abstract class MultipleSelectEvent {}

class ToggleItemEvent extends MultipleSelectEvent {
  final MultipleItem item;
  final bool? isSelected;
  final bool recursive;

  ToggleItemEvent(this.item, {this.isSelected, this.recursive = false});
}

class ExpandItemEvent extends MultipleSelectEvent {
  final MultipleItem item;

  ExpandItemEvent(this.item);
}

class ConfirmSelectionEvent extends MultipleSelectEvent {}

class SearchItemsEvent extends MultipleSelectEvent {
  final String query;

  SearchItemsEvent(this.query);
}