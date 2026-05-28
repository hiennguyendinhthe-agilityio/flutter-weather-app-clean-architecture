import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lesson_7.g.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Lesson7Screen(),
    );
  }
}

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void updateQuery(String newQuery) {
    state = newQuery;
  }
}

@riverpod
Future<List<String>> allProducts(Ref ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return [
    'iPhone 15 Pro Max',
    'Samsung Galaxy S24 Ultra',
    'MacBook Pro M3',
    'Dell XPS 15',
    'Sony PlayStation 5',
    'Nintendo Switch',
    'Apple Watch Series 9',
  ];
}

@riverpod
Future<List<String>> filteredProducts(Ref ref) async {
  final products = await ref.watch(allProductsProvider.future);

  final query = ref.watch(searchQueryProvider).toLowerCase();

  if (query.isEmpty) return products;

  return products.where((item) => item.toLowerCase().contains(query)).toList();
}

class Lesson7Screen extends ConsumerWidget {
  const Lesson7Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProducts = ref.watch(filteredProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lesson 7: Combining Providers'),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type product name to search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (text) {
                ref.read(searchQueryProvider.notifier).updateQuery(text);
              },
            ),
          ),
          Expanded(
            child: asyncProducts.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (items) {
                if (items.isEmpty) {
                  return const Center(child: Text('No products found!'));
                }
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.devices, color: Colors.indigo),
                      title: Text(items[index]),
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
