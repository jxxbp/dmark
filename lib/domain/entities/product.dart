class ProductEntity {
  final String id;
  final String name;
  final String gtin;
  final bool isActive;
  final double price;
  final String? imagePath;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  ProductEntity({
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

  ProductEntity copyWith({
    String? id,
    String? name,
    String? gtin,
    bool? isActive,
    double? price,
    String? imagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      gtin: gtin ?? this.gtin,
      isActive: isActive ?? this.isActive,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
