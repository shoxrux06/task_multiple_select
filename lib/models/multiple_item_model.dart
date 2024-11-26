class MultipleItem {
  final String id;
  final String title;
  final List<MultipleItem> children;
  bool isSelected;
  bool isExpanded;

  MultipleItem({
    required this.id,
    required this.title,
    this.children = const [],
    this.isSelected = false,
    this.isExpanded = false,
  });

  MultipleItem copyWith({
    bool? isSelected,
    bool? isExpanded,
    List<MultipleItem>? children,
  }) {
    return MultipleItem(
      id: id,
      title: title,
      children: children ?? this.children,
      isSelected: isSelected ?? this.isSelected,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  @override
  String toString() {
    return 'HierarchicalItem{id: $id, title: $title, children: $children, isSelected: $isSelected, isExpanded: $isExpanded}';
  }
}