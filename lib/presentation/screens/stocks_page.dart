import 'package:dmark_test/presentation/provider/stock_provider.dart';
import 'package:dmark_test/presentation/screens/add_stock_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StocksScreen extends StatefulWidget {
  const StocksScreen({super.key});

  @override
  State<StocksScreen> createState() => _StocksScreenState();
}

class _StocksScreenState extends State<StocksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<StockProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Фильтр по складам',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilterChip(
                            label: const Text('Все'),
                            selected: provider.selectedWarehouse == null,
                            onSelected: (_) {
                              provider.setWarehouseFilter(null);
                            },
                          ),
                          const SizedBox(width: 8),
                          ...provider.warehouses.map((warehouse) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(warehouse),
                                selected:
                                    provider.selectedWarehouse == warehouse,
                                onSelected: (_) {
                                  provider.setWarehouseFilter(warehouse);
                                },
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child:
                    provider.stocks.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.warehouse_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Нет остатков',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: provider.stocks.length,
                          itemBuilder: (context, index) {
                            final stock = provider.stocks[index];
                            final total = provider.getTotalQuantity(stock.gtin);
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                title: Text('GTIN: ${stock.gtin}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Склад: ${stock.warehouse}'),
                                    Text(
                                      'Количество: ${stock.quantity}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Всего по GTIN: $total',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: PopupMenuButton(
                                  itemBuilder:
                                      (context) => [
                                        PopupMenuItem(
                                          child: const Text('Уменьшить'),
                                          onTap: () {
                                            Future.delayed(
                                              const Duration(milliseconds: 300),
                                              () => _showDecreaseDialog(
                                                context,
                                                stock.id,
                                                stock.quantity,
                                              ),
                                            );
                                          },
                                        ),
                                        PopupMenuItem(
                                          child: const Text(
                                            'Удалить',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          onTap: () {
                                            Future.delayed(
                                              const Duration(milliseconds: 300),
                                              () => _showDeleteDialog(
                                                context,
                                                stock.id,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const AddStockScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDecreaseDialog(BuildContext context, String id, int currentQty) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Уменьшить количество'),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Количество (максимум $currentQty)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: () {
                  final qty = int.tryParse(controller.text);
                  if (qty == null || qty <= 0 || qty > currentQty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Неверное количество')),
                    );
                    return;
                  }
                  context.read<StockProvider>().decreaseStock(id, qty);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Количество уменьшено')),
                  );
                },
                child: const Text('Уменьшить'),
              ),
            ],
          ),
    );
  }

  void _showDeleteDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Удалить остатки?'),
            content: const Text('Это действие нельзя отменить'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: () {
                  context.read<StockProvider>().deleteStock(id);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Остатки удалены')),
                  );
                },
                child: const Text(
                  'Удалить',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
