def install_gem(gem_name, after: "group :development, :test do\n")
  inject_into_file 'Gemfile', after: do
    <<~RUBY
      \tgem '#{gem_name}'\n
    RUBY
  end
end

def file_configuration(name_file)
  Net::HTTP.get(URI("https://raw.githubusercontent.com/LukasPol/rails-template/develop/helpers/#{name_file}.rb"))
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

  say 'Setting up factory_bot_rails...'

  if File.exist?('spec/support/factory_bot.rb')
    say "'spec/support/factory_bot.rb' already exists. Skipped creation."
  else
    install_gem('factory_bot_rails', after: "gem 'rspec-rails'\n")

    factory_bot_configuration = file_configuration('factory_bot')
    create_file 'spec/support/factory_bot.rb', factory_bot_configuration

    say "Created 'spec/support/factory_bot.rb'."
  end
end

def shoulda_matchers
  return unless my_ask?('Would you like to install shoulda_matchers?')

  say 'Setting up shoulda_matchers...'

  if File.exist?('spec/support/shoulda_matchers.rb')
    say "'spec/support/shoulda_matchers.rb' already exists. Skipped creation."
  else
    install_gem('shoulda-matchers', after: "group :test do\n")

    shoulda_matchers_configuration = file_configuration('shoulda_matchers')
    create_file 'spec/support/shoulda_matchers.rb', shoulda_matchers_configuration

    say "Created 'spec/support/shoulda_matchers.rb'."
  end
end

def database_cleaner
  return unless my_ask?('Would you like to install database_cleaner?')

  say 'Setting up database_cleaner...'

  if File.exist?('spec/support/database_cleaner.rb')
    say "'spec/support/database_cleaner.rb' already exists. Skipped creation."
  else
    install_gem('database_cleaner-active_record', after: "group :test do\n")

    database_cleaner_configuration = file_configuration('database_cleaner')
    create_file 'spec/support/database_cleaner.rb', database_cleaner_configuration

    say "Created 'spec/support/database_cleaner.rb'."
  end
end

def simplecov
  return unless my_ask?('Would you like to install simplecov?')

  say 'Setting up simplecov...'

  if File.exist?('spec/support/simplecov.rb')
    say "'spec/support/simplecov.rb' already exists. Skipped creation."
  else
    install_gem('simplecov')

    simplecov_configuration = file_configuration('simplecov')
    create_file 'spec/support/simplecov.rb', simplecov_configuration

    say "Created 'spec/support/simplecov.rb'."
  end
end

def after_bundle_rspec
  after_bundle do
    generate 'rspec:install'

    gsub_file 'spec/rails_helper.rb',
              "# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }", "Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }"

    file '.rspec', <<-END
    --color
    --require spec_helper
    END
    say "\nRSpec has been installed.\n"
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

  after_bundle_rspec
end

setup_rspec
