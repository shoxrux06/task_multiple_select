import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_dropdown/bloc/multiple_select_event.dart';
import 'package:task_dropdown/bloc/multiple_select_bloc.dart';
import 'package:task_dropdown/bloc/multiple_select_state.dart';
import 'package:task_dropdown/models/multiple_item_model.dart';

class MultiSelectDropdown extends StatelessWidget {
  final List<MultipleItem> items;

  const MultiSelectDropdown({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MultipleSelectBloc(items),
      child: Builder(
        builder: (context) => ElevatedButton(
          onPressed: () => _showHierarchicalDropdown(context),
          child: const Text('Select Multiple Items'),
        ),
      ),
    );
  }

  void _showHierarchicalDropdown(BuildContext context) {
    final searchController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: BlocProvider.of<MultipleSelectBloc>(context),
          child: AlertDialog(
            title: const Text('Select Multiple Items'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search items...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        context.read<MultipleSelectBloc>().add(
                            SearchItemsEvent('')
                        );
                      },
                    )
                        : null,
                  ),
                  onChanged: (value) {
                    context.read<MultipleSelectBloc>().add(
                        SearchItemsEvent(value)
                    );
                  },
                ),
                const SizedBox(height: 10),
                BlocBuilder<MultipleSelectBloc, MultipleSelectState>(
                  builder: (context, state) {
                    print('Org items => ${state.originalItems}');
                    print('Dis items => ${state.displayedItems}');
                    return SizedBox(
                      width: double.maxFinite,
                      height: 400,
                      child: _buildHierarchicalList(
                          context,
                          state.displayedItems
                      ),
                    );
                  },
                ),
              ],
            ),
            actions: [
              BlocBuilder<MultipleSelectBloc, MultipleSelectState>(
                builder: (context, state) {
                  final selectedItems = state.getSelectedItems();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (selectedItems.isNotEmpty)
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            _showConfirmationDialog(context, selectedItems);
                          },
                          child: Text('Confirm (${selectedItems.length})'),
                        ),
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: const Text('Cancel'),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildHierarchicalList(BuildContext context, List<MultipleItem> items) {
    return ListView(
      shrinkWrap: true,
      children: items.map((item) =>
          _buildHierarchicalItem(context, item)
      ).toList(),
    );
  }

  Widget _buildHierarchicalItem(BuildContext context, MultipleItem item, {int depth = 0}) {
    print('children items => ${item.children}');
    print('children isExpanded => ${item.isExpanded}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (item.children.isNotEmpty)
              IconButton(
                icon: Icon(item.isExpanded
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_right
                ),
                onPressed: () {
                  context.read<MultipleSelectBloc>().add(
                      ExpandItemEvent(item)
                  );
                },
              ),

            Expanded(
              child: CheckboxListTile(
                title: Text(item.title),
                value: item.isSelected,
                onChanged: (bool? selected) {
                  context.read<MultipleSelectBloc>().add(
                      ToggleItemEvent(
                          item,
                          isSelected: selected,
                          recursive: true
                      )
                  );
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
          ],
        ),

        if (item.isExpanded && item.children.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(left: depth * 20.0 + 40),
            child: Column(
              children: item.children.map((child) =>
                  _buildHierarchicalItem(context, child, depth: depth + 1)
              ).toList(),
            ),
          ),
      ],
    );
  }

  void _showConfirmationDialog(BuildContext context, List<MultipleItem> selectedItems) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selection Confirmed'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: selectedItems.map((item) => Text(item.title)).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }
}
