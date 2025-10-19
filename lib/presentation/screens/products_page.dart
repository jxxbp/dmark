import 'dart:io';

import 'package:dmark_test/presentation/provider/product_provider.dart';
import 'package:dmark_test/presentation/screens/add_product_page.dart';
import 'package:dmark_test/presentation/screens/product_detail_page.dart'
    show ProductDetailScreen;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        provider.searchProducts(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Поиск по названию или GTIN',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: SegmentedButton<SortType>(
                            segments: const [
                              ButtonSegment(
                                value: SortType.byDate,
                                label: Text('По дате'),
                              ),
                              ButtonSegment(
                                value: SortType.byName,
                                label: Text('По названию'),
                              ),
                            ],
                            selected: {provider.sortType},
                            onSelectionChanged: (Set<SortType> newSelection) {
                              provider.setSortType(newSelection.first);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child:
                    provider.products.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Нет товаров',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: provider.products.length,
                          itemBuilder: (context, index) {
                            final product = provider.products[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.blue[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child:
                                      product.imagePath != null
                                          ? Image.file(
                                            File(product.imagePath!),
                                            fit: BoxFit.cover,
                                          )
                                          : Icon(
                                            Icons.image_not_supported,
                                            color: Colors.blue[300],
                                          ),
                                ),
                                title: Text(product.name),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('GTIN: ${product.gtin}'),
                                    Text(
                                      '${product.price.toStringAsFixed(2)} ₸',
                                      style: TextStyle(
                                        color: Colors.green[600],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: PopupMenuButton(
                                  itemBuilder:
                                      (context) => [
                                        PopupMenuItem(
                                          child: const Text('Редактировать'),
                                          onTap: () {
                                            Future.delayed(
                                              const Duration(milliseconds: 300),
                                              () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder:
                                                        (_) =>
                                                            ProductDetailScreen(
                                                              product: product,
                                                            ),
                                                  ),
                                                );
                                              },
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
                                                product.id,
                                                product.name,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder:
                                          (_) => ProductDetailScreen(
                                            product: product,
                                          ),
                                    ),
                                  );
                                },
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
          ).push(MaterialPageRoute(builder: (_) => const AddProductScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String id, String name) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Удалить товар?'),
            content: Text('Вы уверены, что хотите удалить "$name"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: () {
                  context.read<ProductProvider>().deleteProduct(id);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Товар удалён')));
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
