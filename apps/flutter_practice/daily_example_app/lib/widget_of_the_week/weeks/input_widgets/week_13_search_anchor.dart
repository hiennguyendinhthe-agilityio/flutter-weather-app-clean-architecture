import 'package:flutter/material.dart';

class Week13SearchAnchor extends StatefulWidget {
  const Week13SearchAnchor({super.key});

  @override
  State<Week13SearchAnchor> createState() => _Week13SearchAnchorState();
}

class _Week13SearchAnchorState extends State<Week13SearchAnchor> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _allItems = [
    'Apple', 'Banana', 'Cherry', 'Date', 'Elderberry', 'Fig', 'Grape',
    'Honeydew', 'Kiwi', 'Lemon', 'Mango', 'Orange', 'Papaya', 'Quince',
    'Raspberry', 'Strawberry', 'Tangerine', 'Watermelon', 'Blueberry',
    'Pineapple', 'Coconut', 'Avocado', 'Peach', 'Plum', 'Apricot'
  ];
  
  List<String> _filteredItems = [];
  bool _isSearchBarEnabled = true;
  bool _showSuggestions = true;

  @override
  void initState() {
    super.initState();
    _filteredItems = _allItems;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Week 13: Search & SearchAnchor'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTheorySection(),
            const SizedBox(height: 24),
            _buildInteractiveDemo(),
            const SizedBox(height: 24),
            _buildExamples(),
            const SizedBox(height: 24),
          
          ],
        ),
      ),
    );
  }

  Widget _buildTheorySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📚 Theory: Search & SearchAnchor',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'SearchAnchor provides a Material Design search interface that can display '
              'search suggestions and handle search queries. It\'s perfect for implementing '
              'search functionality with autocomplete and filtering.',
            ),
            const SizedBox(height: 12),
            const Text(
              '🔑 Important properties:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• builder: Builds the search anchor widget'),
            const Text('• suggestionsBuilder: Builds search suggestions'),
            const Text('• searchController: Controls the search text'),
            const Text('• isFullScreen: Whether to show full-screen search'),
            const Text('• viewHintText: Hint text in the search field'),
            const SizedBox(height: 12),
            const Text(
              '💡 Best for search bars, autocomplete, and filtering interfaces!',
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.orange),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveDemo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🎮 Interactive Demo',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            
            // Controls
            SwitchListTile(
              title: const Text('Enable Search Bar'),
              value: _isSearchBarEnabled,
              onChanged: (value) => setState(() => _isSearchBarEnabled = value),
            ),
            
            SwitchListTile(
              title: const Text('Show Suggestions'),
              value: _showSuggestions,
              onChanged: (value) => setState(() => _showSuggestions = value),
            ),
            
            const SizedBox(height: 16),
            
            // SearchAnchor Demo
            if (_isSearchBarEnabled) ...[
              if (_showSuggestions)
                SearchAnchor(
                  viewHintText: 'Search fruits...',
                  suggestionsBuilder: (BuildContext context, SearchController controller) {
                    final query = controller.text.toLowerCase();
                    if (query.isEmpty) {
                      return _allItems.take(5).map((item) => 
                        ListTile(
                          leading: const Icon(Icons.search),
                          title: Text(item),
                          onTap: () {
                            controller.closeView(item);
                            _performSearch(item);
                            _searchController.text = item;
                          },
                        ),
                      );
                    }
                    
                    final suggestions = _allItems
                        .where((item) => item.toLowerCase().contains(query))
                        .take(10);
                        
                    return suggestions.map((item) => 
                      ListTile(
                        leading: const Icon(Icons.search),
                        title: RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: _highlightMatch(item, query),
                          ),
                        ),
                        onTap: () {
                          controller.closeView(item);
                          _performSearch(item);
                          _searchController.text = item;
                        },
                      ),
                    );
                  },
                  builder: (BuildContext context, SearchController controller) {
                    return SearchBar(
                      controller: _searchController,
                      padding: const WidgetStatePropertyAll<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      onTap: () {
                        controller.openView();
                      },
                      onChanged: (query) {
                        _performSearch(query);
                        setState(() {
                        });
                      },
                      leading: const Icon(Icons.search),
                      trailing: <Widget>[
                        Tooltip(
                          message: 'Clear search',
                          child: IconButton(
                            onPressed: () {
                              _searchController.clear();
                              _performSearch('');
                              setState(() {
                              });
                            },
                            icon: const Icon(Icons.clear),
                          ),
                        )
                      ],
                      hintText: 'Search fruits...',
                    );
                  },
                )
              else
                // Simple SearchBar without suggestions
                SearchBar(
                  controller: _searchController,
                  padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  onChanged: (query) {
                    _performSearch(query);
                    setState(() {
                    });
                  },
                  leading: const Icon(Icons.search),
                  trailing: <Widget>[
                    Tooltip(
                      message: 'Clear search',
                      child: IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                          setState(() {
                          });
                        },
                        icon: const Icon(Icons.clear),
                      ),
                    )
                  ],
                  hintText: 'Search fruits...',
                ),
            ],
            
            const SizedBox(height: 20),
            
            // Results
            Text(
              'Search Results (${_filteredItems.length} items):',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _filteredItems.isEmpty
                  ? const Center(
                      child: Text(
                        'No results found',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.teal.shade100,
                            child: Text(
                              item[0],
                              style: TextStyle(
                                color: Colors.teal.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(item),
                          subtitle: Text('Fruit #${index + 1}'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _performSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = _allItems;
      } else {
        _filteredItems = _allItems
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  List<TextSpan> _highlightMatch(String text, String query) {
    if (query.isEmpty) return [TextSpan(text: text)];
    
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final spans = <TextSpan>[];
    
    int start = 0;
    int index = lowerText.indexOf(lowerQuery);
    
    while (index != -1) {
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }
      
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.yellow,
        ),
      ));
      
      start = index + query.length;
      index = lowerText.indexOf(lowerQuery, start);
    }
    
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }
    
    return spans;
  }

  Widget _buildExamples() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '💡 Real Examples',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 16),
            
            // App Bar Search Example
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Example 1: App Bar Search',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Integrated search in app bar with suggestions'),
                  const SizedBox(height: 12),
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(width: 16),
                        Icon(Icons.menu, color: Colors.white),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Search products...',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                        Icon(Icons.search, color: Colors.white),
                        SizedBox(width: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Contact Search Example
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Example 2: Contact Search',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Search contacts with name and phone filtering'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey),
                        SizedBox(width: 12),
                        Text(
                          'Search contacts...',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // E-commerce Search Example
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Example 3: E-commerce Search',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Product search with categories and filters'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.search, color: Colors.grey),
                              SizedBox(width: 12),
                              Text(
                                'Search products...',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.filter_list, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}