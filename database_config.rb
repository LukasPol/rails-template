def setup_database_config
  return if options[:database] == 'sqlite3'

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

  say "config/database.yml configured!\n"
end

setup_database_config
