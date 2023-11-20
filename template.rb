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
  answer = ask("#{question}#{default_str}").downcase
  return default if answer.empty?

  ['yes', 'y'].include?(answer.downcase)
end

say "Setting up your Rails application with additional configurations..."

# Add dotenv-rails gem to development and test groups
gem 'dotenv-rails', groups: [:development, :test]

# Setup database configurations
if options[:database] != 'sqlite3'
  say "Creating .env and .env.sample files with information about the database..."
  envs_default = <<~TXT
    DATABASE_HOST=localhost
    DATABASE_USERNAME=postgres
    DATABASE_PASSWORD=postgres
  TXT
  # Setup .env.development
  create_file '.env', envs_default
  create_file '.env.sample', envs_default

  # Modify database.yml
  say "Configuring config/database.yml..."
  inject_into_file "config/database.yml", after: "default: &default\n" do
    <<~RUBY
      \thost: '<%= ENV['DATABASE_HOST'] %>'
      \tusername: '<%= ENV['DATABASE_USERNAME'] %>'
      \tpassword: '<%= ENV['DATABASE_PASSWORD'] %>'
    RUBY
  end
  say "config/database.yml configured!"
end

# Add gitignore entries
say "Setting up .gitignore..."
append_file ".gitignore", <<~TXT
  # Ignore .env file containing credentials.
  .env

  # Ignore Mac and Linux file system files
  *.swp
  .DS_Store

  # Editor/IDE
  .vscode/
  .idea/
TXT

# Optionally install RSpec
if my_ask?('Would you like to install RSpec?')
  say "Setting up RSpec..."
  inject_into_file "Gemfile", after: "group :development, :test do\n" do
    <<~RUBY
      \tgem 'rspec-rails'
    RUBY
  end

  # Install rails-controller-testing if chosen
  if my_ask?('Would you like to install rails-controller-testing?')
    say "Setting up rails-controller-testing..."
    inject_into_file "Gemfile", after: "group :test do\n" do
      <<~RUBY
        \tgem 'rails-controller-testing'
      RUBY
    end
  end

  # Install ffaker if chosen
  if my_ask?('Would you like to install ffaker?')
    say "Setting up ffaker..."
    inject_into_file "Gemfile", after: "gem 'rspec-rails'\n" do
      <<~RUBY
        \tgem 'ffaker'
      RUBY
    end
  end

  # Install factory_bot_rails if chosen
  if my_ask?('Would you like to install factory_bot_rails?')
    factory_bot = true
    say "Setting up factory_bot_rails..."
    unless File.exist?('spec/support/factory_bot.rb')
      inject_into_file "Gemfile", after: "gem 'rspec-rails'\n" do
        <<~RUBY
          \tgem 'factory_bot_rails'
        RUBY
      end
      create_file 'spec/support/factory_bot.rb' do <<~RUBY
        FactoryBot.use_parent_strategy = true

        FactoryBot.define do
          sequence :email do |n|
            "person\#{n}@example.com"
          end
        end

        RSpec.configure do |config|
          config.include FactoryBot::Syntax::Methods
        end

        FactoryBot::SyntaxRunner.class_eval do
          include ActionDispatch::TestProcess
        end
      RUBY
      end
      say "Created 'spec/support/factory_bot.rb'."
    else
      say "'spec/support/factory_bot.rb' already exists. Skipped creation."
    end
  end
  
  # Install shoulda_matchers if chosen
  if my_ask?('Would you like to install shoulda_matchers?')
    shoulda_matchers = true
    say "Setting up shoulda_matchers..."
    inject_into_file "Gemfile", after: "group :test do\n" do
      <<~RUBY
        \tgem 'shoulda-matchers'
      RUBY
    end

    unless File.exist?('spec/support/shoulda_matchers.rb')
      create_file 'spec/support/shoulda_matchers.rb' do
        <<~RUBY
        Shoulda::Matchers.configure do |config|
          config.integrate do |with|
            with.test_framework :rspec
            with.library :rails
          end
        end
        RUBY
      end
      say "Created 'spec/support/shoulda_matchers.rb'."
    else
      say "'spec/support/shoulda_matchers.rb' already exists. Skipped creation."
    end
  end

  # Install database_cleaner if chosen
  if my_ask?('Would you like to install database_cleaner?')
    database_cleaner = true
    say "Setting up database_cleaner..."
    inject_into_file "Gemfile", after: "group :test do\n" do
      <<~RUBY
        \tgem 'database_cleaner-active_record'
      RUBY
    end

    unless File.exist?('spec/support/database_cleaner.rb')
      create_file 'spec/support/database_cleaner.rb' do
        <<~RUBY
        RSpec.configure do |config|
          config.before(:all) do
            DatabaseCleaner.clean_with :truncation  # clean DB of any leftover data
            DatabaseCleaner.strategy = :transaction # rollback transactions between each test
            # Rails.application.load_seed # (optional) seed DB
          end
        
          config.before(:all) do
            DatabaseCleaner.strategy = :transaction
          end
        
          config.before(:all) do
            DatabaseCleaner.start
          end
        
          config.after(:all) do
            DatabaseCleaner.clean
          end
        end
        RUBY
      end
      say "Created 'spec/support/database_cleaner.rb'."
    else
      say "'spec/support/database_cleaner.rb' already exists. Skipped creation."
    end
  end

  if my_ask?('Would you like to install simplecov?')
    simplecov = true
    say "Setting up simplecov..."
    inject_into_file "Gemfile", after: "group :development, :test do\n" do
      <<~RUBY
        \tgem 'simplecov', require: false
      RUBY
    end

    unless File.exist?('spec/support/simplecov.rb')
      create_file 'spec/support/simplecov.rb' do
        <<~RUBY
        require 'simplecov'

        SimpleCov.start 'rails' if ENV['RSPEC_COVERAGE'] do
          # minimum_coverage 50
          add_filter %w[app/assets app/channels app/javascript app/jobs app/mailers app/views]
        end
        RUBY
      end
      say "Created 'spec/support/simplecov.rb'."
    else
      say "'spec/support/simplecov.rb' already exists. Skipped creation."
    end
  end

  say "RSpec and associated gems will be installed."

  after_bundle do 
    generate 'rspec:install'
    if factory_bot || shoulda_matchers || database_cleaner || simplecov
      gsub_file 'spec/rails_helper.rb', "# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }", "Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }"
    end
    file '.rspec', <<-END
  --color
  --require spec_helper
  END
    say "RSpec has been installed."
  end
end

# Optionally install Rubocop
if my_ask?('Would you like to install Rubocop?')
  inject_into_file "Gemfile", after: "group :development, :test do\n" do
    <<~RUBY
      \tgem 'rubocop', require: false
    RUBY
  end

  after_bundle do
    run 'rubocop --auto-gen-config'
    say "RuboCop has been set up in your Rails application!"
  end
end

after_bundle do
  if my_ask?('Would you like me to make the first commit?')
    # Git
    git :init
    git add: "."
    git commit: "-m 'Initial commit with template from https://github.com/LukasPol/rails-template'"
  end
end

say "Your Rails application has been configured successfully! Run 'rails db:create' to create the database."
