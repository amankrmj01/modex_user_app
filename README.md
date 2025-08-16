# Modex User App

A comprehensive Flutter food delivery application built for customers to browse restaurants, manage
orders, and track deliveries efficiently. This app provides users with an intuitive interface to
discover restaurants, add items to cart, place orders, and manage their delivery experience.

The application follows clean architecture principles with BLoC pattern for state management,
ensuring scalable and maintainable code structure.

## Folder Structure

```
lib/
├── main.dart                    # Application entry point with providers setup
├── bloc/                        # State management using BLoC pattern
│   ├── auth/                    # Authentication related business logic
│   │   ├── auth_bloc.dart
│   │   ├── auth_event.dart
│   │   └── auth_state.dart
│   ├── cart/                    # Shopping cart management
│   │   ├── cart_bloc.dart
│   │   ├── cart_event.dart
│   │   └── cart_state.dart
│   ├── menu/                    # Restaurant menu handling
│   ├── order/                   # Order management business logic
│   │   ├── order_bloc.dart
│   │   ├── order_event.dart
│   │   └── order_state.dart
│   ├── order_history/           # Order history management
│   └── restaurant/              # Restaurant browsing logic
├── data/                        # Data layer containing models and repositories
│   ├── models/                  # Data models
│   │   ├── cart_model.dart      # Shopping cart entity model
│   │   ├── menu_item_model.dart # Menu item entity model
│   │   ├── order_model.dart     # Order entity model
│   │   ├── restaurant_model.dart# Restaurant entity model
│   │   └── user_model.dart      # User entity model
│   └── repositories/            # Data access layer
│       ├── auth_repository.dart
│       ├── order_repository.dart
│       └── restaurant_repository.dart
└── presentation/                # UI layer
    └── screens/                 # Application screens
        ├── auth/                # Authentication screens
        │   ├── login_screen.dart
        │   └── signup_screen.dart
        ├── home/                # Main dashboard
        │   └── home_screen.dart
        ├── restaurant/          # Restaurant browsing
        │   └── restaurant_details_screen.dart
        ├── cart/                # Shopping cart management
        │   └── cart_screen.dart
        ├── order_place/         # Order placement
        │   └── order_place_screen.dart
        └── orders/              # Order management
            └── my_orders_screen.dart
```

## Screens Overview

### Authentication

- **Login Screen** (`login_screen.dart`): Secure authentication interface for users to access the
  app
- **Signup Screen** (`signup_screen.dart`): User registration interface for creating new accounts

### Main Application

- **Home Screen** (`home_screen.dart`): Main dashboard displaying featured restaurants, categories,
  and promotions with search functionality

### Restaurant & Menu

- **Restaurant Details Screen** (`restaurant_details_screen.dart`): Detailed view of restaurant
  information, menu items, ratings, and reviews

### Shopping & Orders

- **Cart Screen** (`cart_screen.dart`): Shopping cart management with item quantity adjustment and
  order summary
- **Order Place Screen** (`order_place_screen.dart`): Checkout interface for finalizing orders with
  delivery details and payment options
- **My Orders Screen** (`my_orders_screen.dart`): Order history and tracking interface showing past
  and current orders

## BLoC State Management

The application uses the BLoC (Business Logic Component) pattern for predictable state management:

### Authentication BLoC

- **Purpose**: Manages user authentication state, login/logout processes, and user session
  management
- **Events**: Login requests, signup actions, logout actions, authentication status checks
- **States**: Authenticated, unauthenticated, loading states with user data
- **Repository**: `AuthRepository` for handling authentication API calls and user data

### Cart BLoC

- **Purpose**: Handles shopping cart operations including adding, removing, and updating items
- **Events**: Add to cart, remove from cart, update quantity, clear cart actions
- **States**: Cart loading, loaded with items, empty cart states
- **Features**: Item quantity management, price calculations, cart persistence

### Order BLoC

- **Purpose**: Manages all order-related operations from placement to tracking
- **Events**: Place order, fetch order history, update order status, cancel orders
- **States**: Order processing, placed, confirmed, delivered states with order details
- **Repository**: `OrderRepository` for order data operations and status updates

### Menu BLoC

- **Purpose**: Handles restaurant menu data and item browsing functionality
- **Events**: Fetch menu items, filter by category, search items
- **States**: Menu loading, loaded with items, error states

### Order History BLoC

- **Purpose**: Manages historical order data and tracking information
- **Events**: Fetch order history, filter orders, refresh order status
- **States**: History loading, loaded with orders, pagination states

### Restaurant BLoC

- **Purpose**: Handles restaurant discovery, search, and detailed information
- **Events**: Fetch restaurants, search restaurants, get restaurant details
- **States**: Restaurant listing, details view, search results states

## Data Handling

### Repository Pattern

The app implements the repository pattern for clean data access:

- **AuthRepository**: Handles user authentication, registration, token management, and session
  persistence
- **OrderRepository**: Manages order placement, tracking, history, and status updates with backend
  APIs
- **RestaurantRepository**: Handles restaurant data, menu items, search functionality, and ratings

### Data Models

- **UserModel**: User entity containing profile information, preferences, and authentication data
- **RestaurantModel**: Restaurant entity with details, location, ratings, and operational
  information
- **MenuItemModel**: Menu item entity including pricing, descriptions, images, and availability
- **CartModel**: Shopping cart entity managing selected items, quantities, and calculations
- **OrderModel**: Comprehensive order entity containing delivery details, items, payment info, and
  tracking status

### Key Features

- **Secure Authentication**: User registration and login with session management
- **Restaurant Discovery**: Browse and search restaurants with filtering options
- **Interactive Menu**: Add items to cart with customization options
- **Smart Cart Management**: Real-time price calculations and item management
- **Order Tracking**: Complete order lifecycle from placement to delivery
- **Order History**: Access to past orders with reorder functionality
- **Clean Architecture**: Separation of concerns with BLoC pattern and repository design
- **Responsive UI**: Modern interface built with Material Design principles
- **State Persistence**: Cart and user session data persistence across app launches
