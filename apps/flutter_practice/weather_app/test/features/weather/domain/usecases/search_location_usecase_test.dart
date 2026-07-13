import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/features/weather/domain/entities/location_entity.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/weather/domain/usecases/search_location_usecase.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late SearchLocationUseCase usecase;
  late MockWeatherRepository mockWeatherRepository;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    usecase = SearchLocationUseCase(mockWeatherRepository);
  });

  final tLocations = [
    LocationEntity(
      name: 'London',
      lat: 51.5074,
      lon: -0.1278,
      country: 'GB',
      state: 'England',
    ),
  ];

  const tQuery = 'London';

  test('should search locations from the repository', () async {
    // Arrange
    when(() => mockWeatherRepository.searchLocation(tQuery))
        .thenAnswer((_) async => tLocations);

    // Act
    final result = await usecase.execute(tQuery);

    // Assert
    expect(result, tLocations);
    verify(() => mockWeatherRepository.searchLocation(tQuery)).called(1);
    verifyNoMoreInteractions(mockWeatherRepository);
  });
}
