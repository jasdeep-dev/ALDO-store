# Inventory Management App

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [API Documentation](#api-documentation)
- [License](#license)
- [Contact](#contact)

## Introduction

The Inventory Management App is a dynamic tool designed to provide real-time updates to the stock levels of products in a store for a specific model.

## Features

- View inventory data with pagination
- Real-time notifications and toasts for out of stock and low stocks products.
- User-friendly interface with responsive design
- View Store data
- View Shoe Model data

## Installation

Follow these steps to install and run the app locally using Docker.


### Prerequisites

- [Docker](https://www.docker.com/get-started)

### Instructions

1. Clone the project repository.
2. Navigate to the project directory.
3. Run `make setup` to set up the project.
4. Use `make start` to start the application.
5. Use `make inventory_sale` to start the websocket to send out the updates.

### Setup
  - `make setup`: Builds the Docker containers and sets up the Rails project.

### Database Management
  - `make reset`: Resets the database, dropping and recreating it.
  - `make migrate`: Runs pending database migrations.
  - `make rollback`: Rolls back the last database migration.

### Running the Application
  - `make start`: Starts the Docker containers and runs the Rails application.
  - `make stop`: Stops the Docker containers.
  - `make restart`: Restarts the Docker containers.

### Start the Socket Connection for the inventory Sale
  - `make sale`: Restarts the Docker containers.

### Other Commands
  - `make console`: Opens a Rails console within the Docker container.
  - `make test`: Runs RSpec tests for controllers and models.
  - `make swagger`: Generates Swagger documentation for the API endpoints.
  - `make install`: Installs Ruby and JavaScript dependencies.
  - `make bash`: Open backend service bash.

## Usage

### Viewing Inventory

1. Open your browser and navigate to `http://localhost:3000` (or the port your React app is running on).
2. You will see the list of inventory items. Use the pagination controls to navigate through pages.
3. Use the "Items per page" dropdown to change the number of items displayed per page.
4. On the Left side, You can see the List of Stores and Shoe Models in the drawer.

## API Documentation

The documentation for the API endpoints is available at [http://localhost:8080/api-docs/index.html](http://localhost:8080/api-docs/index.html).
![](https://github.com/jasdeep-dev/ALDO-store/blob/main/Swagger.png)

## Test Coverage

![](https://github.com/jasdeep-dev/ALDO-store/blob/main/SimpleCov.png)

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Contact

For any questions or suggestions, feel free to open an issue or contact the project maintainer at jasdeepg21@gmail.com.
