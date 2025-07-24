import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../components/code_examples_manager.dart';
import '../../components/floating_code_button.dart';

class Week12Transform extends StatefulWidget {
  const Week12Transform({super.key});

  @override
  State<Week12Transform> createState() => _Week12TransformState();
}

class _Week12TransformState extends State<Week12Transform>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late AnimationController _flipController;
  late AnimationController _complexController;

  double _rotationAngle = 0.0;
  double _scaleX = 1.0;
  double _scaleY = 1.0;
  double _translateX = 0.0;
  double _translateY = 0.0;
  double _skewX = 0.0;
  double _skewY = 0.0;

  bool _isCardFlipped = false;
  bool _showAdvanced = false;
  String _selectedTransform = 'rotate';

  @override
  void initState() {
    super.initState();
    _initializeAnimationControllers();
  }

  void _initializeAnimationControllers() {
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _complexController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    _flipController.dispose();
    _complexController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Week 12: Transform Widget'),
        backgroundColor: Colors.indigo,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_showAdvanced ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _showAdvanced = !_showAdvanced),
            tooltip: _showAdvanced ? 'Hide Advanced' : 'Show Advanced',
          ),
        ],
      ),
      floatingActionButton: FloatingCodeButton(
        examples: _getTransformExamples(),
        lessonTitle: 'Transform Widget - Week 12',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTheorySection(),
            const SizedBox(height: 20),
            _buildQuickPresets(),
            const SizedBox(height: 20),
            _buildInteractiveDemo(),
            const SizedBox(height: 20),
            _buildRealWorldExamples(),
            const SizedBox(height: 20),
            if (_showAdvanced) ...[
              _buildAdvancedSection(),
              const SizedBox(height: 20),
            ],
            _buildPerformanceTips(),
            const SizedBox(height: 20),
            _buildExercises(),
          ],
        ),
      ),
    );
  }

  Widget _buildTheorySection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.transform, color: Colors.indigo),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Transform Widget - Geometric Transformations',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Text(
                '🎯 The Transform widget allows you to apply 2D and 3D geometric transformations '
                'to its child widget without affecting the layout. It is a powerful tool for creating '
                'animations, effects, and interactive UI.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ),

            const SizedBox(height: 20),

            _buildTransformTypeGrid(),

            const SizedBox(height: 20),

            _buildMathExplanation(),

            const SizedBox(height: 20),

            _buildPerformanceInsights(),
          ],
        ),
      ),
    );
  }

  Widget _buildTransformTypeGrid() {
    final transformTypes = [
      {
        'icon': Icons.rotate_right,
        'title': 'Rotate',
        'desc': 'Rotate widget by an angle',
        'color': Colors.blue,
      },
      {
        'icon': Icons.zoom_in,
        'title': 'Scale',
        'desc': 'Zoom in/out',
        'color': Colors.green,
      },
      {
        'icon': Icons.open_with,
        'title': 'Translate',
        'desc': 'Move position',
        'color': Colors.orange,
      },
      {
        'icon': Icons.architecture,
        'title': 'Matrix',
        'desc': 'Custom transform',
        'color': Colors.purple,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🔧 Main Transform Types:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: transformTypes.length,
          itemBuilder: (context, index) {
            final type = transformTypes[index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (type['color'] as Color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: (type['color'] as Color).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    type['icon'] as IconData,
                    color: type['color'] as Color,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          type['title'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: type['color'] as Color,
                          ),
                        ),
                        Text(
                          type['desc'] as String,
                          style: const TextStyle(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMathExplanation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calculate, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Text(
                'The Math Behind Transform',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '🔢 4x4 Matrix: Represents all transformations in 3D space',
          ),
          const SizedBox(height: 6),
          const Text('📐 Rotation: angle (radians) = degrees × π/180'),
          const SizedBox(height: 6),
          const Text('📏 Scale: 1.0 = original size, 2.0 = double, 0.5 = half'),
          const SizedBox(height: 6),
          const Text('🎯 Translation: move by pixels (x, y, z)'),
          const SizedBox(height: 6),
          const Text(
            '🔄 Perspective: create 3D effect with small values (e.g., 0.001)',
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceInsights() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.speed, color: Colors.green.shade700),
              const SizedBox(width: 8),
              Text(
                'Performance & Best Practices',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('✅ GPU accelerated - high performance'),
          const SizedBox(height: 6),
          const Text('✅ Does not affect layout - visual only'),
          const SizedBox(height: 6),
          const Text('⚠️ Can overlap with other widgets'),
          const SizedBox(height: 6),
          const Text('⚠️ Hit detection for touch events needs testing'),
          const SizedBox(height: 6),
          const Text('💡 Use AnimatedBuilder for smooth animations'),
        ],
      ),
    );
  }

  Widget _buildQuickPresets() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.flash_on, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  'Quick Transform Presets',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _buildPresetButton(
                  'Reset',
                  'identity',
                  Icons.refresh,
                  Colors.grey,
                ),
                _buildPresetButton(
                  'Rotate 45°',
                  'rotate45',
                  Icons.rotate_right,
                  Colors.blue,
                ),
                _buildPresetButton(
                  'Scale 2x',
                  'scale2x',
                  Icons.zoom_in,
                  Colors.green,
                ),
                _buildPresetButton(
                  'Flip Card',
                  'flip',
                  Icons.flip,
                  Colors.purple,
                ),
              ],
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lightbulb, color: Colors.amber, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tip: Try these presets to quickly understand basic transforms!',
                      style: TextStyle(fontSize: 13),
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

  Widget _buildPresetButton(
    String label,
    String preset,
    IconData icon,
    Color color,
  ) {
    return ElevatedButton.icon(
      onPressed: () => _applyPreset(preset),
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.1),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  void _applyPreset(String preset) {
    setState(() {
      switch (preset) {
        case 'identity':
          _resetTransforms();
          break;
        case 'rotate45':
          _resetTransforms();
          _selectedTransform = 'rotate';
          _rotationAngle = math.pi / 4;
          break;
        case 'scale2x':
          _resetTransforms();
          _selectedTransform = 'scale';
          _scaleX = 2.0;
          _scaleY = 2.0;
          break;
        case 'flip':
          _resetTransforms();
          _selectedTransform = 'rotate';
          _rotationAngle = math.pi;
          _scaleX = -1.0;
          break;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Applied preset: $preset'),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.indigo,
      ),
    );
  }

  Widget _buildInteractiveDemo() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.gamepad, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Interactive Transform Playground',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.tune, color: Colors.indigo, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Select Transform Type:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildTransformChip(
                          'rotate',
                          'Rotate',
                          Icons.rotate_right,
                        ),
                        const SizedBox(width: 8),
                        _buildTransformChip('scale', 'Scale', Icons.zoom_in),
                        const SizedBox(width: 8),
                        _buildTransformChip(
                          'translate',
                          'Translate',
                          Icons.open_with,
                        ),
                        const SizedBox(width: 8),
                        _buildTransformChip('skew', 'Skew', Icons.architecture),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.shade200),
              ),
              child: _buildTransformControls(),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              height: 320,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.grey.shade50, Colors.grey.shade100],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: CustomPaint(painter: GridPainter()),
                    ),
                  ),

                  const Center(
                    child: Icon(
                      Icons.center_focus_strong,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),

                  Center(child: _buildSafeTransformWidget()),

                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _getMatrixDescription(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Column(
              children: [
                const Text(
                  '🎬 Animations Demo:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildAnimationButton(
                      'Rotate 360°',
                      Icons.rotate_right,
                      Colors.blue,
                      _startRotationAnimation,
                    ),
                    _buildAnimationButton(
                      'Scale Pulse',
                      Icons.favorite,
                      Colors.red,
                      _startScaleAnimation,
                    ),
                    _buildAnimationButton(
                      'Flip 3D',
                      Icons.flip,
                      Colors.purple,
                      _startFlipAnimation,
                    ),
                    _buildAnimationButton(
                      'Complex',
                      Icons.auto_awesome,
                      Colors.orange,
                      _startComplexAnimation,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimationButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.1),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color.withValues(alpha: 0.3)),
        ),
      ),
    );
  }

  Widget _buildSafeTransformWidget() {
    try {
      return Transform(
        alignment: Alignment.center,
        transform: _buildSafeTransformMatrix(),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.purple, Colors.pink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.white, size: 24),
              Text('Demo', style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        ),
      );
    } catch (e) {
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text('Error', style: TextStyle(color: Colors.white)),
        ),
      );
    }
  }

  Matrix4 _buildSafeTransformMatrix() {
    final matrix = Matrix4.identity();

    try {
      switch (_selectedTransform) {
        case 'rotate':
          if (_rotationAngle.isFinite && !_rotationAngle.isNaN) {
            matrix.rotateZ(_rotationAngle);
          }
          break;
        case 'scale':
          final safeScaleX =
              (_scaleX.isFinite && !_scaleX.isNaN && _scaleX > 0.01)
              ? _scaleX
              : 1.0;
          final safeScaleY =
              (_scaleY.isFinite && !_scaleY.isNaN && _scaleY > 0.01)
              ? _scaleY
              : 1.0;
          matrix.scale(safeScaleX, safeScaleY);
          break;
        case 'translate':
          if (_translateX.isFinite &&
              !_translateX.isNaN &&
              _translateY.isFinite &&
              !_translateY.isNaN) {
            matrix.translate(_translateX, _translateY);
          }
          break;
        case 'skew':
          final safeSkewX = (_skewX.isFinite && !_skewX.isNaN)
              ? _skewX.clamp(-0.5, 0.5)
              : 0.0;
          final safeSkewY = (_skewY.isFinite && !_skewY.isNaN)
              ? _skewY.clamp(-0.5, 0.5)
              : 0.0;
          matrix.setEntry(0, 1, safeSkewX);
          matrix.setEntry(1, 0, safeSkewY);
          break;
      }
    } catch (e) {
      return Matrix4.identity();
    }

    return matrix;
  }

  Widget _buildTransformChip(String type, String label, IconData icon) {
    final isSelected = _selectedTransform == type;
    return FilterChip(
      selected: isSelected,
      avatar: Icon(
        icon,
        size: 18,
        color: isSelected ? Colors.indigo : Colors.grey,
      ),
      label: Text(label),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedTransform = type;
            _resetTransforms();
          });
        }
      },
      selectedColor: Colors.indigo.shade100,
      backgroundColor: Colors.white,
      side: BorderSide(
        color: isSelected ? Colors.indigo : Colors.grey.shade300,
        width: isSelected ? 2 : 1,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildTransformControls() {
    switch (_selectedTransform) {
      case 'rotate':
        return _buildSliderControl(
          'Rotation Angle',
          '${(_rotationAngle * 180 / math.pi).toStringAsFixed(0)}°',
          _rotationAngle,
          -math.pi,
          math.pi,
          (value) => setState(() => _rotationAngle = value),
          Icons.rotate_right,
          Colors.blue,
        );

      case 'scale':
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildSliderControl(
                    'Scale X',
                    _scaleX.toStringAsFixed(2),
                    _scaleX,
                    0.1,
                    3.0,
                    (value) => setState(() => _scaleX = value),
                    Icons.width_wide,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSliderControl(
                    'Scale Y',
                    _scaleY.toStringAsFixed(2),
                    _scaleY,
                    0.1,
                    3.0,
                    (value) => setState(() => _scaleY = value),
                    Icons.height,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () => setState(() {
                    _scaleX = _scaleY = 1.0;
                  }),
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Reset'),
                ),
                const SizedBox(width: 16),
                TextButton.icon(
                  onPressed: () => setState(() {
                    _scaleY = _scaleX;
                  }),
                  icon: const Icon(Icons.link, size: 16),
                  label: const Text('Link XY'),
                ),
              ],
            ),
          ],
        );

      case 'translate':
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildSliderControl(
                    'Translate X',
                    '${_translateX.toStringAsFixed(0)}px',
                    _translateX,
                    -100,
                    100,
                    (value) => setState(() => _translateX = value),
                    Icons.arrow_right_alt,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSliderControl(
                    'Translate Y',
                    '${_translateY.toStringAsFixed(0)}px',
                    _translateY,
                    -100,
                    100,
                    (value) => setState(() => _translateY = value),
                    Icons.arrow_downward,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        );

      case 'skew':
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildSliderControl(
                    'Skew X',
                    _skewX.toStringAsFixed(2),
                    _skewX,
                    -0.5,
                    0.5,
                    (value) => setState(() => _skewX = value),
                    Icons.architecture,
                    Colors.purple,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSliderControl(
                    'Skew Y',
                    _skewY.toStringAsFixed(2),
                    _skewY,
                    -0.5,
                    0.5,
                    (value) => setState(() => _skewY = value),
                    Icons.architecture,
                    Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                '💡 Skew creates a slant/shear effect. Use small values to avoid excessive distortion.',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSliderControl(
    String label,
    String value,
    double currentValue,
    double min,
    double max,
    ValueChanged<double> onChanged,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            thumbColor: color,
            overlayColor: color.withValues(alpha: 0.2),
            trackHeight: 4,
          ),
          child: Slider(
            value: currentValue,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  String _getMatrixDescription() {
    switch (_selectedTransform) {
      case 'rotate':
        return 'Matrix4.rotationZ(${_rotationAngle.toStringAsFixed(2)})';
      case 'scale':
        return 'Matrix4.diagonal3Values(${_scaleX.toStringAsFixed(2)}, ${_scaleY.toStringAsFixed(2)}, 1.0)';
      case 'translate':
        return 'Matrix4.translationValues(${_translateX.toStringAsFixed(0)}, ${_translateY.toStringAsFixed(0)}, 0.0)';
      case 'skew':
        return 'Custom skew matrix';
      default:
        return 'Matrix4.identity()';
    }
  }

  void _resetTransforms() {
    _rotationAngle = 0.0;
    _scaleX = 1.0;
    _scaleY = 1.0;
    _translateX = 0.0;
    _translateY = 0.0;
    _skewX = 0.0;
    _skewY = 0.0;
  }

  void _startRotationAnimation() {
    _rotationController.reset();
    _rotationController.forward();

    _rotationController.removeListener(() {});

    _rotationController.addListener(() {
      if (mounted) {
        setState(() {
          _selectedTransform = 'rotate';
          _rotationAngle = _rotationController.value * 2 * math.pi;
        });
      }
    });
  }

  void _startScaleAnimation() {
    _scaleController.reset();
    _scaleController.forward();

    _scaleController.removeListener(() {});

    _scaleController.addListener(() {
      if (mounted) {
        setState(() {
          _selectedTransform = 'scale';
          final scale =
              1.0 + math.sin(_scaleController.value * 6 * math.pi) * 0.3;
          _scaleX = scale;
          _scaleY = scale;
        });
      }
    });
  }

  void _startFlipAnimation() {
    _flipController.reset();
    _flipController.forward();

    _flipController.removeListener(() {});

    _flipController.addListener(() {
      if (mounted) {
        setState(() {
          _selectedTransform = 'rotate';

          _rotationAngle = _flipController.value * math.pi;
          _scaleX = math.cos(_flipController.value * math.pi).abs();
        });
      }
    });
  }

  void _startComplexAnimation() {
    _complexController.reset();
    _complexController.forward();

    _complexController.removeListener(() {});

    _complexController.addListener(() {
      if (mounted) {
        setState(() {
          final t = _complexController.value;

          _rotationAngle = t * 4 * math.pi;
          _scaleX = 1.0 + math.sin(t * 8 * math.pi) * 0.3;
          _scaleY = 1.0 + math.cos(t * 8 * math.pi) * 0.3;
          _translateX = math.sin(t * 6 * math.pi) * 30;
          _translateY = math.cos(t * 6 * math.pi) * 30;

          if (t < 0.25) {
            _selectedTransform = 'rotate';
          } else if (t < 0.5) {
            _selectedTransform = 'scale';
          } else if (t < 0.75) {
            _selectedTransform = 'translate';
          } else {
            _selectedTransform = 'rotate';
          }
        });
      }
    });

    _complexController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _resetTransforms();
          _selectedTransform = 'rotate';
        });
      }
    });
  }

  Widget _buildRealWorldExamples() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.apps, color: Colors.orange),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Real-World UI Patterns',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildPatternExample(
              '1. Custom Loading Spinner',
              'Using Transform.rotate for a loading animation.',
              Row(
                children: [
                  AnimatedBuilder(
                    animation: _rotationController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationController.value * 2 * math.pi,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue,
                                Colors.blue.withValues(alpha: 0.2),
                              ],
                              stops: const [0.0, 0.7],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.refresh, color: Colors.white),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Smooth rotation with a gradient.\nGPU accelerated performance.',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _buildPatternExample(
              '2. 3D Card Flip',
              'Using a perspective transform for a 3D effect.',
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isCardFlipped = !_isCardFlipped;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(_isCardFlipped ? math.pi : 0),
                  alignment: Alignment.center,
                  child: Container(
                    width: 120,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _isCardFlipped
                            ? [Colors.red.shade400, Colors.red.shade600]
                            : [Colors.blue.shade400, Colors.blue.shade600],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isCardFlipped ? Icons.favorite : Icons.star,
                            color: Colors.white,
                            size: 24,
                          ),
                          Text(
                            _isCardFlipped ? 'Back' : 'Front',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            _buildPatternExample(
              '3. Interactive Button',
              'Scale transform for hover/press effects.',
              _buildInteractiveButton(),
            ),

            const SizedBox(height: 16),

            _buildPatternExample(
              '4. Parallax Effect',
              'Multiple layers with different transform speeds.',
              SizedBox(
                height: 60,
                child: Stack(
                  children: [
                    AnimatedBuilder(
                      animation: _complexController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(_complexController.value * -20, 0),
                          child: Container(
                            width: 200,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.purple.shade200,
                                  Colors.purple.shade400,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      },
                    ),

                    AnimatedBuilder(
                      animation: _complexController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(_complexController.value * -40, 0),
                          child: Container(
                            width: 150,
                            height: 40,
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'Parallax',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatternExample(String title, String description, Widget demo) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const SizedBox(height: 12),
          demo,
        ],
      ),
    );
  }

  Widget _buildInteractiveButton() {
    bool isPressed = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return GestureDetector(
          onTapDown: (_) => setState(() => isPressed = true),
          onTapUp: (_) => setState(() => isPressed = false),
          onTapCancel: () => setState(() => isPressed = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            transform: Matrix4.identity()..scale(isPressed ? 0.95 : 1.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isPressed
                      ? [Colors.green.shade200, Colors.green.shade400]
                      : [Colors.green.shade400, Colors.green.shade600],
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.3),
                    blurRadius: isPressed ? 4 : 8,
                    offset: Offset(0, isPressed ? 2 : 4),
                  ),
                ],
              ),
              child: const Text(
                'Press Me!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAdvancedSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.science, color: Colors.purple),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Advanced Transform Techniques',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildAdvancedTopic(
              '1. Matrix Composition',
              'Combining multiple transforms into a single matrix.',
              '''
Matrix4 complexTransform() {
  return Matrix4.identity()
    ..translate(50.0, 0.0)      
    ..rotateZ(math.pi / 4)      
    ..scale(1.5);               
}


''',
            ),

            const SizedBox(height: 16),

            _buildAdvancedTopic(
              '2. 3D Transforms',
              'Using perspective and 3D rotations.',
              '''
Matrix4 perspective3D() {
  return Matrix4.identity()
    ..setEntry(3, 2, 0.001)     
    ..rotateX(0.3)              
    ..rotateY(0.5);             
}
''',
            ),

            const SizedBox(height: 16),

            _buildAdvancedTopic(
              '3. Performance Optimization',
              'Optimizing for smooth animations.',
              '''

AnimatedBuilder(
  animation: controller,
  builder: (context, child) {
    return Transform.rotate(
      angle: controller.value * 2 * pi,
      child: child, 
    );
  },
  child: ExpensiveWidget(), 
)
''',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedTopic(String title, String description, String code) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              code,
              style: const TextStyle(
                color: Colors.green,
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceTips() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.speed, color: Colors.green),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Performance Tips & Best Practices',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildTipItem(
              Icons.check_circle,
              'DO: Use AnimatedBuilder',
              'Avoids rebuilding the entire widget tree during animation.',
              Colors.green,
            ),

            _buildTipItem(
              Icons.check_circle,
              'DO: Cache expensive child widgets',
              'Pass the widget to the AnimatedBuilder.child property.',
              Colors.green,
            ),

            _buildTipItem(
              Icons.warning,
              'AVOID: Complex transforms in the build method',
              'Avoid complex matrix calculations inside the build() method.',
              Colors.orange,
            ),

            _buildTipItem(
              Icons.error,
              'DON\'T: Use extreme transform values',
              'Values like scale = 0 or rotation = NaN can crash the app.',
              Colors.red,
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Pro Tips',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• A transformed widget\'s hit test area does not change - be careful with buttons.',
                  ),
                  const Text('• Use RepaintBoundary to isolate repaints.'),
                  const Text('• Test on a real device to ensure performance.'),
                  const Text(
                    '• Combine transforms into a single matrix instead of nesting them.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExercises() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.assignment, color: Colors.red),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Practice Exercises',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

      

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo.shade50, Colors.indigo.shade100],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.school, color: Colors.indigo),
                      const SizedBox(width: 8),
                      Text(
                        'You\'ve learned the Transform Widget!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'You have learned: Matrix transformations, performance optimization, real-world patterns, and advanced techniques. Now, try the exercises!',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(Icons.celebration, color: Colors.white),
                              SizedBox(width: 8),
                              Text('🎉 Excellent! Transform Widget mastered!'),
                            ],
                          ),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Complete Lesson'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
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

  List<CodeExample> _getTransformExamples() {
    return [
      const CodeExample(
        title: 'Basic Transform.rotate() - Rotating a widget',
        code: '''
Transform.rotate(
  angle: math.pi / 4, 
  alignment: Alignment.center, 
  child: Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Center(
      child: Text('Rotated', 
        style: TextStyle(color: Colors.white)),
    ),
  ),
)''',
      ),

      const CodeExample(
        title: 'Transform.scale() - Scaling a widget',
        code: '''
Transform.scale(
  scale: 1.5, 
  alignment: Alignment.center,
  child: Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.green, Colors.green.shade700],
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Icon(Icons.star, 
      color: Colors.white, size: 32),
  ),
)''',
      ),

      const CodeExample(
        title: 'Transform.translate() - Translating a widget',
        code: '''
Transform.translate(
  offset: const Offset(50, -20), 
  child: Container(
    width: 80,
    height: 80,
    decoration: BoxDecoration(
      color: Colors.orange,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha:  0.2),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: const Icon(Icons.location_on, 
      color: Colors.white),
  ),
)''',
      ),

      const CodeExample(
        title: 'Custom Matrix Transform - Advanced',
        code: '''
Matrix4 buildComplexTransform() {
  return Matrix4.identity()
    ..setEntry(3, 2, 0.001) 
    ..rotateX(0.3)          
    ..rotateY(0.2)          
    ..rotateZ(math.pi / 6)  
    ..scale(1.2);           
}

Transform(
  alignment: Alignment.center,
  transform: buildComplexTransform(),
  child: Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.purple, Colors.pink],
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Icon(Icons.auto_awesome, 
      color: Colors.white, size: 32),
  ),
)''',
      ),

      const CodeExample(
        title: 'Safe Transform với Error Handling',
        code: '''
Matrix4 buildSafeMatrix(double angle, double scale) {
  final matrix = Matrix4.identity();
  
  try {
    
    if (angle.isFinite && !angle.isNaN) {
      matrix.rotateZ(angle);
    }
    
    
    final safeScale = (scale.isFinite && 
                      !scale.isNaN && 
                      scale > 0.01) ? scale : 1.0;
    matrix.scale(safeScale);
    
  } catch (e) {
    
    return Matrix4.identity();
  }
  
  return matrix;
}


Transform(
  transform: buildSafeMatrix(rotationAngle, scaleValue),
  child: YourWidget(),
)''',
      ),

      const CodeExample(
        title: 'Animated Transform với AnimatedBuilder',
        code: '''
class AnimatedTransformWidget extends StatefulWidget {
  @override
  _AnimatedTransformWidgetState createState() => 
    _AnimatedTransformWidgetState();
}

class _AnimatedTransformWidgetState extends State<AnimatedTransformWidget>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(); 
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: child, 
        );
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.transparent],
          ),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}''',
      ),

      const CodeExample(
        title: '3D Card Flip Effect',
        code: '''
class FlipCard extends StatefulWidget {
  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> {
  bool _isFlipped = false;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isFlipped = !_isFlipped),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) 
          ..rotateY(_isFlipped ? math.pi : 0),
        alignment: Alignment.center,
        child: Container(
          width: 200,
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isFlipped 
                ? [Colors.red, Colors.red.shade700]
                : [Colors.blue, Colors.blue.shade700],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha:  0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Text(
              _isFlipped ? 'Back Side' : 'Front Side',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}''',
      ),
    ];
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..strokeWidth = 1;

    const spacing = 20.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
