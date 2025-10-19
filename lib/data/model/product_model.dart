import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class Product {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String gtin;

  @HiveField(3)
  bool isActive;

  @HiveField(4)
  double price;

  @HiveField(5)
  String? imagePath;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  DateTime? updatedAt;

  @HiveField(8)
  DateTime? deletedAt;

  Product({
    required this.id,
    required this.name,
    required this.gtin,
    required this.isActive,
    required this.price,
    this.imagePath,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  save() {}
}
