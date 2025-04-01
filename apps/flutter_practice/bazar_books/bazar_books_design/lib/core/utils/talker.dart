// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

final talker = Talker();

final dio = Dio()
  ..interceptors.add(
    TalkerDioLogger(
      talker: talker,
    ),
  );
