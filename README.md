# 🍽️ SUFRA — Restaurant Ordering App

SUFRA is a modern restaurant ordering mobile application built with **Flutter**, designed with scalability, clean architecture, and customization in mind.

The project demonstrates a complete restaurant ordering experience — from authentication and product discovery to favorites, cart management, checkout, orders, and payment integration.

> 🚧 **Project Status:** Under active development.  
> The application currently includes development and sandbox integrations and is being continuously improved toward production readiness.

---

## ✨ Features

- 🔐 User Registration & Login
- 🔥 Firebase Authentication
- ☁️ Cloud Firestore Integration
- 🏪 Multi-Branch Support
- 🍔 Dynamic Products & Categories
- ⭐ Featured, Popular & Latest Products
- 🔎 Product Search
- ⚙️ Product Options & Customization
- ❤️ Favorites
- 🛒 Shopping Cart
- 🔢 Quantity Management
- 👤 User Profile Management
- 📦 Checkout Flow
- 🧾 Order Creation & Order History
- 💳 Online Payment Integration
- 🔒 3D Secure Payment Testing
- 🔔 Notifications Architecture
- 📱 Responsive Flutter UI
- 🌐 Backend Integration with Firebase Cloud Functions

---

## 🏗️ Architecture

SUFRA follows **Clean Architecture principles** with feature-based organization.

Each major feature is separated into:

```text
feature/
├── data/
│   ├── data_sources/
│   ├── models/
│   └── repositories/
│
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── use_cases/
│
└── presentation/
    ├── cubit/
    ├── views/
    └── widgets/
```

This structure helps keep business logic separated from UI and external data sources, making the application easier to maintain, test, and scale.

---

## 🛠️ Tech Stack

| Technology | Usage |
|---|---|
| Flutter | Cross-platform mobile development |
| Dart | Application programming language |
| Cubit / BLoC | State management |
| Firebase Authentication | User authentication |
| Cloud Firestore | Cloud database |
| Firebase Cloud Functions | Server-side order logic |
| GetIt | Dependency injection |
| Moyasar | Payment integration & sandbox testing |
| Git & GitHub | Version control |

---

## 🔥 Firebase Integration

Firebase is used across the application for authentication, data management, and backend functionality.

Current Firestore structure includes:

```text
users/
products/
categories/
branches/
orders/

users/{uid}/favorites/
```

The application keeps authentication and user data connected through the Firebase user UID.

---

## 💳 Payment Integration

SUFRA includes a payment flow integrated with **Moyasar** for development and sandbox testing.

The current implementation includes:

- Card payment UI
- Sandbox transactions
- 3D Secure testing
- Payment result handling
- Checkout integration

> Payment functionality shown in this repository is currently intended for development and sandbox testing. Production payment verification and deployment require merchant-specific backend configuration.

---

## ☁️ Backend Order Flow

Order creation is designed to move important calculations to the backend using Firebase Cloud Functions.

```text
Flutter App
     ↓
Checkout
     ↓
Cloud Function
     ↓
Validate Products
     ↓
Calculate Trusted Prices
     ↓
Create Order
     ↓
Firestore
```

This reduces reliance on client-side price calculations and provides a stronger foundation for production order processing.

---

## 📂 Main Features

```text
lib/features/

authentication/
branches/
cart/
favorites/
home/
main_navigation/
notifications/
orders/
payment/
products/
profile/
```

Each feature is organized independently to support scalability and maintainability.

---

## 🎨 Customizable Restaurant Solution

SUFRA is designed as a customizable foundation for restaurant applications.

It can be adapted to different businesses by changing:

- Restaurant branding
- Logo and colors
- Products and categories
- Menu structure
- Product options
- Branches
- Pricing
- Business rules
- Checkout flow
- Payment configuration

This allows the same architecture to be adapted for different restaurant requirements.

---

## 📸 Screenshots

Application screenshots and demo media will be added here.

---

## 🚀 Current Development

The project is continuously being improved with upcoming work including:

- Google Maps & structured delivery addresses
- Push Notifications
- Improved backend payment verification
- Production security rules
- Admin Dashboard
- Testing
- CI/CD
- Store release configuration

---

## 👨‍💻 Developer

**Mohamed Ayman**  
Flutter Developer | Cross-Platform Mobile App Developer

📍 Saudi Arabia

Built with Flutter & Firebase.