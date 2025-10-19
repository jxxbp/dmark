import 'package:dmark_test/data/services/stock_service.dart';
import 'package:dmark_test/domain/entities/stock.dart';
import 'package:flutter/material.dart';

class StockProvider extends ChangeNotifier {
  final StockService _service = StockService();

  List<StockEntity> _stocks = [];
  List<StockEntity> _filteredStocks = [];
  String? _selectedWarehouse;
  Map<String, int> _totalByGtin = {};

  List<StockEntity> get stocks => _filteredStocks;
  String? get selectedWarehouse => _selectedWarehouse;
  Set<String> get warehouses => _stocks.map((s) => s.warehouse).toSet();
  Map<String, int> get totalByGtin => _totalByGtin;

  StockProvider() {
    loadStocks();
  }

  /// Загрузить все остатки
  Future<void> loadStocks() async {
    _stocks = await _service.getAllStocks();
    await _calculateTotals();
    _applyFilter();
  }

  /// Добавить или обновить остатки
  Future<void> addOrUpdateStock({
    required String warehouse,
    required String gtin,
    required int quantity,
  }) async {
    await _service.addOrUpdateStock(
      warehouse: warehouse,
      gtin: gtin,
      quantity: quantity,
    );
    await loadStocks();
  }

  /// Уменьшить остатки
  Future<void> decreaseStock(String id, int quantity) async {
    await _service.decreaseStock(id, quantity);
    await loadStocks();
  }

  /// Удалить остатки
  Future<void> deleteStock(String id) async {
    await _service.deleteStock(id);
    await loadStocks();
  }

  /// Установить фильтр по складу
  void setWarehouseFilter(String? warehouse) {
    _selectedWarehouse = warehouse;
    _applyFilter();
  }

  /// Получить общее количество по GTIN
  int getTotalQuantity(String gtin) {
    return _totalByGtin[gtin] ?? 0;
  }

  /// Применить фильтр
  void _applyFilter() {
    if (_selectedWarehouse == null) {
      _filteredStocks = List.from(_stocks);
    } else {
      _filteredStocks =
          _stocks.where((s) => s.warehouse == _selectedWarehouse).toList();
    }
    notifyListeners();
  }

  /// Рассчитать общие количества
  Future<void> _calculateTotals() async {
    _totalByGtin.clear();
    for (var stock in _stocks) {
      _totalByGtin[stock.gtin] =
          (_totalByGtin[stock.gtin] ?? 0) + stock.quantity;
    }
  }
}
