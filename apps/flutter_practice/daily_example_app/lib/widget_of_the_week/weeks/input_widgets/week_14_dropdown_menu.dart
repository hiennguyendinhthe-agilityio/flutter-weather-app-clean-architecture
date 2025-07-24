import 'package:flutter/material.dart';

class Week14DropdownMenu extends StatefulWidget {
  const Week14DropdownMenu({super.key});

  @override
  State<Week14DropdownMenu> createState() => _Week14DropdownMenuState();
}

class _Week14DropdownMenuState extends State<Week14DropdownMenu> {
  String? _selectedCountry;
  String? _selectedCity;
  String? _selectedLanguage;
  bool _isEnabled = true;
  bool _showLeadingIcon = true;
  bool _showTrailingIcon = true;

  final List<String> _countries = [
    'United States',
    'Canada',
    'United Kingdom',
    'Germany',
    'France',
    'Japan',
    'Australia',
    'Brazil',
    'India',
    'China',
  ];

  final Map<String, List<String>> _cities = {
    'United States': ['New York', 'Los Angeles', 'Chicago', 'Houston'],
    'Canada': ['Toronto', 'Vancouver', 'Montreal', 'Calgary'],
    'United Kingdom': ['London', 'Manchester', 'Birmingham', 'Liverpool'],
    'Germany': ['Berlin', 'Munich', 'Hamburg', 'Frankfurt'],
    'France': ['Paris', 'Lyon', 'Marseille', 'Toulouse'],
    'Japan': ['Tokyo', 'Osaka', 'Kyoto', 'Yokohama'],
    'Australia': ['Sydney', 'Melbourne', 'Brisbane', 'Perth'],
    'Brazil': ['São Paulo', 'Rio de Janeiro', 'Brasília', 'Salvador'],
    'India': ['Mumbai', 'Delhi', 'Bangalore', 'Chennai'],
    'China': ['Beijing', 'Shanghai', 'Guangzhou', 'Shenzhen'],
  };

  final List<Map<String, dynamic>> _languages = [
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'es', 'name': 'Spanish', 'flag': '🇪🇸'},
    {'code': 'fr', 'name': 'French', 'flag': '🇫🇷'},
    {'code': 'de', 'name': 'German', 'flag': '🇩🇪'},
    {'code': 'it', 'name': 'Italian', 'flag': '🇮🇹'},
    {'code': 'pt', 'name': 'Portuguese', 'flag': '🇵🇹'},
    {'code': 'ru', 'name': 'Russian', 'flag': '🇷🇺'},
    {'code': 'ja', 'name': 'Japanese', 'flag': '🇯🇵'},
    {'code': 'ko', 'name': 'Korean', 'flag': '🇰🇷'},
    {'code': 'zh', 'name': 'Chinese', 'flag': '🇨🇳'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Week 14: DropdownMenu'),
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
              '📚 Theory: DropdownMenu',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'DropdownMenu is a Material Design 3 widget that displays a menu of options '
              'when tapped. It provides a modern alternative to the classic DropdownButton '
              'with better accessibility and customization options.',
            ),
            const SizedBox(height: 12),
            const Text(
              '🔑 Important properties:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• dropdownMenuEntries: List of menu options'),
            const Text('• onSelected: Callback when item is selected'),
            const Text('• initialSelection: Initially selected value'),
            const Text('• enabled: Whether the menu is interactive'),
            const Text('• leadingIcon: Icon before the text'),
            const Text('• trailingIcon: Icon after the text'),
            const Text('• hintText: Placeholder text'),
            const Text('• helperText: Additional help text'),
            const SizedBox(height: 12),
            const Text(
              '💡 Perfect for settings, filters, and selection interfaces!',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.orange,
              ),
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
            Row(
              children: [
                Expanded(
                  child: SwitchListTile(
                    title: const Text('Enabled'),
                    value: _isEnabled,
                    onChanged: (value) => setState(() => _isEnabled = value),
                  ),
                ),
                Expanded(
                  child: SwitchListTile(
                    title: const Text('Leading Icon'),
                    value: _showLeadingIcon,
                    onChanged: (value) =>
                        setState(() => _showLeadingIcon = value),
                  ),
                ),
              ],
            ),

