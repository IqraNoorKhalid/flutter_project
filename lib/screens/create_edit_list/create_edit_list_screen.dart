// lib/screens/create_edit_list/create_edit_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/lists_provider.dart';
import '../../models/shopping_list.dart';
import '../../models/shopping_item.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

class CreateEditListScreen extends ConsumerStatefulWidget {
  final String? listId;

  const CreateEditListScreen({super.key, this.listId});

  @override
  ConsumerState<CreateEditListScreen> createState() => _CreateEditListScreenState();
}

class _CreateEditListScreenState extends ConsumerState<CreateEditListScreen> {
  final _formKey = GlobalKey<FormState>();
  final _listNameController = TextEditingController();
  String _selectedTag = 'Essentials';
  final List<ShoppingItem> _items = [];
  final _itemNameController = TextEditingController();
  double _quantity = 1;
  String _unit = 'pcs';
  bool _isEditing = false;

  final List<String> _tags = ['Essentials', 'Weekly', 'Party', 'Office', 'Ramadan'];
  final List<String> _units = ['pcs', 'kg', 'g', 'L', 'ml', 'dozen', 'pack'];

  @override
  void initState() {
    super.initState();
    if (widget.listId != null) {
      _loadListData();
    }
  }

  void _loadListData() {
    final lists = ref.read(listsProvider);
    final list = lists.firstWhere((l) => l.id == widget.listId);
    _listNameController.text = list.name;
    _selectedTag = list.tags.first;
    _items.addAll(list.items);
    _isEditing = true;
  }

  void _addItem() {
    if (_itemNameController.text.isNotEmpty) {
      setState(() {
        _items.add(ShoppingItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: _itemNameController.text,
          quantity: _quantity,
          unit: _unit,
          isChecked: false,
          lowestPrice: 0,
          bestStore: '',
        ));
        _itemNameController.clear();
        _quantity = 1;
        _unit = 'pcs';
      });
    }
  }

  void _removeItem(String itemId) {
    setState(() {
      _items.removeWhere((item) => item.id == itemId);
    });
  }

  void _saveList() {
    if (_formKey.currentState!.validate() && _items.isNotEmpty) {
      final list = ShoppingList(
        id: _isEditing ? widget.listId! : DateTime.now().millisecondsSinceEpoch.toString(),
        name: _listNameController.text,
        createdAt: DateTime.now(),
        tags: [_selectedTag],
        isCompleted: false,
        items: _items,
      );

      final notifier = ref.read(listsProvider.notifier);
      if (_isEditing) {
        notifier.updateList(list);
      } else {
        notifier.addList(list);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? AppStrings.listUpdated : AppStrings.listCreated)),
      );
      context.go('/lists');
    } else if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one item')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(_isEditing ? AppStrings.editList : AppStrings.createList),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.md),
          children: [
            Text(
              'List details',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSizes.sm),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _listNameController,
                      decoration: const InputDecoration(
                        labelText: AppStrings.listName,
                      ),
                      validator: (value) => value!.isEmpty ? 'Please enter list name' : null,
                    ),
                    const SizedBox(height: AppSizes.md),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedTag,
                      decoration: const InputDecoration(
                        labelText: 'Category tag',
                      ),
                      items: _tags.map((tag) {
                        return DropdownMenuItem(value: tag, child: Text(tag));
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedTag = value!),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Items',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                Text(
                  '${_items.length} added',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _itemNameController,
                      decoration: const InputDecoration(
                        hintText: AppStrings.itemName,
                        labelText: AppStrings.itemName,
                      ),
                    ),
                    const SizedBox(height: AppSizes.md),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: '1',
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: AppStrings.quantity,
                            ),
                            onChanged: (value) => _quantity = double.tryParse(value) ?? 1,
                          ),
                        ),
                        const SizedBox(width: AppSizes.sm),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _unit,
                            decoration: const InputDecoration(labelText: 'Unit'),
                            items: _units.map((unit) {
                              return DropdownMenuItem(value: unit, child: Text(unit));
                            }).toList(),
                            onChanged: (value) => setState(() => _unit = value!),
                          ),
                        ),
                        const SizedBox(width: AppSizes.sm),
                        IconButton.filled(
                          onPressed: _addItem,
                          icon: const Icon(Icons.add_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            if (_items.isNotEmpty)
              ..._items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.sm),
                  child: Material(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.5)),
                      ),
                      title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text('${item.quantity} ${item.unit}'),
                      trailing: IconButton(
                        onPressed: () => _removeItem(item.id),
                        icon: const Icon(Icons.close_rounded, color: AppColors.error),
                      ),
                    ),
                  ),
                );
              }),
            const SizedBox(height: AppSizes.xl),
            FilledButton(
              onPressed: _saveList,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(_isEditing ? 'Update list' : AppStrings.saveList),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _listNameController.dispose();
    _itemNameController.dispose();
    super.dispose();
  }
}
