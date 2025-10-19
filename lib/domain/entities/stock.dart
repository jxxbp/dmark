class StockEntity {
  final String id;
  final String warehouse;
  final String gtin;
  final int quantity;

  StockEntity({
    required this.id,
    required this.warehouse,
    required this.gtin,
    required this.quantity,
  });
}
