import 'package:dmark_test/domain/entities/product.dart';
import 'package:dmark_test/domain/repositories/product_repository.dart';

class ProductUseCases {
  final ProductRepository _repository;

  ProductUseCases(this._repository);

  Future<List<ProductEntity>> getAllProducts() {
    return _repository.getAllProducts();
  }

  Future<ProductEntity?> findByGtin(String gtin) {
    if (!_validateGtin(gtin)) {
      throw Exception('Invalid GTIN format');
    }
    return _repository.getProductByGtin(gtin);
  }

  Future<void> createProduct({
    required String name,
    required String gtin,
    required double price,
    String? imagePath,
  }) {
    if (!_validateGtin(gtin)) {
      throw Exception('GTIN must be 13 digits');
    }

    final product = ProductEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      gtin: gtin,
      isActive: true,
      price: price,
      imagePath: imagePath,
      createdAt: DateTime.now(),
    );

    return _repository.addProduct(product);
  }

  Future<void> updateProduct(ProductEntity product) {
    if (!_validateGtin(product.gtin)) {
      throw Exception('Invalid GTIN format');
    }
    return _repository.updateProduct(product);
  }

  Future<void> deleteProduct(String id) {
    return _repository.deleteProduct(id);
  }

  Future<List<ProductEntity>> searchProducts(String query) {
    return _repository.searchProducts(query);
  }

  bool _validateGtin(String gtin) {
    return gtin.length == 13 && RegExp(r'^\d+$').hasMatch(gtin);
  }
}
