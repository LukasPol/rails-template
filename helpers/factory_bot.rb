FactoryBot.use_parent_strategy = true

FactoryBot.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

FactoryBot::SyntaxRunner.class_eval do
  include ActionDispatch::TestProcess
end
