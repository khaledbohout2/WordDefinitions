# iOS Dictionary App

This iOS application allows users to search for word definitions using the [Free Dictionary API](https://dictionaryapi.dev/). It is built using a Clean Architecture approach (Data, Domain, Presentation) with SwiftUI for the user interface.

## Architecture

The application follows a Clean Architecture pattern:

-   **Presentation:** Contains the UI (built with SwiftUI) and ViewModels (using MVVM). Includes a Coordinator for navigation. Utilizes Combine for reactive programming.
-   **Domain:** Contains the business logic and entities.
-   **Data:** Handles data sources, including network requests (using URLSession and Moya) and local data caching (using Core Data).

The application adopts an **offline-first** approach, prioritizing cached data when available.

## Features

-   Search for word definitions.
-   Displays definitions fetched from the Dictionary API.
-   Caches previously searched word definitions in a local database (Core Data).
-   Functions offline by utilizing cached data.
-   Displays a list of past searches.
-   Allows re-fetching definitions for past searches when online.
-   User-friendly and responsive UI built with SwiftUI.
-   Proper error handling for network requests and data operations.

## Technologies Used

-   Swift
-   SwiftUI
-   Combine
-   Core Data
-   URLSession
-   Moya (for networking)
-   Coordinator pattern for navigation
-   MVVM architecture

## Requirements

-   Xcode 15 or later
-   iOS 16 or later

## Setup and Installation

1.  Clone the repository:
    ```bash
    git clone [repository_url]
    cd [project_directory]
    ```
2.  Open the `iOS Dictionary App.xcodeproj` file in Xcode.
3.  Build and run the application on a simulator or a physical iOS device.
                                                                                                 ---

## Project Structure
                                                                                                 iOS Dictionary App/
                                                                                                 ├── Data/
                                                                                                 │   ├── DataSources/
                                                                                                 │   │   ├── Local/
                                                                                                 │   │   │   └── CoreData/
                                                                                                 │   │   └── Remote/
                                                                                                 │   │       └── NetworkService/
                                                                                                 │   ├── Repositories/
                                                                                                 ├── Domain/
                                                                                                 │   ├── Entities/
                                                                                                 │   ├── Interfaces/
                                                                                                 │   └── UseCases/
                                                                                                 ├── Presentation/
                                                                                                 │   ├── Components/
                                                                                                 │   ├── Scenes/
                                                                                                 │   │   ├── DefinitionDetail/
                                                                                                 │   │   ├── Search/
                                                                                                 │   │   └── SearchHistory/
                                                                                                 │   ├── ViewModels/
                                                                                                 │   └── Coordinator/
                                                                                                 └── iOS Dictionary App.swift
                                                                                                 *(Note: This is a general representation and the actual structure might vary slightly.)*

                                                                                                 ## Contributing

                                                                                                 Contributions are welcome! Please feel free to submit pull requests with improvements or bug fixes. For major changes, please open an issue first to discuss what you would like to change.

                                                                                                 ---
