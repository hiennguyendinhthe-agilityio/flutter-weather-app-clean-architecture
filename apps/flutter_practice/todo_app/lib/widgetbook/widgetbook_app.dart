import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widgetbook/widgetbook.dart';

import '../providers/theme_provider.dart';
import 'categories/basic_components.dart';
import 'categories/ui_components.dart';
import 'categories/design_system.dart';
import 'categories/screen_previews.dart';

void main() {
  runApp(const WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => ThemeProvider())],
      child: Widgetbook.material(
        directories: [
          // 🧩 Basic UI Components
          BasicComponentsCategory.create(),

          // 👤 User Interface Components
          UIComponentsCategory.create(),

          // 📱 Screen Previews
          ScreenPreviewsCategory.create(),

          // 🎨 Design System
          DesignSystemCategory.create(),
        ],

        // 🔧 Testing Tools & Addons
        addons: [
          // Theme Testing
          MaterialThemeAddon(
            themes: [
              WidgetbookTheme(
                name: '☀️ Light Theme',
                data: ThemeData(
                  useMaterial3: true,
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.blue,
                    brightness: Brightness.light,
                  ),
                  appBarTheme: const AppBarTheme(
                    centerTitle: true,
                    elevation: 0,
                  ),
                  cardTheme: CardThemeData(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              WidgetbookTheme(
                name: '🌙 Dark Theme',
                data: ThemeData(
                  useMaterial3: true,
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.blue,
                    brightness: Brightness.dark,
                  ),
                  appBarTheme: const AppBarTheme(
                    centerTitle: true,
                    elevation: 0,
                  ),
                  cardTheme: CardThemeData(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              WidgetbookTheme(
                name: '🎨 Custom Blue Theme',
                data: ThemeData(
                  useMaterial3: true,
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: const Color(0xFF1976D2),
                    brightness: Brightness.light,
                  ),
                ),
              ),
            ],
          ),

          // Device Frame Testing
          DeviceFrameAddon(
            devices: [
              Devices.ios.iPhoneSE,
              Devices.ios.iPhone13,
              Devices.ios.iPhone13ProMax,
              Devices.android.samsungGalaxyS20,
              Devices.android.samsungGalaxyNote20,
            ],
          ),

          // Accessibility Testing
          TextScaleAddon(min: 0.8, max: 3.0),

          // Localization Testing (commented out until proper delegates are added)
          // LocalizationAddon(
          //   locales: [const Locale('en', 'US'), const Locale('vi', 'VN')],
          //   localizationsDelegates: const [
          //     // Add your localization delegates here when available
          //   ],
          // ),

          // Inspector for debugging
          InspectorAddon(enabled: true),

          // Grid overlay for alignment checking
          GridAddon(),

          // Alignment guide
          AlignmentAddon(),
        ],
      ),
    );
  }
}
