# Method for interactive questions with a default option
def my_ask?(question, default: false)
  default_str = default ? ' [Y/n]' : ' [y/N]'
  answer = ask("\n#{question}#{default_str}").downcase
  return default if answer.empty?

  %w[yes y].include?(answer.downcase)
end

say 'Setting up your Rails application with additional configurations...'

say "\n"
# Setup database configurations
apply 'https://raw.githubusercontent.com/LukasPol/rails-template/develop/database_config.rb'

say "\n"
# Add gitignore entries
apply 'https://raw.githubusercontent.com/LukasPol/rails-template/develop/gitignore.rb'

say "\n"
# Optionally install RSpec
apply 'https://raw.githubusercontent.com/LukasPol/rails-template/develop/rspec.rb'
# require_relative 'rspec'
# setup_rspec

say "\n"
# Optionally install Rubocop
apply 'https://raw.githubusercontent.com/LukasPol/rails-template/develop/rubocop.rb'

after_bundle do
  if my_ask?('Would you like me to make the first commit?')
    # Git
    git :init
    git add: '.'
    git commit: "-m 'Initial commit with template from https://github.com/LukasPol/rails-template'"
  end
end

say "Your Rails application has been configured successfully! Run 'rails db:create' to create the database."
