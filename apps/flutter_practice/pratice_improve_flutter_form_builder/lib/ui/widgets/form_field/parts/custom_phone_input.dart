import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../data/country_data.dart';

class CustomPhoneInputWithBottomSheet extends StatefulWidget {
  final String? initialValue;
  final String initialCountryCode;
  final InputDecoration decoration;
  final Function(String?) onChanged;

  final TextInputType keyboardType;
  final List<CountryPhoneData> countries;

  const CustomPhoneInputWithBottomSheet({
    super.key,
    this.initialValue,
    required this.initialCountryCode,
    required this.decoration,
    required this.onChanged,
    required this.keyboardType,
    required this.countries,
  });

  @override
  CustomPhoneInputWithBottomSheetState createState() =>
      CustomPhoneInputWithBottomSheetState();
}

class CustomPhoneInputWithBottomSheetState
    extends State<CustomPhoneInputWithBottomSheet> {
  late CountryPhoneData _selectedCountry;
  final TextEditingController _phoneNumberController = TextEditingController();
  String? _lastReportedValue;

  late List<TextInputFormatter> _inputFormatters;

  @override
  void initState() {
    super.initState();

    _selectedCountry = widget.countries.firstWhere(
      (c) => c.code.toUpperCase() == widget.initialCountryCode.toUpperCase(),
      orElse: () => widget.countries.firstWhere(
          (c) => c.code.toUpperCase() == 'VN',
          orElse: () => widget.countries.first),
    );

    _updateInputFormatters();

    if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
      String numberPart = widget.initialValue!;

      List<CountryPhoneData> sortedCountries = List.from(widget.countries);
      sortedCountries
          .sort((a, b) => b.dialCode.length.compareTo(a.dialCode.length));

      for (final country in sortedCountries) {
        if (widget.initialValue!.startsWith(country.dialCode)) {
          _selectedCountry = country;
          numberPart = widget.initialValue!.substring(country.dialCode.length);

          _updateInputFormatters();
          break;
        }
      }
      _phoneNumberController.text = numberPart;
    }

    _phoneNumberController.addListener(_handleInputChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _reportValue();
      }
    });
  }

  @override
  void dispose() {
    _phoneNumberController.removeListener(_handleInputChanged);
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _updateInputFormatters() {
    _inputFormatters = [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(_selectedCountry.maxLength),
    ];

    if (_phoneNumberController.text.length > _selectedCountry.maxLength) {
      _phoneNumberController.text =
          _phoneNumberController.text.substring(0, _selectedCountry.maxLength);
    }
  }

  void _handleInputChanged() {
    if (mounted) {
      _reportValue();
    }
  }

  void _handleCountryChanged(CountryPhoneData newCountry) {
    if (newCountry != _selectedCountry) {
      setState(() {
        _selectedCountry = newCountry;

        _updateInputFormatters();
      });

      _reportValue();
    }
  }

  void _reportValue() {
    final number = _phoneNumberController.text;
    final completeNumber =
        number.isNotEmpty ? "${_selectedCountry.dialCode}$number" : null;

    if (completeNumber != _lastReportedValue) {
      widget.onChanged(completeNumber);
      _lastReportedValue = completeNumber;
    }
  }

  void _showCountryPickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final List<CountryPhoneData> mutableCountries =
            List.from(widget.countries);

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            List<CountryPhoneData> filteredCountries = mutableCountries;

            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.6,
              minChildSize: 0.3,
              maxChildSize: 0.9,
              builder: (_, controller) => Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        controller: controller,
                        itemCount: filteredCountries.length,
                        itemBuilder: (context, index) {
                          final country = filteredCountries[index];
                          return ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            leading: Text(country.flagEmoji,
                                style: TextStyle(fontSize: 24)),
                            title: Text(country.name),
                            trailing: Text(country.dialCode),
                            onTap: () {
                              _handleCountryChanged(country);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderSide = BorderSide(
      color: theme.colorScheme.outline.withValues(alpha: 0.5),
    );
    final errorBorderSide = BorderSide(
      color: theme.colorScheme.error,
    );
    final focusedBorderSide = BorderSide(
      color: theme.colorScheme.primary,
      width: 1.5,
    );
    final focusedErrorBorderSide = BorderSide(
      color: theme.colorScheme.error,
      width: 2,
    );

    return InputDecorator(
      decoration: widget.decoration.copyWith(
        enabledBorder: OutlineInputBorder(
            borderSide: borderSide, borderRadius: BorderRadius.circular(4)),
        focusedBorder: OutlineInputBorder(
            borderSide: focusedBorderSide,
            borderRadius: BorderRadius.circular(4)),
        errorBorder: OutlineInputBorder(
            borderSide: errorBorderSide,
            borderRadius: BorderRadius.circular(4)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: focusedErrorBorderSide,
            borderRadius: BorderRadius.circular(4)),
        contentPadding: EdgeInsets.zero,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => _showCountryPickerBottomSheet(context),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedCountry.flagEmoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _selectedCountry.dialCode,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_drop_down, color: theme.hintColor),
                ],
              ),
            ),
          ),
          Container(
            height: 28,
            width: 1,
            color: theme.dividerColor.withValues(alpha: 0.5),
            margin: const EdgeInsets.symmetric(vertical: 10.0),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextField(
                controller: _phoneNumberController,
                keyboardType: widget.keyboardType,
                inputFormatters: _inputFormatters,
                style: theme.textTheme.titleMedium,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  hintText: 'Please enter your phone number',
                  hintStyle: theme.textTheme.titleMedium
                      ?.copyWith(color: theme.hintColor),
                  isDense: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
