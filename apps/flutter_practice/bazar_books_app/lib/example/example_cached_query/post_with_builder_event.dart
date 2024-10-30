import 'package:flutter/material.dart';

@immutable
abstract class PostWithBuilderEvent {}

class PostsWithBuilderFetched extends PostWithBuilderEvent {}

class PostsWithBuilderNextPage extends PostWithBuilderEvent {}
