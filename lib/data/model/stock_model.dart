import 'package:hive/hive.dart';

part 'stock_model.g.dart';

@HiveType(typeId: 0)
class Stock {
  @HiveField(0)
  String id;

  @HiveField(1)
  String warehouse;

  @HiveField(2)
  String gtin;

  @HiveField(3)
  int quantity;

  Stock({
    required this.id,
    required this.warehouse,
    required this.gtin,
    required this.quantity,
  });

  delete() {}

  save() {}
}
