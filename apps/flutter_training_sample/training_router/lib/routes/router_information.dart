import 'package:flutter/material.dart';

class MyRouteInformationParser extends RouteInformationParser<MyRoutePath> {
  @override
  Future<MyRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.uri.path);
    if (uri.pathSegments.isEmpty) {
      return MyRoutePath.home();
    } else if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] == 'item') {
        final id = uri.pathSegments[1];
        return MyRoutePath.details(id);
      }
    }
    return MyRoutePath.unknown();
  }

  @override
  RouteInformation restoreRouteInformation(MyRoutePath configuration) {
    if (configuration.isHomePage) {
      return RouteInformation(uri: Uri(path: '/'));
    }
    if (configuration.isDetailsPage) {
      return RouteInformation(uri: Uri(path: '/item/${configuration.id}'));
    }
    return RouteInformation(uri: Uri(path: '/unknown'));
  }
}

class MyRoutePath {
  final String? id;
  final bool isUnknown;

  MyRoutePath.home()
      : id = null,
        isUnknown = false;
  MyRoutePath.details(this.id) : isUnknown = false;
  MyRoutePath.unknown()
      : id = null,
        isUnknown = true;

  bool get isHomePage => id == null && !isUnknown;

  bool get isDetailsPage => id != null;
}
