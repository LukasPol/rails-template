def install_gem(gem_name, after: "group :development, :test do\n")
  inject_into_file 'Gemfile', after: do
    <<~RUBY
      \tgem '#{gem_name}'\n
    RUBY
  end
end

def rails_controller_testing
  return unless my_ask?('Would you like to install rails-controller-testing?')

  say 'Setting up rails-controller-testing...'
  install_gem('rails-controller-testing', after: "group :test do\n")
end

def ffaker
  return unless my_ask?('Would you like to install ffaker?')

  say 'Setting up ffaker...'
  install_gem('ffaker', after: "gem 'rspec-rails'\n")
end

def factory_bot_rails
  return unless my_ask?('Would you like to install factory_bot_rails?')

  factory_bot = true
  say 'Setting up factory_bot_rails...'
  if File.exist?('spec/support/factory_bot.rb')
    say "'spec/support/factory_bot.rb' already exists. Skipped creation."
  else
    install_gem('factory_bot_rails', after: "gem 'rspec-rails'\n")

    create_file 'spec/support/factory_bot.rb' do
      <<~RUBY
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
  end
end

def shoulda_matchers
  return unless my_ask?('Would you like to install shoulda_matchers?')

  shoulda_matchers = true
  say 'Setting up shoulda_matchers...'
  install_gem('shoulda-matchers', after: "group :test do\n")

  if File.exist?('spec/support/shoulda_matchers.rb')
    say "'spec/support/shoulda_matchers.rb' already exists. Skipped creation."
  else
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
  end
end

def database_cleaner
  return unless my_ask?('Would you like to install database_cleaner?')

  database_cleaner = true
  say 'Setting up database_cleaner...'
  install_gem('database_cleaner-active_record', after: "group :test do\n")

  if File.exist?('spec/support/database_cleaner.rb')
    say "'spec/support/database_cleaner.rb' already exists. Skipped creation."
  else
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
  end
end

def simplecov
  return unless my_ask?('Would you like to install simplecov?')

  simplecov = true
  say 'Setting up simplecov...'
  install_gem('simplecov')

  if File.exist?('spec/support/simplecov.rb')
    say "'spec/support/simplecov.rb' already exists. Skipped creation."
  else
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
  end
end

def setup_rspec
  return unless my_ask?('Would you like to install RSpec?')

  say 'Setting up RSpec...'

  install_gem('rspec-rails')

  # Install rails-controller-testing if chosen
  rails_controller_testing

  # Install ffaker if chosen
  ffaker

  # Install factory_bot_rails if chosen
  factory_bot_rails

  # Install shoulda_matchers if chosen
  shoulda_matchers

  # Install database_cleaner if chosen
  database_cleaner

  # Install simplecov if chosen
  simplecov

  say "\nRSpec and associated gems will be installed.\n"

  after_bundle do
    generate 'rspec:install'
    # if factory_bot || shoulda_matchers || database_cleaner || simplecov
      gsub_file 'spec/rails_helper.rb',
                "# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }", "Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }"
    # end
    file '.rspec', <<-END
    --color
    --require spec_helper
    END
    say "\nRSpec has been installed.\n"
  end
end

# setup_rspec
