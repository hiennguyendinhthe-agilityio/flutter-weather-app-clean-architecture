// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WeatherEntity {

 String get cityName; String get countryCode; double get temperature; double get feelsLike; double get minTemp; double get maxTemp; String get condition; String get iconCode; int get humidity; double get windSpeed; DateTime get lastUpdated; DateTime get localTime; DateTime get sunriseTime; DateTime get sunsetTime;
/// Create a copy of WeatherEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherEntityCopyWith<WeatherEntity> get copyWith => _$WeatherEntityCopyWithImpl<WeatherEntity>(this as WeatherEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherEntity&&(identical(other.cityName, cityName) || other.cityName == cityName)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.feelsLike, feelsLike) || other.feelsLike == feelsLike)&&(identical(other.minTemp, minTemp) || other.minTemp == minTemp)&&(identical(other.maxTemp, maxTemp) || other.maxTemp == maxTemp)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.iconCode, iconCode) || other.iconCode == iconCode)&&(identical(other.humidity, humidity) || other.humidity == humidity)&&(identical(other.windSpeed, windSpeed) || other.windSpeed == windSpeed)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.localTime, localTime) || other.localTime == localTime)&&(identical(other.sunriseTime, sunriseTime) || other.sunriseTime == sunriseTime)&&(identical(other.sunsetTime, sunsetTime) || other.sunsetTime == sunsetTime));
}


@override
int get hashCode => Object.hash(runtimeType,cityName,countryCode,temperature,feelsLike,minTemp,maxTemp,condition,iconCode,humidity,windSpeed,lastUpdated,localTime,sunriseTime,sunsetTime);

@override
String toString() {
  return 'WeatherEntity(cityName: $cityName, countryCode: $countryCode, temperature: $temperature, feelsLike: $feelsLike, minTemp: $minTemp, maxTemp: $maxTemp, condition: $condition, iconCode: $iconCode, humidity: $humidity, windSpeed: $windSpeed, lastUpdated: $lastUpdated, localTime: $localTime, sunriseTime: $sunriseTime, sunsetTime: $sunsetTime)';
}


}

