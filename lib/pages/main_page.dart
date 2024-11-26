import 'package:flutter/material.dart';
import 'package:task_dropdown/models/multiple_item_model.dart';
import 'package:task_dropdown/pages/multi_select_dropdown.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final List<MultipleItem> items = [
    MultipleItem(
        id: '1',
        title: 'Electronics',
        children: [
          MultipleItem(
              id: '1.1',
              title: 'Smartphones',
              children: [
                MultipleItem(id: '1.1.1', title: 'iPhone'),
                MultipleItem(id: '1.1.2', title: 'Samsung'),
                MultipleItem(id: '1.1.3', title: 'Redmi'),
              ]
          ),
          MultipleItem(
              id: '1.2',
              title: 'Laptops',
              children: [
                MultipleItem(id: '1.2.1', title: 'MacBook'),
                MultipleItem(id: '1.2.2', title: 'Dell'),
                MultipleItem(id: '1.2.3', title: 'Lenovo'),
              ]
          ),
        ]
    ),
    MultipleItem(
        id: '2',
        title: 'Home Appliances',
        children: [
          MultipleItem(id: '2.1', title: 'Fridge'),
          MultipleItem(id: '2.2', title: 'Washing Machine'),
          MultipleItem(id: '2.3', title: 'Microwave'),
        ]
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MultiSelectDropdown(items: items),
      ),
    );
  }
}
