class InvoiceItem {
  String description;
  int quantity;
  String unit;
  double price;
  double vat;

  InvoiceItem({
    required this.description,
    required this.quantity,
    required this.unit,
    required this.price,
    required this.vat,
  });
}
