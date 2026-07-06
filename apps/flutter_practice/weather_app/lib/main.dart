// Entry point.
//
// Responsibilities:
//   - Bootstrap Flutter bindings.
//   - Wrap app in [ProviderScope] (Riverpod requirement).
//   - Hand off to [App] widget.
//   - NO business logic, NO initialization side-effects here.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: App()));
}