            SwitchListTile(
              title: const Text('Trailing Icon'),
              value: _showTrailingIcon,
              onChanged: (value) => setState(() => _showTrailingIcon = value),
            ),

            const SizedBox(height: 20),

            // Country Selection
            Text(
              'Select Country:',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            DropdownMenu<String>(
              enabled: _isEnabled,
              hintText: 'Choose a country',
              helperText: 'Select your country from the list',
              leadingIcon: _showLeadingIcon ? const Icon(Icons.public) : null,
              trailingIcon: _showTrailingIcon
                  ? const Icon(Icons.arrow_drop_down)
                  : null,
              width: double.infinity,
              onSelected: (String? value) {
                setState(() {
                  _selectedCountry = value;
                  _selectedCity = null; // Reset city when country changes
                });
              },
              dropdownMenuEntries: _countries.map<DropdownMenuEntry<String>>((
                String country,
              ) {
                return DropdownMenuEntry<String>(
                  value: country,
                  label: country,
                  leadingIcon: const Icon(Icons.flag),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // City Selection (dependent on country)
            Text(
              'Select City:',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            DropdownMenu<String>(
              enabled: _isEnabled && _selectedCountry != null,
              hintText: _selectedCountry == null
                  ? 'Select country first'
                  : 'Choose a city',
              helperText: 'Select a city in $_selectedCountry',
              leadingIcon: _showLeadingIcon
                  ? const Icon(Icons.location_city)
                  : null,
              trailingIcon: _showTrailingIcon
                  ? const Icon(Icons.arrow_drop_down)
                  : null,
              width: double.infinity,
              onSelected: (String? value) {
                setState(() {
                  _selectedCity = value;
                });
              },
              dropdownMenuEntries: _selectedCountry != null
                  ? _cities[_selectedCountry]!.map<DropdownMenuEntry<String>>((
                      String city,
                    ) {
                      return DropdownMenuEntry<String>(
                        value: city,
                        label: city,
                        leadingIcon: const Icon(Icons.location_on),
                      );
                    }).toList()
                  : [],
            ),

            const SizedBox(height: 20),

            // Language Selection with Custom Styling
            Text(
              'Select Language:',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            DropdownMenu<String>(
              enabled: _isEnabled,
              hintText: 'Choose language',
              helperText: 'Select your preferred language',
              leadingIcon: _showLeadingIcon ? const Icon(Icons.language) : null,
              trailingIcon: _showTrailingIcon
                  ? const Icon(Icons.arrow_drop_down)
                  : null,
              width: double.infinity,
              onSelected: (String? value) {
                setState(() {
                  _selectedLanguage = value;
                });
              },
              dropdownMenuEntries: _languages.map<DropdownMenuEntry<String>>((
                Map<String, dynamic> lang,
              ) {
                return DropdownMenuEntry<String>(
                  value: lang['code'],
                  label: lang['name'],
                  leadingIcon: Text(
                    lang['flag'],
                    style: const TextStyle(fontSize: 20),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Selection Summary
            if (_selectedCountry != null ||
                _selectedCity != null ||
                _selectedLanguage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.purple.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Selections:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_selectedCountry != null)
                      Text('🌍 Country: $_selectedCountry'),
                    if (_selectedCity != null) Text('🏙️ City: $_selectedCity'),
                    if (_selectedLanguage != null)
                      Text(
                        '🗣️ Language: ${_languages.firstWhere((lang) => lang['code'] == _selectedLanguage)['name']}',
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
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

            // Settings Panel Example
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
                    'Example 1: Settings Panel',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('App settings with multiple dropdown options'),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: DropdownMenu<String>(
                          hintText: 'Theme',
                          leadingIcon: const Icon(Icons.palette),
                          width: double.infinity,
                          dropdownMenuEntries: const [
                            DropdownMenuEntry(value: 'light', label: 'Light'),
                            DropdownMenuEntry(value: 'dark', label: 'Dark'),
                            DropdownMenuEntry(value: 'auto', label: 'Auto'),
                          ],
                          onSelected: (value) {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownMenu<String>(
                          hintText: 'Font Size',
                          leadingIcon: const Icon(Icons.text_fields),
                          width: double.infinity,
                          dropdownMenuEntries: const [
                            DropdownMenuEntry(value: 'small', label: 'Small'),
                            DropdownMenuEntry(value: 'medium', label: 'Medium'),
                            DropdownMenuEntry(value: 'large', label: 'Large'),
                          ],
                          onSelected: (value) {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Filter Example
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
                    'Example 2: Product Filter',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('E-commerce product filtering interface'),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: DropdownMenu<String>(
                          hintText: 'Category',
                          leadingIcon: const Icon(Icons.category),
                          width: double.infinity,
                          dropdownMenuEntries: const [
                            DropdownMenuEntry(
                              value: 'electronics',
                              label: 'Electronics',
                            ),
                            DropdownMenuEntry(
                              value: 'clothing',
                              label: 'Clothing',
                            ),
                            DropdownMenuEntry(value: 'books', label: 'Books'),
                          ],
                          onSelected: (value) {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownMenu<String>(
                          hintText: 'Sort By',
                          leadingIcon: const Icon(Icons.sort),
                          width: double.infinity,
                          dropdownMenuEntries: const [
                            DropdownMenuEntry(
                              value: 'price_low',
                              label: 'Price: Low to High',
                            ),
                            DropdownMenuEntry(
                              value: 'price_high',
                              label: 'Price: High to Low',
                            ),
                            DropdownMenuEntry(value: 'rating', label: 'Rating'),
                            DropdownMenuEntry(value: 'newest', label: 'Newest'),
                          ],
                          onSelected: (value) {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Form Example
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
                    'Example 3: Registration Form',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('User registration with dropdown selections'),
                  const SizedBox(height: 12),

                  DropdownMenu<String>(
                    hintText: 'Select your profession',
                    helperText: 'Choose the option that best describes you',
                    leadingIcon: const Icon(Icons.work),
                    width: double.infinity,
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(
                        value: 'developer',
                        label: 'Software Developer',
                      ),
                      DropdownMenuEntry(
                        value: 'designer',
                        label: 'UI/UX Designer',
                      ),
                      DropdownMenuEntry(
                        value: 'manager',
                        label: 'Project Manager',
                      ),
                      DropdownMenuEntry(value: 'student', label: 'Student'),
                      DropdownMenuEntry(value: 'other', label: 'Other'),
                    ],
                    onSelected: (value) {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
              '1. Basic Dropdown Implementation:\n'
              '   • Create a simple dropdown for selecting colors\n'
              '   • Add leading icons for each option\n'
              '   • Display selected value below the dropdown\n\n'
              '2. Cascading Dropdowns:\n'
              '   • Create country → state → city selection\n'
              '   • Second dropdown depends on first selection\n'
              '   • Third dropdown depends on second selection\n\n'
              '3. Advanced Dropdown Features:\n'
              '   • Add search functionality within dropdown\n'
              '   • Implement custom styling and themes\n'
              '   • Add validation and error states\n\n'
              '4. Dynamic Dropdown Content:\n'
              '   • Load dropdown options from API\n'
              '   • Add loading states and error handling\n'
              '   • Implement infinite scroll for large lists\n'
              '   • Add multi-select functionality',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Great! You completed the DropdownMenu lesson!',
                    ),
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
