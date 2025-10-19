import 'package:dmark_test/data/repositories/stock_repository_impl.dart';
import 'package:dmark_test/domain/entities/stock.dart';
import 'package:dmark_test/domain/use_cases/stock_usecases.dart';

class StockService {
  late final StockUseCases _useCases;

  StockService() {
    _useCases = StockUseCases(StockRepositoryImpl());
  }

  Future<List<StockEntity>> getAllStocks() => _useCases.getAllStocks();

  Future<List<StockEntity>> getStocksByWarehouse(String warehouse) =>
      _useCases.getStocksByWarehouse(warehouse);

  Future<void> addOrUpdateStock({
    required String warehouse,
    required String gtin,
    required int quantity,
  }) => _useCases.addOrUpdateStock(
    warehouse: warehouse,
    gtin: gtin,
    quantity: quantity,
  );

  Future<void> decreaseStock(String id, int quantity) =>
      _useCases.decreaseStock(id, quantity);

  Future<void> deleteStock(String id) => _useCases.deleteStock(id);

  Future<int> getTotalQuantityByGtin(String gtin) =>
      _useCases.getTotalQuantityByGtin(gtin);
}
