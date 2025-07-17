# Widgetbook - Groceries App Component Library

Widgetbook is an excellent tool for showcasing and testing UI components in Flutter applications.

## How to Run Widgetbook

### 1. Run Widgetbook on simulator/device:
```bash
flutter run -t lib/widgetbook.dart
```

### 2. Run Widgetbook on web:
```bash
flutter run -d chrome -t lib/widgetbook.dart
```

## Showcased Components

### E-commerce Components

#### 1. Grocery Item Card
- **Mango Item**: Interactive card with quantity controls for Mango ($3.34)
- **Avocado Item**: Interactive card with quantity controls for Avocado ($5.48)
- **Zero Quantity**: Card showing item with zero quantity state

#### 2. Checkout Summary Card
- **Sample Checkout**: Standard checkout summary with subtotal, delivery, and total
- **Loading State**: Checkout card with loading spinner
- **High Value Order**: Checkout for high-value orders

#### 3. Product Grid
- **Grocery Products**: Grid layout showing various grocery items
- **Empty Grid**: Empty state when no products are available
- **3 Column Grid**: Compact grid layout with 3 columns

### UI Elements

#### 1. Grocery App Bar
- **Empty Cart**: App bar with no items in cart
- **With Items**: App bar showing cart with items
- **Many Items**: App bar with high item count (99+ badge)

#### 2. Loading States
- **Loading Products**: Loading indicator for product fetching
- **Shimmer Grid**: Skeleton loading with shimmer effect

#### 3. Error States
- **Network Error**: Error state for network connectivity issues
- **Out of Stock**: Error state for unavailable products

### Layout Components

#### 1. Complete Shopping Flow
- **Basket Screen**: Full shopping cart experience with interactive items
- **Product Catalog**: Complete product browsing experience

### Interactive Components

#### 1. Theme Components
- **Grocery Theme Showcase**: Demonstration of themed components

## Widgetbook Features

### Theme Testing
- **Grocery Light**: Test components with light grocery theme
- **Grocery Dark**: Test components with dark grocery theme

### Device Testing
- **iPhone 13**: Test on standard iPhone screen
- **iPhone 13 Pro Max**: Test on large iPhone screen
- **iPhone SE**: Test on compact screen
- **Samsung Galaxy S20**: Test on Android device
- **Samsung Galaxy Note 20**: Test on large Android screen

### Text Scale Testing
- Test with different scale levels: 0.8x, 1.0x, 1.2x, 1.5x, 2.0x

### Localization Testing
- **English (US)**: Test with English localization
- **Vietnamese (VN)**: Test with Vietnamese localization

## How to Add New Widgets to Widgetbook

1. Import the widget into `lib/widgetbook.dart`
2. Add a new `WidgetbookComponent` to the appropriate folder in `directories`
3. Create `WidgetbookUseCase` instances for different widget states
4. Run Widgetbook again to see the results

## Benefits of Using Widgetbook

- **Isolated Testing**: Test individual widgets in isolation
- **Visual Testing**: View widgets in different states and configurations
- **Cross-platform**: Test across multiple devices and platforms
- **Theme Testing**: Test with light and dark themes
- **Accessibility**: Test with different text scales for accessibility
- **Documentation**: Automatically generate documentation for UI components
- **Interactive Development**: Develop and iterate on components quickly
- **State Management**: Test components with different data states
- **Responsive Design**: Test components across different screen sizes

## Component Architecture

The Groceries App component library follows Clean Architecture principles:

- **E-commerce Components**: Business-specific components for shopping functionality
- **UI Elements**: Reusable interface elements
- **Layout Components**: Complex layouts combining multiple components
- **Interactive Components**: Components with advanced user interactions

This structure ensures maintainable, testable, and scalable UI components that can be easily integrated into the main application.
