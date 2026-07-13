import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/features/weather/domain/entities/forecast_entity.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/weather/domain/usecases/get_forecast_by_coord_usecase.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late GetForecastByCoordUseCase usecase;
  late MockWeatherRepository mockWeatherRepository;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    usecase = GetForecastByCoordUseCase(mockWeatherRepository);
  });

  final tForecast = ForecastEntity(
    cityName: 'London',
    items: [],
  );

  const tLat = 51.5074;
  const tLon = -0.1278;
  const tLang = 'en';

  test('should get forecast by coordinates from the repository', () async {
    // Arrange
    when(() => mockWeatherRepository.getForecastByCoord(lat: tLat, lon: tLon, lang: tLang))
        .thenAnswer((_) async => tForecast);

    // Act
    final result = await usecase.execute(lat: tLat, lon: tLon, lang: tLang);

    // Assert
    expect(result, tForecast);
    verify(() => mockWeatherRepository.getForecastByCoord(lat: tLat, lon: tLon, lang: tLang)).called(1);
    verifyNoMoreInteractions(mockWeatherRepository);
  });
}
