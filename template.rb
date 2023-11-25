# Check if Ruby version meets the minimum requirement
unless Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2.7')
  raise Thor::Error, "You need at least Ruby 2.7 to install this Rails application."
end

# Check if Rails version meets the minimum requirement
unless Gem::Version.new(Rails::VERSION::STRING) >= Gem::Version.new('7.0')
  raise Thor::Error, "You need Rails 7.0 to install this Rails application."
end

# Check if Bundler is installed
unless system('which bundle > /dev/null')
  raise Thor::Error, "Bundler is not installed. Please install Bundler by running 'gem install bundler' and try again."
end

# Method for interactive questions with a default option
def my_ask?(question, default = false)
  default_str = default ? ' [Y/n]' : ' [y/N]'
  answer = ask("\n#{question}#{default_str}").downcase
  return default if answer.empty?

  ['yes', 'y'].include?(answer.downcase)
end

say "Setting up your Rails application with additional configurations..."

# Add dotenv-rails gem to development and test groups
gem 'dotenv-rails', groups: [:development, :test]

say "\n"
# Setup database configurations
apply 'https://raw.githubusercontent.com/LukasPol/rails-template/develop/database_config.rb'


say "\n"
# Add gitignore entries
apply 'https://raw.githubusercontent.com/LukasPol/rails-template/develop/gitignore.rb'

say "\n"
# Optionally install RSpec
apply 'https://raw.githubusercontent.com/LukasPol/rails-template/develop/rspec.rb'

say "\n"
# Optionally install Rubocop
apply 'https://raw.githubusercontent.com/LukasPol/rails-template/develop/rubocop.rb'

after_bundle do
  if my_ask?('Would you like me to make the first commit?')
    # Git
    git :init
    git add: "."
    git commit: "-m 'Initial commit with template from https://github.com/LukasPol/rails-template'"
  end
end

say "Your Rails application has been configured successfully! Run 'rails db:create' to create the database."
