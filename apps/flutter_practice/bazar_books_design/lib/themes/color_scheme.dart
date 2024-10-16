part of 'app_theme.dart';

final ColorScheme _lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: BazColorTokens.generalPrimary[500]!,
  onPrimary: BazColorTokens.generalPrimary[50]!,
  primaryContainer: BazColorTokens.generalPurples[5],
  onPrimaryContainer: BazColorTokens.generalPurples[1],
  secondary: BazColorTokens.generalPurples[2]!,
  onSecondary: BazColorTokens.generalGreyscale[50]!,
  secondaryContainer: BazColorTokens.generalPurples[3],
  onSecondaryContainer: BazColorTokens.generalGreyscale[900],
  tertiary: BazColorTokens.generalGreyscale[500],
  onTertiary: BazColorTokens.generalYellows[2],
  tertiaryContainer: BazColorTokens.generalPurples[5],
  onTertiaryContainer: BazColorTokens.generalPurples[5],
  surfaceBright: BazColorTokens.generalPurples[3],
  surfaceDim: BazColorTokens.generalPurples[1],
  surfaceContainerLowest: BazColorTokens.backgroundGrey,
  surfaceContainerHighest: BazColorTokens.generalPurples[5],
  onSurfaceVariant: BazColorTokens.generalPurples[2],
  surfaceTint: BazColorTokens.generalPurples[2],
  surface: BazColorTokens.generalPrimaryRegWhite,
  onSurface: BazColorTokens.generalPurples[1]!,
  outline: BazColorTokens.generalPurples[3],
  outlineVariant: BazColorTokens.generalPurples[4],
  error: BazColorTokens.generalReds,
  onError: BazColorTokens.generalPrimaryRegWhite,
  errorContainer: BazColorTokens.generalPurples[5],
  onErrorContainer: BazColorTokens.generalPurples[1],
);

final ColorScheme _darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: BazColorTokens.generalPrimary[300] ?? Colors.grey,
  onPrimary: BazColorTokens.generalPrimary[50] ??
      BazColorTokens.generalPrimaryRegWhite,
  primaryContainer: BazColorTokens.generalPurples[7] ?? Colors.deepPurple,
  onPrimaryContainer:
      BazColorTokens.generalPurples[2] ?? BazColorTokens.generalPrimaryRegWhite,
  secondary: BazColorTokens.generalPurples[6] ?? Colors.purple,
  onSecondary: BazColorTokens.generalGreyscale[100] ??
      BazColorTokens.generalPrimaryRegWhite,
  secondaryContainer: BazColorTokens.generalPurples[8] ?? Colors.purpleAccent,
  onSecondaryContainer: BazColorTokens.generalPrimaryRegWhite,
  tertiary: BazColorTokens.generalGreyscale[400] ?? Colors.grey,
  onTertiary: BazColorTokens.generalYellows,
  tertiaryContainer:
      BazColorTokens.generalPurples[7] ?? Colors.deepPurpleAccent,
  onTertiaryContainer: BazColorTokens.generalPurples[5] ?? Colors.purpleAccent,
  surfaceBright: BazColorTokens.generalPurples[8] ?? Colors.deepPurple,
  surfaceDim: BazColorTokens.generalPurples[6] ?? Colors.deepPurple[700],
  surfaceContainerLowest: BazColorTokens.shadow,
  surfaceContainerHighest:
      BazColorTokens.generalPurples[9] ?? Colors.purple[900],
  onSurfaceVariant: BazColorTokens.generalPurples[5] ?? Colors.grey,
  surfaceTint: BazColorTokens.generalPurples[4] ?? Colors.purpleAccent,
  surface: BazColorTokens.shadow,
  onSurface: BazColorTokens.generalGreyscale[100] ??
      BazColorTokens.generalPrimaryRegWhite,
  outline: BazColorTokens.generalPurples[7] ?? Colors.purple,
  outlineVariant: BazColorTokens.generalPurples[6] ?? Colors.purpleAccent,
  error: BazColorTokens.generalReds,
  onError: BazColorTokens.generalPrimaryRegWhite,
  errorContainer: BazColorTokens.generalPurples[8] ?? Colors.red[900],
  onErrorContainer: BazColorTokens.generalPurples[3] ?? Colors.red[100],
);
