# Rails Template

This enhanced template for Ruby on Rails projects provides a solid starting point with additional configurations and tools to boost your development experience.

## How to Use

1. Create a new Rails application using this template:
```bash
rails new myapp -m https://raw.githubusercontent.com/LukasPol/rails-template/main/template.rb
```

2. Follow the interactive prompts to customize your project. Choose options for RuboCop, RSpec, Factory Bot, and more.


## Configuration Details
### Database Configuration
The template configures the config/database.yml file, allowing you to set up the database connection parameters. If you've chosen a database other than SQLite, the template prompts you to provide details such as host, username, and password.

### RSpec Testing Framework

- RSpec: The template includes RSpec, a testing framework for Ruby. Write your tests in the spec directory.
- Factory Bot: FactoryBot is configured to easily create test data. Use it in conjunction with RSpec to create concise and readable tests.
- FFaker: A library for generating fake data to use in tests.
- Shoulda Matchers: Provides a set of useful matchers for RSpec, making it easier to write expressive and readable tests.
- Database Cleaner: Configured to clean the database between test runs, ensuring a clean slate for each test suite.

### Code Coverage with SimpleCov
- SimpleCov: Integrated to measure code coverage. View the coverage report by opening coverage/index.html in your browser after running your tests.

### RuboCop
- RuboCop: A static code analyzer and formatter, configured to enforce a consistent and clean code style.

### Feature Requests and Enhancements

Feel free to contribute to the improvement of this template! Below are some planned enhancements and feature requests:

1. [**Add Docker support to the template**](https://github.com/LukasPol/rails-template/issues/1)
   - Dockerizing the project for improved consistency and deployment.

2. [**Integrate RubyCritic for code analysis**](https://github.com/LukasPol/rails-template/issues/2)
   - Enhance code quality with RubyCritic.

3. [**Implement Foreman for process management**](https://github.com/LukasPol/rails-template/issues/3)
   - Streamline process management during development.

4. [**Integrate Devise for authentication**](https://github.com/LukasPol/rails-template/issues/4)
   - Include authentication functionality using Devise.

5. [**Include Simple Form for form generation**](https://github.com/LukasPol/rails-template/issues/5)
   - Streamline form creation with Simple Form.

6. [**Integrate Tailwind CSS for utility-first styling**](https://github.com/LukasPol/rails-template/issues/6)
   - Enhance styling capabilities using Tailwind CSS.

7. [**Implement Internationalization (I18n) for multilingual support**](https://github.com/LukasPol/rails-template/issues/7)
   - Enable multilingual support with I18n.

8. [**Create a new template specifically for API projects**](https://github.com/LukasPol/rails-template/issues/8)
   - Develop a template tailored for API projects.

Feel free to check the linked issues for more details and contribute to the discussion or implementation!

## Contributing

If you have any suggestions, bug reports, or improvements, feel free to open an issue or submit a pull request.

## License

This Rails template is open-source and available under the [MIT License](LICENSE).
