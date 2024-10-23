# Movie Finder App

## Overview

The Movie Finder App is a Flutter application that provides a clean and modern user interface for browsing and searching for movies. Users can explore popular movies, search for specific titles, and view detailed information about each movie, including ratings and synopses.

## Features

### User Interface
- **Home Screen**: Displays a list of popular movies with posters, titles, and ratings.
- **Search Screen**: Users can search for movies by title or year.
- **Movie Details Screen**: Shows detailed information about a selected movie, including synopsis and rating.

### Functionality
- **Popular Movies**: Fetch a list of movies using the OMDb API's search functionality.
- **Search Movies**: Implement a search bar that allows users to find movies by title or year.
- **Movie Details**: Display detailed information and the rating when a movie is selected.

### Third-Party API
- Utilizes the OMDb API (sign up for a free API key at [OMDb API](http://www.omdbapi.com/)).
- Implement error handling for API requests.

### State Management
- Uses a state management solution Bloc & Cubit.

### Additional Features
- **Favorites**: Allow users to save favorite movies locally using shared preferences.
- **Dark Mode**: Includes a dark mode switch in appbar for better accessibility.

## Technical Requirements
- Utilize Flutter's Material Design components for consistency.
- App is responsive and visually appealing on different screen sizes.

## Getting Started

### Prerequisites
- Flutter SDK
- Dart SDK
- An IDE (e.g., Android Studio, Visual Studio Code)

### Installation
1. Clone the repository:
   git clone https://github.com/ominfowave/movie_finder_app_pract.git
2. Navigate to the project directory:
   cd movie_finder_app
3. Install dependencies:
   flutter pub get
4. Sign up for an API key at OMDb API and add it to your project in apiUtils apiKey. 

### Running the App
   To run the app, use:
   flutter run
### Usage
Explore popular movies on the Home Screen.
Use the Search Screen to find movies by title or year.
Click on a movie to view detailed information.

### Acknowledgments
OMDb API for movie data.
Flutter community for resources and support.
   Feel free to customize the sections as needed!
