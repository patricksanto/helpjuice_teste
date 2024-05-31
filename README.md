# Helpjuice Search Application

This is a simple Ruby on Rails application that allows users to perform searches and track popular search queries. It leverages ActiveJob and Sidekiq for handling search logging asynchronously and utilizes Turbo Streams and Turbo Frames for dynamic updates.

## Features

- **Search Functionality**: Users can search for articles by title or content.
- **Search Logging**: Search queries are logged asynchronously to track popular searches.
- **Turbo Streams**: Dynamic updates to the search results without full page reloads.
- **Search Normalization**: Queries are normalized (trimmed and downcased) to ensure consistency.

## Requirements

- Ruby 3.2.0
- Rails 7.1.3.3
- PostgreSQL (or another supported database)
- Redis (for background job processing with Sidekiq)
- Node.js (for managing JavaScript dependencies)

## Getting Started

### Installation

1. Clone the repository:

2. Install the dependencies:

    ```sh
    bundle install
    ```

3. Set up the database:

    ```sh
    rails db:create
    rails db:migrate
    rails db:seed
    ```

4. Start the server with `bin/dev`:

    ```sh
    bin/dev
    ```

    This will start both the Rails server and any JavaScript dependencies needed.

5. Start Sidekiq for background job processing:

    ```sh
    bundle exec sidekiq
    ```
    redis-server
### Running Tests

To run the test suite, use:

```sh
bundle exec rspec
