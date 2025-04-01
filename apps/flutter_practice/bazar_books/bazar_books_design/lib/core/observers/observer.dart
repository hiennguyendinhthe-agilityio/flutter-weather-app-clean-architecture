import 'package:cached_query/cached_query.dart';
import 'package:flutter/material.dart';

class BazQueryObserver extends QueryObserver {
  @override
  void onChange(
    QueryBase<dynamic, dynamic> query,
    QueryState<dynamic> nextState,
  ) {
    debugPrint("Query State Changed: ${nextState.status}");
    super.onChange(query, nextState);
  }

  @override
  void onError(
    QueryBase<dynamic, dynamic> query,
    StackTrace stackTrace,
  ) {
    debugPrint("Error in query: ${query.key}, Stack Trace: $stackTrace");
    super.onError(
      query,
      stackTrace,
    );
  }
}
