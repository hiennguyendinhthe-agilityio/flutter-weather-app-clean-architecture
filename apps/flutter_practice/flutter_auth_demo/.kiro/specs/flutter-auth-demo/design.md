# Design Document

## Overview

This design document outlines the architecture and implementation approach for a Flutter authentication demo application. The app follows clean architecture principles with clear separation of concerns, using modern Flutter development patterns including dependency injection, state management with Provider, and HTTP communication with Dio.

The application implements a complete authentication flow with three main screens: Sign Up, Login, and Home, all connected to a MockAPI backend for user management.

## Architecture

### Layer Architecture

The application follows a layered architecture pattern:

```
UI Layer (Pages/Widgets)
    ↓
State Management Layer (Providers)
    ↓
Business Logic Layer (Services)
    ↓
Data Layer (API Client/Models)
```

### Dependency Injection

- **get_it**: Service locator for dependency injection
- **injectable**: Code generation for dependency registration
- All services, providers, and API clients are registered as singletons
- Dependencies are injected through constructors for better testability

### State Management

- **Provider**: Used with ChangeNotifier pattern for reactive state management
- **UserProvider**: Manages authentication state and user data
- **AuthProvider**: Handles authentication operations (login/signup)
- State is lifted up to appropriate levels to minimize rebuilds

## Components and Interfaces

### Core Models

#### ApiUser Model
```dart
class ApiUser {
  final String id;
  final DateTime createdAt;
  final String name;
  final String avatar;
  final String email;
}
```

#### AuthState Enum
```dart
enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error
}
```

### Services Layer

#### AuthService
- **Purpose**: Handles all authentication-related business logic
- **Methods**:
  - `Future<ApiUser> signUp(String name, String email, String password)`
  - `Future<ApiUser> login(String email, String password)`
  - `Future<void> logout()`
- **Responsibilities**:
  - API communication for auth operations
  - Password validation (simulated)
  - Error handling and transformation

#### StorageService
- **Purpose**: Manages local data persistence
- **Methods**:
  - `Future<void> saveUser(ApiUser user)`
  - `Future<ApiUser?> getUser()`
  - `Future<void> saveToken(String token)`
  - `Future<String?> getToken()`
  - `Future<void> clearAll()`
- **Implementation**: Uses SharedPreferences for local storage

### State Management Layer

#### UserProvider
- **Purpose**: Manages global user state and authentication status
- **State Properties**:
  - `ApiUser? currentUser`
  - `AuthState authState`
  - `String? errorMessage`
- **Methods**:
  - `Future<void> login(String email, String password)`
  - `Future<void> signUp(String name, String email, String password)`
  - `Future<void> logout()`
  - `Future<void> checkAuthStatus()`

### Data Layer

#### ApiClient
- **Purpose**: HTTP client wrapper using Dio
- **Configuration**:
  - Base URL: `https://66e29593494df9a478e23cab.mockapi.io/api/v1/`
  - Request/Response interceptors for logging
  - Error handling interceptor
- **Methods**:
  - `Future<ApiUser> createUser(Map<String, dynamic> userData)`
  - `Future<List<ApiUser>> getUserByEmail(String email)`

### UI Layer

#### Pages Structure

**SignUpPage**
- Form with Name, Email, Password fields
- Real-time validation
- Loading state during API calls
- Error message display
- Navigation to LoginPage on success

**LoginPage**
- Form with Email, Password fields
- Input validation
- Loading state management
- Error handling
- Navigation to HomePage on success

**HomePage**
- Welcome message with user name
- User information display
- Logout functionality
- Protected route (requires authentication)

#### Shared Widgets

**CustomTextField**
- Reusable text input component
- Built-in validation support
- Consistent styling across the app

**LoadingButton**
- Button with loading state
- Prevents multiple taps during operations
- Consistent button styling

**ErrorMessage**
- Standardized error display component
- Dismissible error messages
- Consistent error styling

## Data Models

### API Request/Response Models

#### Sign Up Request
```json
{
  "name": "John Doe",
  "email": "john.doe@example.com"
}
```

#### API User Response
```json
{
  "id": "1",
  "createdAt": "2024-07-15T12:00:00.000Z",
  "name": "John Doe",
  "avatar": "https://example.com/avatar.png",
  "email": "john.doe@example.com"
}
```

### Local Storage Models

#### Stored User Data
```json
{
  "user": {
    "id": "1",
    "name": "John Doe",
    "email": "john.doe@example.com",
    "avatar": "https://example.com/avatar.png"
  },
  "token": "simulated_jwt_token_12345",
  "loginTime": "2024-07-15T12:00:00.000Z"
}
```

## Error Handling

### Error Categories

1. **Validation Errors**
   - Empty field validation
   - Email format validation
   - Password length validation
   - Handled at UI level with immediate feedback

2. **Network Errors**
   - Connection timeout
   - No internet connection
   - Server unavailable
   - Handled in ApiClient with user-friendly messages

3. **API Errors**
   - User already exists (409)
   - User not found (404)
   - Invalid credentials
   - Handled in AuthService with specific error messages

4. **Storage Errors**
   - Failed to save/retrieve data
   - Handled in StorageService with fallback behavior

### Error Flow

```
UI Layer → Provider → Service → API Client
    ↑         ↑         ↑         ↑
Error Display ← Error State ← Error Transform ← HTTP Error
```

## Testing Strategy

### Unit Testing

**UserProvider Tests**
- Mock AuthService and StorageService
- Test login success/failure scenarios
- Test signup validation and API integration
- Test logout functionality
- Test authentication state changes

**AuthService Tests**
- Mock ApiClient
- Test API request/response handling
- Test error transformation
- Test password validation logic

### Integration Testing

**Authentication Flow Test**
- End-to-end login flow using Patrol
- Test navigation between screens
- Test form validation and submission
- Test error handling and display
- Test successful authentication and data persistence

### Widget Testing

**Form Validation Tests**
- Test individual form field validation
- Test form submission with invalid data
- Test loading states and error displays

## Navigation and Routing

### Route Structure

```
/ (Initial Route)
├── /login (LoginPage)
├── /signup (SignUpPage)
└── /home (HomePage - Protected)
```

### Navigation Logic

1. **App Initialization**:
   - Check stored authentication token
   - Navigate to HomePage if authenticated
   - Navigate to LoginPage if not authenticated

2. **Authentication Flow**:
   - SignUp → Success → LoginPage
   - Login → Success → HomePage
   - Logout → LoginPage

3. **Route Guards**:
   - HomePage requires authentication
   - Redirect to LoginPage if not authenticated

## Security Considerations

### Data Protection
- Sensitive data (tokens) stored securely using SharedPreferences
- No plain text password storage
- API communication over HTTPS

### Input Validation
- Client-side validation for immediate feedback
- Server-side validation simulation
- XSS prevention through proper input sanitization

### Authentication
- Simulated JWT token for session management
- Token expiration handling
- Automatic logout on token expiry

## Performance Optimizations

### State Management
- Minimal widget rebuilds using Provider selectors
- Lazy loading of user data
- Efficient state updates

### Network Optimization
- Request caching where appropriate
- Connection timeout configuration
- Retry logic for failed requests

### UI Performance
- Efficient form validation
- Debounced input validation
- Optimized widget tree structure