// Code Examples Repository
// Contains all code examples for the widget lessons

class CodeExamples {
  // Container Examples
  static const String containerBasic = '''
Container(
  width: 200,
  height: 200,
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: Center(
    child: Text(
      'Container',
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
)''';

  static const String containerCard = '''
Container(
  width: double.infinity,
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.3),
        blurRadius: 6,
        offset: Offset(0, 2),
      ),
    ],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Card-style Container',
        style: TextStyle(
          fontSize: 18, 
          fontWeight: FontWeight.bold
        ),
      ),
      SizedBox(height: 8),
      Text('Used to display content in a card-like style with padding and shadow.'),
    ],
  ),
)''';

  static const String containerGradient = '''
Container(
  width: double.infinity,
  height: 100,
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.purple, Colors.blue],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(8),
  ),
  child: Center(
    child: Text(
      'Gradient Container',
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
)''';

  // Row & Column Examples
  static const String rowBasic = '''
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Container(
      width: 60,
      height: 60,
      color: Colors.red,
      child: Center(child: Text('1')),
    ),
    Container(
      width: 60,
      height: 60,
      color: Colors.green,
      child: Center(child: Text('2')),
    ),
    Container(
      width: 60,
      height: 60,
      color: Colors.blue,
      child: Center(child: Text('3')),
    ),
  ],
)''';

  static const String profileCard = '''
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.grey.shade100,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Row(
    children: [
      CircleAvatar(
        radius: 30,
        backgroundColor: Colors.blue,
        child: Icon(Icons.person, color: Colors.white, size: 30),
      ),
      SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'John Doe',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Flutter Developer'),
            Text('New York, USA'),
          ],
        ),
      ),
      IconButton(
        onPressed: () {},
        icon: Icon(Icons.more_vert),
      ),
    ],
  ),
)''';

  // Expanded & Flexible Examples
  static const String expandedBasic = '''
Row(
  children: [
    Container(
      width: 100,
      height: 50,
      color: Colors.red,
      child: Center(child: Text('Fixed')),
    ),
    Expanded(
      flex: 2,
      child: Container(
        height: 50,
        color: Colors.green,
        child: Center(child: Text('Expanded 2')),
      ),
    ),
    Expanded(
      flex: 1,
      child: Container(
        height: 50,
        color: Colors.blue,
        child: Center(child: Text('Expanded 1')),
      ),
    ),
  ],
)''';

  static const String flexibleVsExpanded = '''
Column(
  children: [
    // Với Expanded
    // With Expanded
    Row(
      children: [
        Text('Expanded: '),
        Expanded(
          child: Container(
            height: 40,
            color: Colors.blue,
            child: Center(child: Text('Forced to fill')),
          ),
        ),
      ],
    ),
    SizedBox(height: 8),
    // Với Flexible
    // With Flexible
    Row(
      children: [
        Text('Flexible: '),
        Flexible(
          child: Container(
            height: 40,
            color: Colors.green,
            child: Center(child: Text('Allowed to be smaller')),
          ),
        ),
      ],
    ),
  ],
)''';

  // Wrap Examples
  static const String wrapTags = '''
Wrap(
  spacing: 8.0,
  runSpacing: 4.0,
  children: [
    'Flutter', 'Dart', 'Mobile', 'iOS', 'Android'
  ].map((tag) => Chip(
    label: Text(tag),
    backgroundColor: Colors.blue.shade100,
    deleteIcon: Icon(Icons.close, size: 16),
    onDeleted: () {
      // Remove tag
    },
  )).toList(),
)''';

  static const String wrapButtons = '''
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(Icons.save, size: 16),
      label: Text('Save'),
    ),
    ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(Icons.share, size: 16),
      label: Text('Share'),
    ),
    ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(Icons.download, size: 16),
      label: Text('Download'),
    ),
  ],
)''';

  // ListView Examples
  static const String listViewBasic = '''
ListView(
  children: [
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
  ],
)''';

  static const String listViewBuilder = '''
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.purple,
          child: Text('\${index + 1}'),
        ),
        title: Text(items[index]),
        subtitle: Text('Description for \${items[index]}'),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            // Delete item
          },
        ),
      ),
    );
  },
)''';

  // GridView Examples
  static const String gridViewCount = '''
GridView.count(
  crossAxisCount: 2,
  crossAxisSpacing: 8,
  mainAxisSpacing: 8,
  children: List.generate(6, (index) {
    return Container(
      decoration: BoxDecoration(
        color: colors[index % colors.length],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, color: Colors.white, size: 30),
            SizedBox(height: 4),
            Text(
              '\${index + 1}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }),
)''';

  static const String gridViewBuilder = '''
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 0.8,
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
  ),
  itemCount: products.length,
  itemBuilder: (context, index) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
              child: Icon(
                Icons.devices,
                color: Colors.grey.shade600,
                size: 40,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  products[index].name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  products[index].price,
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  },
)''';
}
