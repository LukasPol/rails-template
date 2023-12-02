require 'simplecov'

SimpleCov.start 'rails' if ENV['RSPEC_COVERAGE'] do
  # minimum_coverage 50
  add_filter %w[app/assets app/channels app/javascript app/jobs app/mailers app/views]
end
