import 'package:dmark_test/data/model/product_model.dart';
import 'package:dmark_test/domain/entities/product.dart';
import 'package:dmark_test/domain/repositories/product_repository.dart';
import 'package:hive/hive.dart';

class ProductRepositoryImpl implements ProductRepository {
  final Box<Product> _productBox = Hive.box<Product>('products');

  @override
  Future<List<ProductEntity>> getAllProducts() async {
    return _productBox.values.map((p) => _mapToEntity(p)).toList();
  }

  @override
  Future<ProductEntity?> getProductByGtin(String gtin) async {
    final product = _productBox.values.firstWhere(
      (p) => p.gtin == gtin,
      orElse: () => null as dynamic,
    );
    return product != null ? _mapToEntity(product) : null;
  }

  @override
  Future<void> addProduct(ProductEntity product) async {
    final hiveProduct = _mapToModel(product);
    await _productBox.put(product.id, hiveProduct);
  }

  @override
  Future<void> updateProduct(ProductEntity product) async {
    final hiveProduct = _mapToModel(product);
    await _productBox.put(product.id, hiveProduct);
  }

  @override
  Future<void> deleteProduct(String id) async {
    final product = _productBox.get(id);
    if (product != null) {
      product.isActive = false;
      product.deletedAt = DateTime.now();
      await product.save();
    }
  }

  @override
  Future<List<ProductEntity>> searchProducts(String query) async {
    final lowerQuery = query.toLowerCase();
    return _productBox.values
        .where(
          (p) =>
              p.name.toLowerCase().contains(lowerQuery) ||
              p.gtin.contains(query),
        )
        .map((p) => _mapToEntity(p))
        .toList();
  }

  ProductEntity _mapToEntity(Product model) {
    return ProductEntity(
      id: model.id,
      name: model.name,
      gtin: model.gtin,
      isActive: model.isActive,
      price: model.price,
      imagePath: model.imagePath,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      deletedAt: model.deletedAt,
    );
  }

  Product _mapToModel(ProductEntity entity) {
    return Product(
      id: entity.id,
      name: entity.name,
      gtin: entity.gtin,
      isActive: entity.isActive,
      price: entity.price,
      imagePath: entity.imagePath,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      deletedAt: entity.deletedAt,
    );
  }
}
