def setup_rspec
  return unless my_ask?('Would you like to install RSpec?')

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

  say "\nRSpec and associated gems will be installed.\n"

  after_bundle do 
    generate 'rspec:install'
    if factory_bot || shoulda_matchers || database_cleaner || simplecov
      gsub_file 'spec/rails_helper.rb', "# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }", "Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }"
    end
    file '.rspec', <<-END
  --color
  --require spec_helper
  END
    say "\nRSpec has been installed.\n"
  end
end

setup_rspec
