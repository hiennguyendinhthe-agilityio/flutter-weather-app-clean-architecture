import 'package:flutter_test/flutter_test.dart';

import '../../../helper/utils.dart';
import 'auth_bloc.features.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  BazBlocTest(
    description: 'AuthBloc Test',
    features: [
      BazBlocTestFeature(
        description: 'Authentication',
        scenarios: [
          AuthBlocPasswordVisibilityToggledScenario(),
        ],
      ),
    ],
  ).test();
}
