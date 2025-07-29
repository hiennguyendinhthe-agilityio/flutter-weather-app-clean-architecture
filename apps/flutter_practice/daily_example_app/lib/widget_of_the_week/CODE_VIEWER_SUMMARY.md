# 💻 Code Viewer System - Tính năng xem và sao chép code

## 🎯 Mục đích
Tạo hệ thống Code Viewer giúp người dùng:
- **Xem source code** của các widget examples
- **Sao chép code** để sử dụng trong dự án
- **Học hỏi** cách implement các widget patterns
- **Tham khảo** best practices

## 🏗️ Kiến trúc hệ thống

### 1. **CodeViewer Widget**
```dart
CodeViewer(
  title: 'Container cơ bản',
  code: 'Container(width: 100, height: 100, color: Colors.blue)',
)
```

**Tính năng:**
- ✅ Expand/Collapse code
- ✅ Copy to clipboard
- ✅ Syntax highlighting (basic)
- ✅ Scrollable content
- ✅ Preview mode (3 dòng đầu)

### 2. **QuickCodeExample Widget**
```dart
QuickCodeExample(
  title: 'Card Example',
  child: Container(...), // Visual widget
  code: 'Container(...)', // Source code
)
```

**Tính năng:**
- ✅ Visual example + code
- ✅ Integrated code viewer
- ✅ One-click copy

### 3. **FloatingCodeButton**
```dart
FloatingCodeButton(
  examples: CommonCodeExamples.containerExamples,
  lessonTitle: 'Container Widget',
)
```

**Tính năng:**
- ✅ Floating action button
- ✅ Bottom sheet với tất cả examples
- ✅ Expandable code sections
- ✅ Quick access to all codes

### 4. **CodeExamplesManager**
```dart
CodeExamplesManager.buildCodeExamplesSection(
  context: context,
  examples: examples,
)
```

**Tính năng:**
- ✅ Quản lý tập trung code examples
- ✅ Consistent UI across lessons
- ✅ Easy integration

## 📚 Code Examples Repository

### **CodeExamples Class**
Chứa tất cả static code strings:
```dart
class CodeExamples {
  static const String containerBasic = '''...''';
  static const String containerCard = '''...''';
  static const String profileCard = '''...''';
  // ... more examples
}
```

### **CommonCodeExamples Class**
Chứa grouped examples cho từng widget:
```dart
class CommonCodeExamples {
  static const List<CodeExample> containerExamples = [...];
  static const List<CodeExample> rowColumnExamples = [...];
  // ... more widget groups
}
```

## 🎮 Cách sử dụng

### **1. Trong lesson widget:**
```dart
import '../../components/code_viewer.dart';
import '../../components/code_examples.dart';
import '../../components/floating_code_button.dart';

class WeekXXWidget extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Floating button để xem tất cả codes
      floatingActionButton: FloatingCodeButton(
        examples: CommonCodeExamples.containerExamples,
        lessonTitle: 'Container Widget',
      ),
      body: Column(
        children: [
          // Quick example với visual + code
          QuickCodeExample(
            title: 'Basic Container',
            code: CodeExamples.containerBasic,
            child: Container(...),
          ),
          
          // Code viewer riêng lẻ
          CodeViewer(
            title: 'Advanced Example',
            code: 'Container(...)',
          ),
        ],
      ),
    );
  }
}
```

### **2. Thêm code examples mới:**
```dart
// Trong CodeExamples class
static const String newExample = '''
Widget(
  property: value,
  child: Child(),
)''';

// Trong CommonCodeExamples class
static const List<CodeExample> newWidgetExamples = [
  CodeExample(
    title: 'Example 1',
    code: CodeExamples.newExample,
    description: 'Mô tả example',
  ),
];
```

## 🎨 UI/UX Features

### **Visual Design:**
- 🎨 **Dark theme** cho code display
- 🎨 **Syntax highlighting** cơ bản
- 🎨 **Consistent colors** (Purple theme)
- 🎨 **Material Design** components

### **User Experience:**
- 📱 **Responsive** design
- 📱 **Touch-friendly** buttons
- 📱 **Smooth animations**
- 📱 **Intuitive navigation**

### **Accessibility:**
- ♿ **Selectable text** cho screen readers
- ♿ **Tooltips** cho buttons
- ♿ **Keyboard navigation**
- ♿ **High contrast** code display

## 🚀 Benefits cho người học

### **1. Learning by Example:**
- Xem code thực tế ngay lập tức
- Hiểu cách implement patterns
- Copy-paste để thử nghiệm

### **2. Reference Material:**
- Tài liệu tham khảo luôn có sẵn
- Quick access qua floating button
- Organized theo từng widget

### **3. Best Practices:**
- Code examples follow Flutter conventions
- Proper naming và structure
- Performance considerations

### **4. Productivity:**
- Không cần search Google
- Instant code snippets
- Ready-to-use examples

## 📈 Tương lai mở rộng

### **Phase 2 Features:**
- [ ] **Syntax highlighting** với colors
- [ ] **Code formatting** tự động
- [ ] **Live preview** trong app
- [ ] **Favorite examples** system

### **Phase 3 Features:**
- [ ] **User-generated examples**
- [ ] **Code sharing** với community
- [ ] **Version control** cho examples
- [ ] **AI-powered** code suggestions

## 🎓 Kết luận

Code Viewer System giúp:
- ✅ **Tăng hiệu quả học tập** với visual + code
- ✅ **Giảm thời gian tìm kiếm** code examples
- ✅ **Cải thiện code quality** với best practices
- ✅ **Tạo trải nghiệm học tập** tốt hơn

**Đây là một tính năng quan trọng giúp Widget of the Week trở thành một learning platform hoàn chỉnh!** 🚀