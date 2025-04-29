# Discord Application Form

A Flutter application that implements a multi-step job application form for Discord with GetX state management, form validation, and abstracted UI components.

## Features

- State management with GetX
- Form validation using flutter_form_builder
- Abstracted form fields and UI components
- Custom form validation logic
- Responsive design that matches the provided UI
- Proper form state handling (validation, success indicators)

## Project Structure

```
lib/
  ├── app/
  │   ├── bindings/         # Dependency injection
  │   ├── controllers/      # GetX controllers
  │   ├── data/             # Models and repositories
  │   ├── modules/          # Feature modules
  │   ├── routes/           # App navigation
  │   └── themes/           # App theming
  ├── core/
  │   ├── abstractions/     # Abstract classes
  │   ├── utils/            # Utilities
  │   └── widgets/          # Reusable widgets
  └── main.dart             # App entry point
```

## How to Use

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

## Form Field Abstractions

The app uses abstracted form fields to ensure consistency and reusability:

- `AbstractField`: Base class for all form fields
- `CustomTextFormField`: Implementation of text inputs
- `EmailFormField`: Specialized field for email validation
- `PhoneFormField`: Field for phone number input with country code
- `WebsiteFormField`: Field for URL validation

## Form Validation

- Required fields validation
- Email format validation
- Phone number validation
- URL format validation
- Visual feedback with green checkmarks for valid inputs

## State Management

The app uses GetX for state management:
- Reactive form state
- Form validation status
- Button enable/disable based on validation

## Customization

The app uses an abstract theme implementation that can be easily customized:
- Colors
- Text styles
- Input decorations
- Button styles
