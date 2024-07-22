# Project Documentation

## Overview

This project is a Flutter application designed to streamline data collection and synchronization processes. It incorporates several key features including local data storage using SQLite, background task management with Workmanager, network status monitoring, and data synchronization with a remote server.

## Main Libraries

- **Flutter**: A comprehensive UI toolkit for crafting natively compiled applications with expressive and flexible designs.
- **SQLite**: A lightweight, serverless, self-contained SQL database engine used for efficient local data storage within the application.
- **WorkManager**: A Flutter plugin used for managing background tasks, enabling the execution of tasks even when the application is not actively in use.
- **Provider**: A state management solution facilitating efficient and scalable management of application state.
- **GoRouter**: A flexible routing solution aiding in the navigation within the application.

## Key Files

- **`main.dart`**: Serving as the entry point of the application, this file orchestrates various essential tasks such as initializing the SQLite database, configuring the environment, registering periodic synchronization tasks for both form responses and images, and ultimately launching the application.
- **`form_response_repository.dart`**: Housing the `FormResponseRepository` class, this file encapsulates functionalities related to fetching form responses from the API, storing form responses locally in the database, and synchronizing form responses with the remote server.
- **`sync_view_model.dart`**: Containing the `SyncViewModel` class, this file governs the synchronization of data and images with the server.

## Key Classes

- **`SqfLiteHelper`**: Responsible for managing SQLite-related operations, including database initialization, table creation, insertion of form responses, and retrieval of form responses.
- **`FormResponseRepository`**: Centralizes the logic for interacting with form responses, including fetching from the API, insertion into the local database, and synchronization with the remote server.
- **`SyncViewModel`**: Orchestrates the synchronization process, managing the transfer of both data and images to and from the server.

## Key Functions

- **`initializeSqlDB()`**: Initializes the SQLite database, ensuring that it is ready for subsequent operations.
- **`insertFormResponse()`**: Inserts a new form response into the local database.
- **`fetchFormResponse()`**: Retrieves all stored form responses from the local database.
- **`syncDataToServer()`**: Initiates the synchronization of data with the remote server.
- **`syncImageToServer()`**: Initiates the synchronization of images with the remote server.

## Background Tasks

The application leverages Workmanager to schedule two periodic tasks, configured to run every 15 minutes when the device is connected to the internet:
- **`response_sync`**: Responsible for synchronizing data with the server.
- **`image_sync`**: Responsible for synchronizing images with the server.

## Environment Configuration

Environment configuration enables the application to adapt its behavior based on the deployment environment. This flexibility is achieved by utilizing environment variables, with the `ENVIRONMENT` variable determining the specific settings to be applied.

## Network Status Checking

Prior to executing background tasks, the application performs a network status check to ascertain whether the device is connected to the internet. This preemptive check ensures that background tasks are only executed when an active internet connection is available.

This documentation provides an overview of the project's architecture, highlighting key functionalities, classes, and components. For a more comprehensive understanding, detailed documentation covering all project files and classes should be consulted.