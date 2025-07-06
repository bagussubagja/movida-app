# Movida App 🍿

![Slide 16_9 - 1 (3)](https://github.com/user-attachments/assets/a83a8794-8fa2-4c80-871a-a736624ea86d)

Movida App is a modern iOS application for discovering and tracking movies, built entirely with SwiftUI. This app is designed with a clean and scalable architecture, integrating cloud and local database technologies to create a feature-rich and high-performance user experience.

## ✨ Key Features

* **Authentication**: Sign Up and Sign In system using Firebase Authentication.
* **Discover & Search**: Discover trending movies and TV shows, as well as a search feature.
* **Movie Details**: Displays complete movie information, including synopsis, rating, and video trailers.
* **Personal Lists**:
  * **Favorites**: Save your favorite movies, with data stored in the cloud (Firestore).
  * **Watchlist**: Track movies you want to watch, with data stored locally (Realm) for fast access.
* **User Profile**: A profile page to manage data, movie lists, and app settings.
* **Dynamic Theme**: Adaptive UI that supports both **Light Mode** and **Dark Mode**.
* **Pull-to-Refresh**: Easily reload content on the main pages.

## 🛠️ Tech Stack & Architecture

This project is built with a focus on best practices and modern iOS technologies.

* **UI Framework**: **SwiftUI** (100% programmatic UI).
* **Architecture**: **Clean Architecture** (Data - Domain - Presentation) combined with the **MVVM** pattern.
* **Database**:
  * **Firebase Firestore**: For cloud-based, user-specific, synchronized data (e.g., Favorites).
  * **RealmDB**: For high-speed local data that doesn't require an internet connection (e.g., Watchlist).
* **Concurrency**: **Swift Concurrency** to efficiently handle network and database operations.
* **Navigation**: **NavigationStack** to manage complex navigation flows programmatically.
* **Dependency Injection**: A **ServiceLocator** pattern to manage and provide all dependencies centrally.
* **Authentication**: **Firebase Authentication** for secure user management.

## 🚀 Getting Started

To run this project locally:

1. **Clone this repository:**
   ```bash
   git clone https://github.com/bagussubagja/movida-app.git
   ```

2. **Open in Xcode:**
   * Open the `.xcodeproj` file.
   * Install dependencies if using Swift Package Manager.
   * Build and run the app (`Cmd + R`).
    
