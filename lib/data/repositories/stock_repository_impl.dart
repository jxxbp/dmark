import 'package:dmark_test/data/model/stock_model.dart' show Stock;
import 'package:dmark_test/domain/entities/stock.dart';
import 'package:dmark_test/domain/repositories/stock_repository.dart';
import 'package:hive/hive.dart';

class StockRepositoryImpl implements StockRepository {
  final Box<Stock> _stockBox = Hive.box<Stock>('stocks');

  @override
  Future<List<StockEntity>> getAllStocks() async {
    return _stockBox.values.map((s) => _mapToEntity(s)).toList();
  }

  @override
  Future<List<StockEntity>> getStocksByWarehouse(String warehouse) async {
    return _stockBox.values
        .where((s) => s.warehouse == warehouse)
        .map((s) => _mapToEntity(s))
        .toList();
  }

  @override
  Future<StockEntity?> getStock(String warehouse, String gtin) async {
    final stock = _stockBox.values.firstWhere(
      (s) => s.warehouse == warehouse && s.gtin == gtin,
      orElse: () => null as dynamic,
    );
    return stock != null ? _mapToEntity(stock) : null;
  }

  @override
  Future<void> addOrUpdateStock(StockEntity stock) async {
    final hiveStock = _mapToModel(stock);
    await _stockBox.put(stock.id, hiveStock);
  }

  @override
  Future<void> decreaseStock(String id, int quantity) async {
    final stock = _stockBox.get(id);
    if (stock != null) {
      if (stock.quantity < quantity) {
        throw Exception('Not enough stock available');
      }
      stock.quantity -= quantity;
      if (stock.quantity == 0) {
        await stock.delete();
      } else {
        await stock.save();
      }
    }
  }

  @override
  Future<void> deleteStock(String id) async {
    await _stockBox.delete(id);
  }

  @override
  Future<int> getTotalQuantityByGtin(String gtin) async {
    return _stockBox.values
        .where((s) => s.gtin == gtin)
        .fold<int>(0, (sum, stock) => sum + stock.quantity);
  }

  StockEntity _mapToEntity(Stock model) {
    return StockEntity(
      id: model.id,
      warehouse: model.warehouse,
      gtin: model.gtin,
      quantity: model.quantity,
    );
  }

  Stock _mapToModel(StockEntity entity) {
    return Stock(
      id: entity.id,
      warehouse: entity.warehouse,
      gtin: entity.gtin,
      quantity: entity.quantity,
    );
  }
}
