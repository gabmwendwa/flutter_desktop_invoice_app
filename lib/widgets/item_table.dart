import 'package:flutter/material.dart';
import 'package:invoice/models/invoice_item_model.dart';
import 'package:invoice/widgets/build_table.dart';

class ItemTable extends StatelessWidget {
  final List<InvoiceItem> items;
  final VoidCallback onAddItem;
  final Function(int) onRemoveItem;
  final Function(int, String) onUpdateItemDescription;
  final Function(int, String) onUpdateItemQuantity;
  final Function(int, String) onUpdateItemUnit;
  final Function(int, String) onUpdateItemPrice;
  final Function(int, String) onUpdateItemVat;

  const ItemTable({
    super.key,
    required this.items,
    required this.onAddItem,
    required this.onRemoveItem,
    required this.onUpdateItemDescription,
    required this.onUpdateItemQuantity,
    required this.onUpdateItemUnit,
    required this.onUpdateItemPrice,
    required this.onUpdateItemVat,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildItemTableHeader(),
        ...items.asMap().entries.map((entry) {
          int index = entry.key;
          InvoiceItem item = entry.value;
          return _buildItemRow(index, item);
        }).toList(),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: onAddItem,
            icon: const Icon(
              Icons.add,
            ),
            label: const Text(
              "Add Item",
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemRow(int index, InvoiceItem item) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: TextField(
            decoration: InputDecoration(hintText: item.description),
            onChanged: (value) => onUpdateItemDescription(index, value),
          ),
        ),
        Expanded(
          flex: 1,
          child: TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(hintText: item.quantity.toString()),
            onChanged: (value) => onUpdateItemQuantity(index, value),
          ),
        ),
        Expanded(
          flex: 1,
          child: TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(hintText: item.unit.toString()),
            onChanged: (value) => onUpdateItemUnit(index, value),
          ),
        ),
        Expanded(
          flex: 1,
          child: TextField(
            textAlign: TextAlign.right,
            decoration: InputDecoration(hintText: item.price.toString()),
            onChanged: (value) => onUpdateItemPrice(index, value),
          ),
        ),
        Expanded(
          flex: 1,
          child: TextField(
            textAlign: TextAlign.right,
            decoration: InputDecoration(hintText: item.vat.toString()),
            onChanged: (value) => onUpdateItemVat(index, value),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            (item.quantity * item.price * (1 + item.vat / 100))
                .toStringAsFixed(2),
            textAlign: TextAlign.right,
          ),
        ),
        IconButton(
          onPressed: () => onRemoveItem(index),
          icon: const Icon(
            Icons.delete,
          ),
        ),
      ],
    );
  }
}
