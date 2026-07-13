import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/features/weather/domain/entities/forecast_entity.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/weather/domain/usecases/get_forecast_usecase.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late GetForecastUseCase usecase;
  late MockWeatherRepository mockWeatherRepository;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    usecase = GetForecastUseCase(mockWeatherRepository);
  });

  final tForecast = ForecastEntity(
    cityName: 'London',
    items: [],
  );

  const tCity = 'London';
  const tLang = 'en';

  test('should get forecast for the city from the repository', () async {
    // Arrange
    when(() => mockWeatherRepository.getForecast(city: tCity, lang: tLang))
        .thenAnswer((_) async => tForecast);

    // Act
    final result = await usecase.execute(city: tCity, lang: tLang);

    // Assert
    expect(result, tForecast);
    verify(() => mockWeatherRepository.getForecast(city: tCity, lang: tLang)).called(1);
    verifyNoMoreInteractions(mockWeatherRepository);
  });

  test('should propagate exceptions from repository', () async {
    // Arrange
    when(() => mockWeatherRepository.getForecast(city: tCity, lang: tLang))
        .thenThrow(Exception('Network Error'));

    // Act
    final call = usecase.execute;

    // Assert
    expect(() => call(city: tCity, lang: tLang), throwsA(isA<Exception>()));
    verify(() => mockWeatherRepository.getForecast(city: tCity, lang: tLang)).called(1);
  });
}
