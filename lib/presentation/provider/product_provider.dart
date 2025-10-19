import 'package:dmark_test/data/services/product_service.dart';
import 'package:dmark_test/domain/entities/product.dart';
import 'package:flutter/material.dart';

enum SortType { byDate, byName }

class ProductProvider extends ChangeNotifier {
  final ProductService _service = ProductService();

  List<ProductEntity> _products = [];
  List<ProductEntity> _filteredProducts = [];
  SortType _sortType = SortType.byDate;
  String _searchQuery = '';

  List<ProductEntity> get products => _filteredProducts;
  SortType get sortType => _sortType;

  ProductProvider() {
    loadProducts();
  }

  /// Загрузить все товары
  Future<void> loadProducts() async {
    _products = await _service.getAllProducts();
    _applyFiltersAndSort();
  }

  /// Добавить новый товар
  Future<void> addProduct({
    required String name,
    required String gtin,
    required double price,
    String? imagePath,
  }) async {
    await _service.createProduct(
      name: name,
      gtin: gtin,
      price: price,
      imagePath: imagePath,
    );
    await loadProducts();
  }

  /// Обновить товар
  Future<void> updateProduct(ProductEntity product) async {
    final updated = ProductEntity(
      id: product.id,
      name: product.name,
      gtin: product.gtin,
      isActive: product.isActive,
      price: product.price,
      imagePath: product.imagePath,
      createdAt: product.createdAt,
      updatedAt: DateTime.now(),
      deletedAt: product.deletedAt,
    );
    await _service.updateProduct(updated);
    await loadProducts();
  }

  /// Удалить товар
  Future<void> deleteProduct(String id) async {
    await _service.deleteProduct(id);
    await loadProducts();
  }

  /// Поиск товара по GTIN
  Future<ProductEntity?> findByGtin(String gtin) {
    return _service.findByGtin(gtin);
  }

  /// Установить тип сортировки
  void setSortType(SortType type) {
    _sortType = type;
    _applyFiltersAndSort();
  }

  /// Поиск товаров
  void searchProducts(String query) {
    _searchQuery = query;
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    // Фильтрация
    if (_searchQuery.isEmpty) {
      _filteredProducts = List.from(_products);
    } else {
      _filteredProducts =
          _products
              .where(
                (p) =>
                    p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                    p.gtin.contains(_searchQuery),
              )
              .toList();
    }

    // Сортировка
    switch (_sortType) {
      case SortType.byDate:
        _filteredProducts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortType.byName:
        _filteredProducts.sort((a, b) => a.name.compareTo(b.name));
        break;
    }

    notifyListeners();
  }
}
