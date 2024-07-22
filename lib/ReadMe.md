# Project Documentation

## Table of Contents

1. [Overview](#overview)
2. [Main Libraries](#main-libraries)
3.[project Architecture](#project_architecture)
4.[Project Structure](#project-structure)
    - [Key Files](#key-files)
    - [Key Classes](#key-classes)
    - [Key Functions](#key-functions)
5[Background Tasks](#background-tasks)
6[Environment Configuration](#environment-configuration)
7[Network Status Checking](#network-status-checking)

## Overview

This project features a dynamic user interface driven by JSON configurations, providing a flexible and customizable user experience.
It also includes robust offline support and utilizes Workmanager for handling periodic tasks, ensuring reliable performance even when the application is not actively in use.

## Main Libraries

- **Flutter**: A comprehensive UI toolkit for crafting natively compiled applications with expressive and flexible designs.
- **SQLite**: A lightweight, serverless, self-contained SQL database engine for efficient local data storage.
- **Workmanager**: A Flutter plugin for managing background tasks, enabling execution even when the app is not in use.
- **Cubit**: A state management solution for efficient and scalable application state management.
- **GoRouter**: A flexible routing solution for navigating within the application.

## Project Architecture
This project adheres to the MVVM (Model-View-ViewModel) architecture, encompassing three distinct layers: Data, Domain, and Presentation.
Additionally, the Infrastructure module consolidates utilities, application configuration, constants, routes and other files necessary for the overall functionality of the project.

## Project Structure

### Key Files

- **`main.dart`**:
    - Entry point of the application.
    - Initializes the SQLite database.
    - Configures the environment.
    - Registers periodic synchronization tasks for form responses and images.
    - Launches the application.

- **`form_respo_impl.dart`**:
    - Contains the `FormResponseRepository` class.
    - Manages fetching form responses from the API.
    - Stores form responses locally.
    - Synchronizes form responses with the remote server.

- **`sync_view_model.dart`**:
    - Contains the `SyncViewModel` class.
    - Manages data and image synchronization with the server.

### Key Classes

- **`SqfLiteHelper`**:
    - Manages SQLite operations.
    - Handles database initialization, table creation, form response insertion, and retrieval.

- **`FormResponseRepository`**:
    - Centralizes logic for interacting with form responses.
    - Fetches from the API, inserts into the local database, and synchronizes with the remote server.

- **`SyncViewModel`**:
    - Orchestrates the synchronization process.
    - Manages data and image transfers to and from the server.

### Key Functions

- **`initializeSqlDB()`**:
    - Initializes the SQLite database, ensuring readiness for subsequent operations.

- **`insertFormResponse()`**:
    - Inserts a new form response into the local database.

- **`fetchFormResponse()`**:
    - Retrieves all stored form responses from the local database.

- **`syncDataToServer()`**:
    - Initiates data synchronization with the remote server.

- **`syncImageToServer()`**:
    - Initiates image synchronization with the remote server.

## Background Tasks

The application leverages Workmanager to schedule two periodic tasks, configured to run every 15 minutes when the device is connected to the internet:

- **`post_data_sync`**: Synchronizes data with the server.
- **`s3_image_sync`**: Synchronizes images with the server.

## Environment Configuration

The application adapts its behavior based on the deployment environment using environment variables. The `ENVIRONMENT` variable determines the specific settings to apply.

## Network Status Checking

Before executing background tasks, the application checks the network status to ensure the device is connected to the internet. This ensures background tasks are only executed when an active internet connection is available.

