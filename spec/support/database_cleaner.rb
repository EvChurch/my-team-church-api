# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.around do |each|
    DatabaseCleaner.cleaning do
      MultiTenant.with(respond_to?(:account) ? account : create(:account)) do
        each.run
      end
    end
  end
end