/// @nodoc
abstract mixin class $WeatherEntityCopyWith<$Res>  {
  factory $WeatherEntityCopyWith(WeatherEntity value, $Res Function(WeatherEntity) _then) = _$WeatherEntityCopyWithImpl;
@useResult
$Res call({
 String cityName, String countryCode, double temperature, double feelsLike, double minTemp, double maxTemp, String condition, String iconCode, int humidity, double windSpeed, DateTime lastUpdated, DateTime localTime, DateTime sunriseTime, DateTime sunsetTime
});




}
/// @nodoc
class _$WeatherEntityCopyWithImpl<$Res>
    implements $WeatherEntityCopyWith<$Res> {
  _$WeatherEntityCopyWithImpl(this._self, this._then);

  final WeatherEntity _self;
  final $Res Function(WeatherEntity) _then;

/// Create a copy of WeatherEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cityName = null,Object? countryCode = null,Object? temperature = null,Object? feelsLike = null,Object? minTemp = null,Object? maxTemp = null,Object? condition = null,Object? iconCode = null,Object? humidity = null,Object? windSpeed = null,Object? lastUpdated = null,Object? localTime = null,Object? sunriseTime = null,Object? sunsetTime = null,}) {
  return _then(_self.copyWith(
cityName: null == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,feelsLike: null == feelsLike ? _self.feelsLike : feelsLike // ignore: cast_nullable_to_non_nullable
as double,minTemp: null == minTemp ? _self.minTemp : minTemp // ignore: cast_nullable_to_non_nullable
as double,maxTemp: null == maxTemp ? _self.maxTemp : maxTemp // ignore: cast_nullable_to_non_nullable
as double,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,iconCode: null == iconCode ? _self.iconCode : iconCode // ignore: cast_nullable_to_non_nullable
as String,humidity: null == humidity ? _self.humidity : humidity // ignore: cast_nullable_to_non_nullable
as int,windSpeed: null == windSpeed ? _self.windSpeed : windSpeed // ignore: cast_nullable_to_non_nullable
as double,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,localTime: null == localTime ? _self.localTime : localTime // ignore: cast_nullable_to_non_nullable
as DateTime,sunriseTime: null == sunriseTime ? _self.sunriseTime : sunriseTime // ignore: cast_nullable_to_non_nullable
as DateTime,sunsetTime: null == sunsetTime ? _self.sunsetTime : sunsetTime // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WeatherEntity].
extension WeatherEntityPatterns on WeatherEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeatherEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeatherEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeatherEntity value)  $default,){
final _that = this;
switch (_that) {
case _WeatherEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeatherEntity value)?  $default,){
final _that = this;
switch (_that) {
case _WeatherEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String cityName,  String countryCode,  double temperature,  double feelsLike,  double minTemp,  double maxTemp,  String condition,  String iconCode,  int humidity,  double windSpeed,  DateTime lastUpdated,  DateTime localTime,  DateTime sunriseTime,  DateTime sunsetTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeatherEntity() when $default != null:
return $default(_that.cityName,_that.countryCode,_that.temperature,_that.feelsLike,_that.minTemp,_that.maxTemp,_that.condition,_that.iconCode,_that.humidity,_that.windSpeed,_that.lastUpdated,_that.localTime,_that.sunriseTime,_that.sunsetTime);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String cityName,  String countryCode,  double temperature,  double feelsLike,  double minTemp,  double maxTemp,  String condition,  String iconCode,  int humidity,  double windSpeed,  DateTime lastUpdated,  DateTime localTime,  DateTime sunriseTime,  DateTime sunsetTime)  $default,) {final _that = this;
switch (_that) {
case _WeatherEntity():
return $default(_that.cityName,_that.countryCode,_that.temperature,_that.feelsLike,_that.minTemp,_that.maxTemp,_that.condition,_that.iconCode,_that.humidity,_that.windSpeed,_that.lastUpdated,_that.localTime,_that.sunriseTime,_that.sunsetTime);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String cityName,  String countryCode,  double temperature,  double feelsLike,  double minTemp,  double maxTemp,  String condition,  String iconCode,  int humidity,  double windSpeed,  DateTime lastUpdated,  DateTime localTime,  DateTime sunriseTime,  DateTime sunsetTime)?  $default,) {final _that = this;
switch (_that) {
case _WeatherEntity() when $default != null:
return $default(_that.cityName,_that.countryCode,_that.temperature,_that.feelsLike,_that.minTemp,_that.maxTemp,_that.condition,_that.iconCode,_that.humidity,_that.windSpeed,_that.lastUpdated,_that.localTime,_that.sunriseTime,_that.sunsetTime);case _:
  return null;

}
}

}

/// @nodoc


class _WeatherEntity implements WeatherEntity {
  const _WeatherEntity({required this.cityName, required this.countryCode, required this.temperature, required this.feelsLike, required this.minTemp, required this.maxTemp, required this.condition, required this.iconCode, required this.humidity, required this.windSpeed, required this.lastUpdated, required this.localTime, required this.sunriseTime, required this.sunsetTime});
  

@override final  String cityName;
@override final  String countryCode;
@override final  double temperature;
@override final  double feelsLike;
@override final  double minTemp;
@override final  double maxTemp;
@override final  String condition;
@override final  String iconCode;
@override final  int humidity;
@override final  double windSpeed;
@override final  DateTime lastUpdated;
@override final  DateTime localTime;
@override final  DateTime sunriseTime;
@override final  DateTime sunsetTime;

/// Create a copy of WeatherEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherEntityCopyWith<_WeatherEntity> get copyWith => __$WeatherEntityCopyWithImpl<_WeatherEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeatherEntity&&(identical(other.cityName, cityName) || other.cityName == cityName)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.feelsLike, feelsLike) || other.feelsLike == feelsLike)&&(identical(other.minTemp, minTemp) || other.minTemp == minTemp)&&(identical(other.maxTemp, maxTemp) || other.maxTemp == maxTemp)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.iconCode, iconCode) || other.iconCode == iconCode)&&(identical(other.humidity, humidity) || other.humidity == humidity)&&(identical(other.windSpeed, windSpeed) || other.windSpeed == windSpeed)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.localTime, localTime) || other.localTime == localTime)&&(identical(other.sunriseTime, sunriseTime) || other.sunriseTime == sunriseTime)&&(identical(other.sunsetTime, sunsetTime) || other.sunsetTime == sunsetTime));
}


