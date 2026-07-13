import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/weather/domain/usecases/get_current_weather_by_coord_usecase.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late GetCurrentWeatherByCoordUseCase usecase;
  late MockWeatherRepository mockWeatherRepository;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    usecase = GetCurrentWeatherByCoordUseCase(mockWeatherRepository);
  });

  final tWeather = WeatherEntity(
    cityName: 'London',
    countryCode: 'GB',
    temperature: 20.0,
    feelsLike: 19.5,
    minTemp: 18.0,
    maxTemp: 22.0,
    condition: 'Clouds',
    iconCode: '04d',
    humidity: 70,
    windSpeed: 5.0,
    lastUpdated: DateTime.now(),
    localTime: DateTime.now(),
    sunriseTime: DateTime.now(),
    sunsetTime: DateTime.now(),
  );

  const tLat = 51.5074;
  const tLon = -0.1278;
  const tLang = 'en';

  test('should get current weather by coordinates from the repository', () async {
    // Arrange
    when(() => mockWeatherRepository.getCurrentWeatherByCoord(lat: tLat, lon: tLon, lang: tLang))
        .thenAnswer((_) async => tWeather);

    // Act
    final result = await usecase.execute(lat: tLat, lon: tLon, lang: tLang);

    // Assert
    expect(result, tWeather);
    verify(() => mockWeatherRepository.getCurrentWeatherByCoord(lat: tLat, lon: tLon, lang: tLang)).called(1);
    verifyNoMoreInteractions(mockWeatherRepository);
  });
}
