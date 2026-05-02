// lib/screens/search/search_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/products_provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/product.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';
import '../../widgets/product_photo.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Product> _matches(List<Product> all, String q) {
    if (q.trim().isEmpty) return all;
    final lower = q.toLowerCase();
    return all
        .where(
          (p) =>
              p.name.toLowerCase().contains(lower) ||
              p.category.toLowerCase().contains(lower),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productsProvider);
    final results = _matches(products, _controller.text);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: AppStrings.searchProducts,
            border: InputBorder.none,
          ),
          onChanged: (_) => setState(() {}),
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              onPressed: () => setState(() => _controller.clear()),
              icon: const Icon(Icons.close_rounded),
            ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSizes.md),
        itemCount: results.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
        itemBuilder: (context, index) {
          final p = results[index];
          return Material(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            clipBehavior: Clip.antiAlias,
            elevation: 0.5,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
              onTap: () => context.push('/products/${p.id}'),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: ProductPhoto(
                    product: p,
                    width: 56,
                    height: 56,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    iconSize: 26,
                  ),
                ),
              ),
              title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('${p.category} · from Rs. ${p.currentLowestPrice.toStringAsFixed(0)}'),
              trailing: IconButton.filledTonal(
                onPressed: () {
                  ref.read(cartProvider.notifier).addProduct(p);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text('${p.name} ${AppStrings.addedToCart}'),
                    ),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart_rounded, size: 20),
              ),
            ),
          );
        },
      ),
    );
  }
}
