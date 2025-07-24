import 'package:flutter/material.dart';

class Week29OverlayPortal extends StatefulWidget {
  const Week29OverlayPortal({super.key});

  @override
  State<Week29OverlayPortal> createState() => _Week29OverlayPortalState();
}

class _Week29OverlayPortalState extends State<Week29OverlayPortal> {
  final OverlayPortalController _tooltipController = OverlayPortalController();
  final OverlayPortalController _menuController = OverlayPortalController();
  final OverlayPortalController _modalController = OverlayPortalController();
  final OverlayPortalController _customController = OverlayPortalController();

  bool _showTooltip = false;
  bool _showMenu = false;
  bool _showModal = false;
  bool _showCustom = false;

  String _selectedColor = 'Blue';
  double _overlayOpacity = 0.8;
  bool _dismissOnTap = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Week 29: OverlayPortal'),
        backgroundColor: Colors.deepPurple,
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
              '📚 Theory: OverlayPortal',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'OverlayPortal is a powerful widget that allows you to display content '
              'in an overlay above other widgets. It provides a declarative way to '
              'create tooltips, menus, modals, and other floating UI elements.',
            ),
            const SizedBox(height: 12),
            const Text(
              '🔑 Important properties:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• controller: Controls show/hide of overlay'),
            const Text('• overlayChildBuilder: Builds the overlay content'),
            const Text('• child: The widget that triggers the overlay'),
            const Text('• overlayChild: Static overlay content (alternative)'),
            const SizedBox(height: 12),
            const Text(
              '🎯 Key advantages:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• Declarative API - easier to manage than Overlay'),
            const Text('• Automatic positioning - smart placement'),
            const Text('• Performance optimized - efficient rendering'),
            const Text('• Accessibility support - screen reader friendly'),
            const SizedBox(height: 12),
            const Text(
              '💡 Perfect for tooltips, context menus, popups, and modals!',
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
            Text('Overlay Opacity: ${_overlayOpacity.toStringAsFixed(1)}'),
            Slider(
              value: _overlayOpacity,
              min: 0.1,
              max: 1.0,
              divisions: 9,
              onChanged: (value) => setState(() => _overlayOpacity = value),
            ),

            SwitchListTile(
              title: const Text('Dismiss on Background Tap'),
              value: _dismissOnTap,
              onChanged: (value) => setState(() => _dismissOnTap = value),
            ),

            const SizedBox(height: 20),

            // Demo Buttons Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 2.5,
              children: [
                // Tooltip Demo
                OverlayPortal(
                  controller: _tooltipController,
                  overlayChildBuilder: (BuildContext context) {
                    return Positioned(
                      top: 200,
                      left: 50,
                      child: Material(
                        elevation: 8,
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black87.withValues(
                          alpha: _overlayOpacity,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: const Text(
                            'This is a custom tooltip!\nTap anywhere to dismiss',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_showTooltip) {
                        _tooltipController.hide();
                      } else {
                        _tooltipController.show();
                      }
                      setState(() => _showTooltip = !_showTooltip);
                    },
                    icon: const Icon(Icons.info),
                    label: Text(_showTooltip ? 'Hide Tooltip' : 'Show Tooltip'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _showTooltip ? Colors.orange : null,
                    ),
                  ),
                ),

                // Context Menu Demo
                OverlayPortal(
                  controller: _menuController,
                  overlayChildBuilder: (BuildContext context) {
                    return GestureDetector(
                      onTap: _dismissOnTap
                          ? () {
                              _menuController.hide();
                              setState(() => _showMenu = false);
                            }
                          : null,
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.3),
                        child: Center(
                          child: Material(
                            elevation: 8,
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white.withValues(
                              alpha: _overlayOpacity,
                            ),
                            child: Container(
                              width: 200,
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.edit),
                                    title: const Text('Edit'),
                                    onTap: () {
                                      _menuController.hide();
                                      setState(() => _showMenu = false);
                                      _showSnackBar('Edit selected');
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.copy),
                                    title: const Text('Copy'),
                                    onTap: () {
                                      _menuController.hide();
                                      setState(() => _showMenu = false);
                                      _showSnackBar('Copy selected');
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.delete),
                                    title: const Text('Delete'),
                                    onTap: () {
                                      _menuController.hide();
                                      setState(() => _showMenu = false);
                                      _showSnackBar('Delete selected');
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_showMenu) {
                        _menuController.hide();
                      } else {
                        _menuController.show();
                      }
                      setState(() => _showMenu = !_showMenu);
                    },
                    icon: const Icon(Icons.menu),
                    label: Text(_showMenu ? 'Hide Menu' : 'Show Menu'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _showMenu ? Colors.green : null,
                    ),
                  ),
                ),

                // Modal Demo
                OverlayPortal(
                  controller: _modalController,
                  overlayChildBuilder: (BuildContext context) {
                    return GestureDetector(
                      onTap: _dismissOnTap
                          ? () {
                              _modalController.hide();
                              setState(() => _showModal = false);
                            }
                          : null,
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.5),
                        child: Center(
                          child: Material(
                            elevation: 16,
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white.withValues(
                              alpha: _overlayOpacity,
                            ),
                            child: Container(
                              width: 300,
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Success!',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Your action was completed successfully.',
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          _modalController.hide();
                                          setState(() => _showModal = false);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          _modalController.hide();
                                          setState(() => _showModal = false);
                                          _showSnackBar('Confirmed!');
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_showModal) {
                        _modalController.hide();
                      } else {
                        _modalController.show();
                      }
                      setState(() => _showModal = !_showModal);
                    },
                    icon: const Icon(Icons.open_in_new),
                    label: Text(_showModal ? 'Hide Modal' : 'Show Modal'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _showModal ? Colors.blue : null,
                    ),
                  ),
                ),

                // Custom Overlay Demo
                OverlayPortal(
                  controller: _customController,
                  overlayChildBuilder: (BuildContext context) {
                    return GestureDetector(
                      onTap: _dismissOnTap
                          ? () {
                              _customController.hide();
                              setState(() => _showCustom = false);
                            }
                          : null,
                      child: Container(
                        color: Colors.purple.withValues(alpha: 0.2),
                        child: Center(
                          child: Material(
                            elevation: 12,
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withValues(
                              alpha: _overlayOpacity,
                            ),
                            child: Container(
                              width: 280,
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Color Picker',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Wrap(
                                    spacing: 12,
                                    runSpacing: 12,
                                    children:
                                        [
                                              'Red',
                                              'Green',
                                              'Blue',
                                              'Orange',
                                              'Purple',
                                              'Pink',
                                            ]
                                            .map(
                                              (color) => GestureDetector(
                                                onTap: () {
                                                  setState(
                                                    () =>
                                                        _selectedColor = color,
                                                  );
                                                  _customController.hide();
                                                  setState(
                                                    () => _showCustom = false,
                                                  );
                                                  _showSnackBar(
                                                    'Selected: $color',
                                                  );
                                                },
                                                child: Container(
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: _getColor(color),
                                                    shape: BoxShape.circle,
                                                    border:
                                                        _selectedColor == color
                                                        ? Border.all(
                                                            color: Colors.black,
                                                            width: 3,
                                                          )
                                                        : null,
                                                  ),
                                                  child: _selectedColor == color
                                                      ? const Icon(
                                                          Icons.check,
                                                          color: Colors.white,
                                                        )
                                                      : null,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                  ),
                                  const SizedBox(height: 16),
                                  Text('Selected: $_selectedColor'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_showCustom) {
                        _customController.hide();
                      } else {
                        _customController.show();
                      }
                      setState(() => _showCustom = !_showCustom);
                    },
                    icon: const Icon(Icons.palette),
                    label: Text(_showCustom ? 'Hide Picker' : 'Color Picker'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _showCustom ? Colors.purple : null,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Status Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.deepPurple.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overlay Status:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text('🔍 Tooltip: ${_showTooltip ? "Visible" : "Hidden"}'),
                  Text('📋 Menu: ${_showMenu ? "Visible" : "Hidden"}'),
                  Text('🪟 Modal: ${_showModal ? "Visible" : "Hidden"}'),
                  Text('🎨 Custom: ${_showCustom ? "Visible" : "Hidden"}'),
                  const SizedBox(height: 8),
                  Text('Selected Color: $_selectedColor'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColor(String colorName) {
    switch (colorName) {
      case 'Red':
        return Colors.red;
      case 'Green':
        return Colors.green;
      case 'Blue':
        return Colors.blue;
      case 'Orange':
        return Colors.orange;
      case 'Purple':
        return Colors.purple;
      case 'Pink':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
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

            // Tooltip Example
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
                    'Example 1: Interactive Tooltip',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Custom tooltip with rich content and positioning',
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.blue),
                      const SizedBox(width: 8),
                      const Text('Hover or tap for more info'),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'OverlayPortal',
                          style: TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Context Menu Example
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
                    'Example 2: Context Menu',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Right-click or long-press context menu'),
                  const SizedBox(height: 12),

                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.text_fields),
                          SizedBox(width: 8),
                          Text('Right-click this area'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Modal Dialog Example
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
                    'Example 3: Modal Dialog',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Full-screen modal with backdrop'),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.delete, size: 16),
                        label: const Text('Delete Item'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade100,
                          foregroundColor: Colors.red.shade700,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text('← Triggers confirmation modal'),
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
