# 🏗️ Layout Widgets Summary (Week 5-8)

## 📚 Tổng quan Layout Widgets

Layout Widgets là nhóm widget quan trọng nhất trong Flutter, giúp bạn sắp xếp và tổ chức các widget con theo cách mong muốn. Đây là nền tảng để tạo ra các giao diện phức tạp và đẹp mắt.

## 🎯 Week 5: Expanded & Flexible

### 🔑 Khái niệm chính:
- **Expanded**: BẮT BUỘC widget con chiếm hết không gian có sẵn
- **Flexible**: CHO PHÉP widget con có thể nhỏ hơn không gian có sẵn
- **flex**: Tỷ lệ phân chia không gian (mặc định = 1)

### 💡 Khi nào sử dụng:
- Expanded: Khi muốn widget chiếm hết không gian
- Flexible: Khi widget có thể co giãn nhưng không bắt buộc
- Trong Row/Column để phân chia không gian theo tỷ lệ

### 🎮 Ví dụ thực tế:
```dart
Row(
  children: [
    Container(width: 100, child: Text('Fixed')),
    Expanded(flex: 2, child: TextField()), // 2 phần
    Expanded(flex: 1, child: ElevatedButton()), // 1 phần
  ],
)
```

---

## 🎯 Week 6: Wrap Widget

### 🔑 Khái niệm chính:
- Tự động xuống dòng khi không đủ không gian
- Hỗ trợ cả horizontal và vertical direction
- Có thể điều chỉnh spacing và alignment

### 💡 Khi nào sử dụng:
- Tags, chips động
- Button groups không cố định
- Responsive layout
- Khi không biết trước số lượng items

### 🎮 Ví dụ thực tế:
```dart
Wrap(
  spacing: 8.0,
  runSpacing: 4.0,
  children: tags.map((tag) => Chip(
    label: Text(tag),
    onDeleted: () => removeTag(tag),
  )).toList(),
)
```

---

## 🎯 Week 7: ListView Widget

### 🔑 Khái niệm chính:
- Hiển thị danh sách có thể cuộn
- Chỉ render các item hiển thị trên màn hình (hiệu quả)
- Hỗ trợ nhiều loại: basic, builder, separated

### 💡 Khi nào sử dụng:
- Danh sách dài (contacts, messages, products)
- Infinite scroll
- Chat interfaces
- Settings menus

### 🎮 Performance Tips:
```dart
// ✅ Tốt: Dùng builder cho danh sách dài
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ListTile(
    title: Text(items[index]),
  ),
)

// ❌ Tránh: Dùng ListView() cho danh sách dài
ListView(
  children: items.map((item) => ListTile()).toList(),
)
```

---

## 🎯 Week 8: GridView Widget

### 🔑 Khái niệm chính:
- Hiển thị items theo dạng lưới
- Có thể cố định số cột hoặc kích thước item
- Hỗ trợ scroll và lazy loading

### 💡 Khi nào sử dụng:
- Photo galleries
- Product catalogs
- Dashboard metrics
- Icon grids

### 🎮 Các loại GridView:
```dart
// Cố định số cột
GridView.count(
  crossAxisCount: 2,
  children: items,
)

// Cố định kích thước item
GridView.extent(
  maxCrossAxisExtent: 200,
  children: items,
)

// Dynamic với builder
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
  ),
  itemBuilder: (context, index) => Card(),
)
```

---

## 🚀 Layout Widgets Best Practices

### ⚡ Performance:
1. **Dùng builder constructors** cho danh sách dài
2. **Set itemExtent** nếu biết chiều cao item
3. **Dùng const constructors** khi có thể
4. **Tránh nested scrollable widgets** cùng direction

### 🎨 UI/UX:
1. **Consistent spacing** giữa các items
2. **Responsive design** với Flexible/Expanded
3. **Loading states** cho dynamic content
4. **Empty states** khi không có data

### 🔧 Common Patterns:
```dart
// Responsive layout
Row(
  children: [
    if (isWideScreen) Expanded(flex: 1, child: Sidebar()),
    Expanded(flex: 3, child: MainContent()),
  ],
)

// Infinite scroll
ListView.builder(
  controller: scrollController,
  itemCount: items.length + (isLoading ? 1 : 0),
  itemBuilder: (context, index) {
    if (index == items.length) {
      return CircularProgressIndicator();
    }
    return ListTile(title: Text(items[index]));
  },
)
```

---

## 🎓 Tổng kết Layout Widgets

Sau khi hoàn thành 4 tuần Layout Widgets, bạn đã nắm vững:

✅ **Expanded & Flexible**: Phân chia không gian linh hoạt
✅ **Wrap**: Layout tự động xuống dòng
✅ **ListView**: Danh sách cuộn hiệu quả
✅ **GridView**: Lưới responsive và đẹp mắt

### 🎯 Bước tiếp theo:
Với nền tảng Layout Widgets vững chắc, bạn đã sẵn sàng cho **Interactive Widgets (Week 9-12)** để tạo ra các tương tác người dùng phong phú!

### 💪 Thử thách bản thân:
Hãy tạo một app hoàn chỉnh sử dụng tất cả Layout Widgets đã học:
- Dashboard với GridView
- Chat list với ListView
- Tag selector với Wrap
- Responsive layout với Expanded/Flexible

**Happy coding! 🚀**