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

## Contributing

If you have any suggestions, bug reports, or improvements, feel free to open an issue or submit a pull request.

## License

This Rails template is open-source and available under the [MIT License](LICENSE).
