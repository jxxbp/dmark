import 'package:dmark_test/domain/entities/stock.dart';

abstract class StockRepository {
  Future<List<StockEntity>> getAllStocks();
  Future<List<StockEntity>> getStocksByWarehouse(String warehouse);
  Future<StockEntity?> getStock(String warehouse, String gtin);
  Future<void> addOrUpdateStock(StockEntity stock);
  Future<void> decreaseStock(String id, int quantity);
  Future<void> deleteStock(String id);
  Future<int> getTotalQuantityByGtin(String gtin);
}
