def setup_rubocop
  return unless my_ask?('Would you like to install Rubocop?')

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

setup_rubocop
