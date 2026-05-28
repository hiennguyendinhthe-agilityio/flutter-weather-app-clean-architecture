import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_date_provider.g.dart';

@riverpod
class SelectedDate extends _$SelectedDate {
  @override
  DateTime build() {
    // Trả về ngày mặc định đồng bộ với lịch (2024-04-18 ứng với index 3)
    return DateTime(2024, 4, 18);
  }

  void selectDate(DateTime date) {
    state = DateTime(date.year, date.month, date.day);
  }
}