@override
int get hashCode => Object.hash(runtimeType,cityName,countryCode,temperature,feelsLike,minTemp,maxTemp,condition,iconCode,humidity,windSpeed,lastUpdated,localTime,sunriseTime,sunsetTime);

@override
String toString() {
  return 'WeatherEntity(cityName: $cityName, countryCode: $countryCode, temperature: $temperature, feelsLike: $feelsLike, minTemp: $minTemp, maxTemp: $maxTemp, condition: $condition, iconCode: $iconCode, humidity: $humidity, windSpeed: $windSpeed, lastUpdated: $lastUpdated, localTime: $localTime, sunriseTime: $sunriseTime, sunsetTime: $sunsetTime)';
}


}

/// @nodoc
abstract mixin class _$WeatherEntityCopyWith<$Res> implements $WeatherEntityCopyWith<$Res> {
  factory _$WeatherEntityCopyWith(_WeatherEntity value, $Res Function(_WeatherEntity) _then) = __$WeatherEntityCopyWithImpl;
@override @useResult
$Res call({
 String cityName, String countryCode, double temperature, double feelsLike, double minTemp, double maxTemp, String condition, String iconCode, int humidity, double windSpeed, DateTime lastUpdated, DateTime localTime, DateTime sunriseTime, DateTime sunsetTime
});




}
/// @nodoc
class __$WeatherEntityCopyWithImpl<$Res>
    implements _$WeatherEntityCopyWith<$Res> {
  __$WeatherEntityCopyWithImpl(this._self, this._then);

  final _WeatherEntity _self;
  final $Res Function(_WeatherEntity) _then;

/// Create a copy of WeatherEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cityName = null,Object? countryCode = null,Object? temperature = null,Object? feelsLike = null,Object? minTemp = null,Object? maxTemp = null,Object? condition = null,Object? iconCode = null,Object? humidity = null,Object? windSpeed = null,Object? lastUpdated = null,Object? localTime = null,Object? sunriseTime = null,Object? sunsetTime = null,}) {
  return _then(_WeatherEntity(
cityName: null == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,feelsLike: null == feelsLike ? _self.feelsLike : feelsLike // ignore: cast_nullable_to_non_nullable
as double,minTemp: null == minTemp ? _self.minTemp : minTemp // ignore: cast_nullable_to_non_nullable
as double,maxTemp: null == maxTemp ? _self.maxTemp : maxTemp // ignore: cast_nullable_to_non_nullable
as double,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,iconCode: null == iconCode ? _self.iconCode : iconCode // ignore: cast_nullable_to_non_nullable
as String,humidity: null == humidity ? _self.humidity : humidity // ignore: cast_nullable_to_non_nullable
as int,windSpeed: null == windSpeed ? _self.windSpeed : windSpeed // ignore: cast_nullable_to_non_nullable
as double,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,localTime: null == localTime ? _self.localTime : localTime // ignore: cast_nullable_to_non_nullable
as DateTime,sunriseTime: null == sunriseTime ? _self.sunriseTime : sunriseTime // ignore: cast_nullable_to_non_nullable
as DateTime,sunsetTime: null == sunsetTime ? _self.sunsetTime : sunsetTime // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
