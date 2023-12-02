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
