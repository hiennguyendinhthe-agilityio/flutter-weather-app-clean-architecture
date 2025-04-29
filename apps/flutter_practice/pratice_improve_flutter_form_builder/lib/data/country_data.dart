class CountryPhoneData {
  final String code;
  final String dialCode;
  final String flagEmoji;
  final String name;
  final int minLength;
  final int maxLength;

  const CountryPhoneData({
    required this.code,
    required this.dialCode,
    required this.flagEmoji,
    required this.name,
    required this.minLength,
    required this.maxLength,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountryPhoneData &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() {
    return '$flagEmoji $dialCode ($name)';
  }
}

const List<CountryPhoneData> kCountryData = [
  CountryPhoneData(
      code: 'VN',
      dialCode: '+84',
      flagEmoji: '🇻🇳',
      name: 'Việt Nam',
      minLength: 9,
      maxLength: 10),
  CountryPhoneData(
      code: 'ID',
      dialCode: '+62',
      flagEmoji: '🇮🇩',
      name: 'Indonesia',
      minLength: 9,
      maxLength: 12),
  CountryPhoneData(
      code: 'US',
      dialCode: '+1',
      flagEmoji: '🇺🇸',
      name: 'Hoa Kỳ',
      minLength: 10,
      maxLength: 10),
  CountryPhoneData(
      code: 'GB',
      dialCode: '+44',
      flagEmoji: '🇬🇧',
      name: 'Vương quốc Anh',
      minLength: 10,
      maxLength: 10),
  CountryPhoneData(
      code: 'SG',
      dialCode: '+65',
      flagEmoji: '🇸🇬',
      name: 'Singapore',
      minLength: 8,
      maxLength: 8),
  CountryPhoneData(
      code: 'AU',
      dialCode: '+61',
      flagEmoji: '🇦🇺',
      name: 'Úc',
      minLength: 9,
      maxLength: 9),
  CountryPhoneData(
      code: 'IN',
      dialCode: '+91',
      flagEmoji: '🇮🇳',
      name: 'Ấn Độ',
      minLength: 10,
      maxLength: 10),
];
