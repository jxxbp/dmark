import 'package:dmark_test/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getAllProducts();
  Future<ProductEntity?> getProductByGtin(String gtin);
  Future<void> addProduct(ProductEntity product);
  Future<void> updateProduct(ProductEntity product);
  Future<void> deleteProduct(String id);
  Future<List<ProductEntity>> searchProducts(String query);
}
