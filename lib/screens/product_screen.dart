
import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/product_service.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductService _productService = ProductService();

  final TextEditingController _searchController =
      TextEditingController();
  final TextEditingController _minPriceController =
      TextEditingController();
  final TextEditingController _maxPriceController =
      TextEditingController();

  String? get _filterError {
    final minText = _minPriceController.text.trim();
    final maxText = _maxPriceController.text.trim();

    final min = minText.isEmpty ? null : double.tryParse(minText);
    final max = maxText.isEmpty ? null : double.tryParse(maxText);

    if (minText.isNotEmpty &&
        (min == null || !min.isFinite || min < 0)) {
      return 'Enter a valid non-negative minimum price.';
    }

    if (maxText.isNotEmpty &&
        (max == null || !max.isFinite || max < 0)) {
      return 'Enter a valid non-negative maximum price.';
    }

    if (min != null && max != null && min > max) {
      return 'Minimum price cannot exceed maximum price.';
    }

    return null;
  }

  List<Product> _filterProducts(List<Product> products) {
    final search = _searchController.text.trim().toLowerCase();

    final minText = _minPriceController.text.trim();
    final maxText = _maxPriceController.text.trim();

    final min = minText.isEmpty ? null : double.tryParse(minText);
    final max = maxText.isEmpty ? null : double.tryParse(maxText);

    if (_filterError != null) return [];

    return products.where((product) {
      final matchesName = product.name.toLowerCase().contains(search);

      final matchesMin = min == null || product.price >= min;
      final matchesMax = max == null || product.price <= max;

      return matchesName && matchesMin && matchesMax;
    }).toList();
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _minPriceController.clear();
      _maxPriceController.clear();
    });
  }

  Future<void> _showProductDialog({Product? product}) async {
    final formKey = GlobalKey<FormState>();

    final nameController = TextEditingController(
      text: product?.name ?? '',
    );

    final priceController = TextEditingController(
      text: product == null ? '' : product.price.toString(),
    );

    try {
      final shouldSave = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(
              product == null ? 'Add Product' : 'Edit Product',
            ),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Product name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Product name cannot be empty.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: priceController,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Price is required.';
                        }

                        final price = double.tryParse(value.trim());

                        if (price == null || !price.isFinite) {
                          return 'Enter a valid finite number.';
                        }

                        if (price < 0) {
                          return 'Price cannot be negative.';
                        }

                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext, false);
                },
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(dialogContext, true);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );

      if (shouldSave != true || !mounted) return;

      final name = nameController.text.trim();
      final price = double.parse(priceController.text.trim());

      if (product == null) {
        await _productService.addProduct(
          name: name,
          price: price,
        );
      } else {
        await _productService.updateProduct(
          id: product.id,
          name: name,
          price: price,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            product == null
                ? 'Product added successfully.'
                : 'Product updated successfully.',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Operation failed: $error')),
      );
    } finally {
      nameController.dispose();
      priceController.dispose();
    }
  }

  Future<void> _deleteProduct(Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Product?'),
          content: Text(
            'Are you sure you want to delete '
            '${product.name}?\n\nDocument ID: ${product.id}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    try {
      await _productService.deleteProduct(product.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product deleted successfully.')),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delete failed: $error')),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autumn Market'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showProductDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: 'Search products by name',
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                        });
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _minPriceController,
                        keyboardType:
                            const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          labelText: 'Minimum price',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _maxPriceController,
                        keyboardType:
                            const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          labelText: 'Maximum price',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_filterError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _filterError!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: _resetFilters,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset filters'),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: _productService.streamProducts(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error loading products: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final allProducts = snapshot.data ?? [];
                final filteredProducts = _filterProducts(allProducts);

                if (_filterError != null) {
                  return const Center(
                    child: Text('Correct the filter values to continue.'),
                  );
                }

                if (filteredProducts.isEmpty) {
                  return const Center(
                    child: Text('No products found.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 90,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(product.name[0].toUpperCase()),
                        ),
                        title: Text(product.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price: \$${product.price.toStringAsFixed(2)}',
                            ),
                            Text(
                              'ID: ${product.id}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall,
                            ),
                          ],
                        ),
                        isThreeLine: true,
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              _showProductDialog(product: product);
                            } else if (value == 'delete') {
                              _deleteProduct(product);
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
