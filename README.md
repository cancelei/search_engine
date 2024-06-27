# 🚀 Awesome Eco-Friendly Meta-SearchEngine

Welcome to **Awesome Eco Friendly Meta-SearchEngine**, the coolest search engine on the block, built with Ruby on Rails and powered by the Bing, Google and Brave Search APIs! We want to plant trees with our ads revenue.🌳

## Prerequisites

Before you begin, make sure you have the following installed:

- Ruby (3.2.4)
- Rails (7.1.3.4)
- PostgreSQL
- Redis (For Background Jobs)

In the future also:
- Node.js
- Yarn

## Getting Started

1. **Clone the repository**

    ```sh
    git clone https://github.com/yourusername/search_engine.git
    cd search_engine
    ```

2. **Install dependencies**

    ```sh
    bundle install
    ```

3. **Set up the database**

    ```sh
    rails db:create
    rails db:migrate
    ```

4. **Configure your environment variables**

    Rename `.env.erb` to `.env` and fill in the necessary details:

    ```env
    BING_API_KEY=your_bing_api_key_here

    GOOGLE_API_KEY=your_google_api_key_here
    GOOGLE_CX_KEY=your_google_search_engine_id_here

    BRAVE_API_KEY=your_brave_api_key_here
    ```

5. **Run the app**

    ```sh
    bin/dev
    ```

    This command will spin up your Rails server and the frontend environment. Open your browser and navigate to `http://localhost:3000` to see the magic happen!

![Meme](https://media.giphy.com/media/d2jjuAZzDSVLZ5kI/giphy.gif)

## Features

- **Search Functionality**: Harness the power of Bing, Google and Brave Search API to fetch the search results.
- **User Authentication**: Sign up, sign in, and edit your profile.
- **Search History**: Registered users can view their search history.
- **Tailwind CSS Styling**: Beautifully styled with Tailwind CSS.

## Project Structure

- **Controllers**: `app/controllers`
- **Models**: `app/models`
- **Views**: `app/views`
- **Styles**: `app/assets/stylesheets`
- **JavaScript**: `app/javascript`

## Contributing

Feel free to fork this repository and send a pull request with your changes. We welcome all contributions!

![Meme](https://media.giphy.com/media/l0HlTy9x8FZo0XO1i/giphy.gif)

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

Happy coding! ✨

![Meme](https://media.giphy.com/media/5VKbvrjxpVJCM/giphy.gif)
