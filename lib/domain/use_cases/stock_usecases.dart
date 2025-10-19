import 'package:dmark_test/domain/entities/stock.dart';
import 'package:dmark_test/domain/repositories/stock_repository.dart';

class StockUseCases {
  final StockRepository _repository;

  StockUseCases(this._repository);

  Future<List<StockEntity>> getAllStocks() {
    return _repository.getAllStocks();
  }

  Future<List<StockEntity>> getStocksByWarehouse(String warehouse) {
    return _repository.getStocksByWarehouse(warehouse);
  }

  Future<void> addOrUpdateStock({
    required String warehouse,
    required String gtin,
    required int quantity,
  }) async {
    if (quantity <= 0) {
      throw Exception('Quantity must be positive');
    }

    final existingStock = await _repository.getStock(warehouse, gtin);

    if (existingStock != null) {
      final updatedStock = StockEntity(
        id: existingStock.id,
        warehouse: warehouse,
        gtin: gtin,
        quantity: existingStock.quantity + quantity,
      );
      return _repository.addOrUpdateStock(updatedStock);
    } else {
      final newStock = StockEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        warehouse: warehouse,
        gtin: gtin,
        quantity: quantity,
      );
      return _repository.addOrUpdateStock(newStock);
    }
  }

  Future<void> decreaseStock(String id, int quantity) {
    if (quantity <= 0) {
      throw Exception('Quantity must be positive');
    }
    return _repository.decreaseStock(id, quantity);
  }

  Future<void> deleteStock(String id) {
    return _repository.deleteStock(id);
  }

  Future<int> getTotalQuantityByGtin(String gtin) {
    return _repository.getTotalQuantityByGtin(gtin);
  }
}
