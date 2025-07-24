import 'package:flutter/material.dart';

class Week07ListView extends StatefulWidget {
  const Week07ListView({super.key});

  @override
  State<Week07ListView> createState() => _Week07ListViewState();
}

class _Week07ListViewState extends State<Week07ListView> {
  final ScrollController _scrollController = ScrollController();
  final List<String> _items = List.generate(20, (index) => 'Item ${index + 1}');
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMore();
    }
  }

  void _loadMore() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    // Simulate loading
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _items.addAll(
        List.generate(10, (index) => 'Item ${_items.length + index + 1}'),
      );
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Week 07: ListView Widget'),
        backgroundColor: Colors.purple,
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
            _buildExercises(),
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
              '📚 Theory: ListView Widget',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'ListView is a widget for displaying a scrollable list. '
              'It\'s very efficient for long lists because it only renders the items visible on the screen.',
            ),
            const SizedBox(height: 12),
            const Text(
              '🔑 Types of ListView:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• ListView(): Creates from a fixed list of children.'),
            const Text(
              '• ListView.builder(): Creates items on demand (efficient).',
            ),
            const Text(
              '• ListView.separated(): Has a separator between items.',
            ),
            const Text('• ListView.custom(): Fully customizable.'),
            const SizedBox(height: 12),
            const Text(
              '⚡ Performance Tips:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('• Use ListView.builder for long lists.'),
            const Text('• Set itemExtent if item height is known.'),
            const Text('• Use const for unchanging items.'),
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

            // Demo tabs
            DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: Colors.purple,
                    tabs: [
                      Tab(text: 'Basic'),
                      Tab(text: 'Builder'),
                      Tab(text: 'Separated'),
                    ],
                  ),
                  SizedBox(
                    height: 300,
                    child: TabBarView(
                      children: [
                        _buildBasicListView(),
                        _buildBuilderListView(),
                        _buildSeparatedListView(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicListView() {
    return ListView(
      children: const [
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Home'),
          subtitle: Text('Go to home page'),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          subtitle: Text('App settings'),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Profile'),
          subtitle: Text('User profile'),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
        ListTile(
          leading: Icon(Icons.help),
          title: Text('Help'),
          subtitle: Text('Get help'),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ],
    );
  }

  Widget _buildBuilderListView() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _items.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _items.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.purple,
                    child: Text('${index + 1}'),
                  ),
                  title: Text(_items[index]),
                  subtitle: Text('Description for ${_items[index]}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _items.removeAt(index);
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _items.add('New Item ${_items.length + 1}');
              });
            },
            child: const Text('Add Item'),
          ),
        ),
      ],
    );
  }

  Widget _buildSeparatedListView() {
    final colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
    ];

    return ListView.separated(
      itemCount: 15,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final color = colors[index % colors.length];
        return ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(Icons.star, color: Colors.white),
          ),
          title: Text('Item $index'),
          subtitle: Text('This is item number $index'),
          onTap: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Tapped on Item $index')));
          },
        );
      },
    );
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

            // Chat list example
            const Text(
              'Chat List:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  final names = ['Alice', 'Bob', 'Charlie', 'Diana', 'Eve'];
                  final messages = [
                    'Hey, how are you?',
                    'Let\'s meet tomorrow',
                    'Thanks for your help!',
                    'See you later',
                    'Good morning!',
                  ];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(names[index][0]),
                    ),
                    title: Text(names[index]),
                    subtitle: Text(messages[index]),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${10 + index}:30',
                          style: const TextStyle(fontSize: 12),
                        ),
                        if (index < 2)
                          Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Settings list example
            const Text(
              'Settings List:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _buildSettingsTile(
                    Icons.notifications,
                    'Notifications',
                    'Manage notifications',
                    true,
                  ),
                  const Divider(height: 1),
                  _buildSettingsTile(
                    Icons.security,
                    'Privacy',
                    'Privacy settings',
                    false,
                  ),
                  const Divider(height: 1),
                  _buildSettingsTile(
                    Icons.language,
                    'Language',
                    'English',
                    false,
                  ),
                  const Divider(height: 1),
                  _buildSettingsTile(
                    Icons.dark_mode,
                    'Dark Mode',
                    'Enable dark theme',
                    true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    IconData icon,
    String title,
    String subtitle,
    bool hasSwitch,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.purple),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: hasSwitch
          ? Switch(value: true, onChanged: (value) {})
          : const Icon(Icons.arrow_forward_ios),
    );
  }

  Widget _buildExercises() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📝 Practice Exercises',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '1. Create a todo list:\n'
              '   • Display a list of tasks.\n'
              '   • Ability to add/remove/mark as complete.\n'
              '   • Use ListView.builder.\n\n'
              '2. Create a contact list:\n'
              '   • Display a contact list with avatars.\n'
              '   • Implement search and filter functionality.\n'
              '   • Use ListView.separated.\n\n'
              '3. Infinite scroll list:\n'
              '   • Load more data when scrolling to the bottom.\n'
              '   • Display a loading indicator.',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Great! You mastered ListView widget!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Complete Lesson'),
            ),
          ],
        ),
      ),
    );
  }
}
