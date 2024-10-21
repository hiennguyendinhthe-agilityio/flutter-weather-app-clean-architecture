// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:training_router/routes/router_information.dart';
import 'package:training_router/screens/detail_screen.dart';
import 'package:training_router/screens/home_screen.dart';
import 'package:training_router/screens/unknown_screen.dart';

class MyRouterDelegate extends RouterDelegate<MyRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MyRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  String? _selectedItemId;
  bool show404 = false;

  MyRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  MyRoutePath get currentConfiguration {
    if (show404) {
      return MyRoutePath.unknown();
    }
    return _selectedItemId == null
        ? MyRoutePath.home()
        : MyRoutePath.details(_selectedItemId);
  }

  @override
  Future<void> setNewRoutePath(MyRoutePath configuration) async {
    if (configuration.isUnknown) {
      show404 = true;
      return;
    }
    if (configuration.isDetailsPage) {
      _selectedItemId = configuration.id;
    } else {
      _selectedItemId = null;
    }
    show404 = false;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: const ValueKey('HomeScreen'),
          child: HomeScreen(
            onItemSeclected: _handleItemSelected,
          ),
        ),
        if (show404)
          const MaterialPage(
            child: UnknownScreen(),
            key: ValueKey('UnknownScreen'),
          )
        else if (_selectedItemId != null)
          MaterialPage(
            child: ItemDetailScreen(id: _selectedItemId),
          )
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        _selectedItemId = null;
        notifyListeners();
        return true;
      },
    );
  }

  void _handleItemSelected(String id) {
    _selectedItemId = id;
    notifyListeners();
  }
}
