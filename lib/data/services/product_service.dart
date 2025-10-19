import 'package:dmark_test/data/repositories/product_repository_impl.dart';
import 'package:dmark_test/domain/entities/product.dart';
import 'package:dmark_test/domain/use_cases/product_usecases.dart';

class ProductService {
  late final ProductUseCases _useCases;

  ProductService() {
    _useCases = ProductUseCases(ProductRepositoryImpl());
  }

  Future<List<ProductEntity>> getAllProducts() => _useCases.getAllProducts();

  Future<ProductEntity?> findByGtin(String gtin) => _useCases.findByGtin(gtin);

  Future<void> createProduct({
    required String name,
    required String gtin,
    required double price,
    String? imagePath,
  }) => _useCases.createProduct(
    name: name,
    gtin: gtin,
    price: price,
    imagePath: imagePath,
  );

  Future<void> updateProduct(ProductEntity product) =>
      _useCases.updateProduct(product);

  Future<void> deleteProduct(String id) => _useCases.deleteProduct(id);

  Future<List<ProductEntity>> searchProducts(String query) =>
      _useCases.searchProducts(query);
}
